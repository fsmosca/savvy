using Chess, Chess.PGN, Chess.UCI, ArgParse

"Command line options"
function parse_commandline()
    s = ArgParseSettings()
    s.prog = "savvy"
    s.description = "The program will analyze positions in the game."
    s.add_version = true
    s.version = "0.2.0"    

    @add_arg_table s begin
        "--engine"
            help = "The engine file or path/file of the engine used to analyze the game."
            arg_type = String
            required = true
        "--inpgn"
            help = "Input your pgn filename."
            required = true
        "--outpgn"
            help = "Output pgn filename with analysis."
            default = "out.pgn"
        "--hashmb"
            help = "Hash in mb to be used by the engine."
            arg_type = Int
            default = 128
        "--numthreads"
            help = "Number of threads to be used by the engine."
            arg_type = Int
            default = 1
        "--movetime"
            help = "Time in mulliseconds to analyze each position in the game."
            arg_type = Int
            default = 500
    end

    return parse_args(s)
end


"Evaluate the board position with an engine and returns bestmove, bestscore and depth."
function evaluate(engine, board, movetime::Int64)
    bm = nothing
    score = nothing
    depth = 0

    if ischeckmate(board) || isstalemate(board)
        return bm, score, depth
    end

    setboard(engine, board)
    sendcommand(engine, "go movetime $movetime")

    while true
        line = readline(engine.io)

        # Get out of the loop once we have the bestmove.
        if startswith(line, "bestmove")
            bi = parsebestmove(line)
            bm = bi.bestmove
            break

        # Save the score and depth.
        elseif startswith(line, "info")
            info = parsesearchinfo(line)
            score = info.score
            depth = info.depth
        end
    end

    return bm, score, depth

end


"Read pgn file and analyze the positions in the game."
function analyze(in_pgnfn::String, out_pgnfn::String, engine_filename::String;
                movetime::Int64=500, hashmb::Int64=128, numthreads::Int64=1)
    tstart = time_ns()
    analysisminply = 16

    # Init engine.
    engine = runengine(engine_filename)

    # Set engine options.
    setoption(engine, "Hash", hashmb)
    setoption(engine, "Threads", numthreads)

    game_num = 0

    for g in gamesinfile(in_pgnfn; annotations=true)
        game_num += 1
        println("analyzing game $game_num ...")

        # Save annotated game to a new game and copy its header.
        mygame = Game()
        mygame.headers = g.headers

        # Parse the game, visit each position.
        while !isatend(g)
            move = nextmove(g)
            bd = g.node.board
            gm_movesan = movetosan(bd, move)

            domove!(mygame, move)  # Save the move to mygame.

            if ply(mygame) < analysisminply
                forward!(g)  # Push the move on the main board.
                continue
            end

            # Evaluate this position with the engine.
            bm, score, depth = evaluate(engine, bd, movetime)
            em_movesan = movetosan(bd, bm)
            em_score = round(score.value/100)  # convert cp to p
            em_comment = string(em_score) * "/" * string(depth)

            # If engine best move and game move are not the same, evaluate the game move too.
            if gm_movesan != em_movesan
                undo = domove!(bd, move)

                _, score, depth = evaluate(engine, bd, movetime)
                if isnothing(score)
                    gm_score = score
                else
                    # Negate the score since we pushed the move before analyzing it.
                    gm_score = round(-score.value/100)
                    gm_comment = string(gm_score) * "/" * string(depth)
                end

                undomove!(bd, undo)
            end

            # Insert engine move as variation to mygame if the game and engine move
            # are not the same otherwise just add comment to game move.
            if gm_movesan != em_movesan            
                if !isnothing(gm_score)
                    # Add comment for the evaluation of game move.
                    adddata!(mygame.node, "comment", gm_comment)

                    # Add NAG's
                    # Ref: https://en.wikipedia.org/wiki/Numeric_Annotation_Glyphs

                    # Add ?? NAG to game move, when score turns from playable to losing.
                    if gm_score <= -3.0 && em_score >= -1.0
                        adddata!(mygame, "nag", 4)
                    # Else add ?, from playable to bad score.
                    elseif gm_score < -1.0 && em_score >= -1.0
                        adddata!(mygame, "nag", 2)
                    end
                end

                # Back off 1 ply to insert engine move as variation.
                back!(mygame)
                addmove!(mygame, em_movesan)

                # Add comment for the evaluation of engine move.
                adddata!(mygame.node, "comment", em_comment)

                # Restore to a node after inserting the variation.
                back!(mygame)
                forward!(mygame)
            else
                # Add comment for the evaluation of game move, use the engine evaluation.
                adddata!(mygame.node, "comment", em_comment)
            end

            forward!(g)  # Push the move on the main board.
            
        end

        # Update header.
        setheadervalue!(mygame, "Annotator", "$(engine.name) @$movetime ms/pos")

        open(out_pgnfn, "a+") do filehandle
            println(filehandle, gametopgn(mygame))
        end

    end

    quit(engine)

elapsed = (time_ns() - tstart) / 1000000000
print("elapsed (sec): $elapsed")

end


"Initialize some variables before starting to analyze the games in the input pgn file."
function main()
    parsed_args = parse_commandline()
    println("Parsed args:")
    for (arg, val) in parsed_args
        println("    $arg : $val")
    end

    analyze(
        parsed_args["inpgn"],
        parsed_args["outpgn"],
        parsed_args["engine"],
        movetime=parsed_args["movetime"],
        hashmb=parsed_args["hashmb"],
        numthreads=parsed_args["numthreads"]
    )
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
