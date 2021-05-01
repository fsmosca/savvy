using Chess, Chess.PGN, Chess.UCI


"Evaluate the board position with an engine and returns bestmove, bestscore and depth."
function evaluate(engine, board, movetime::Int)
    bm = nothing
    score = nothing
    depth = 0

    if ischeckmate(board)
        return "checkmate", score, depth
    end

    if isstalemate(board)
        return "stalemate", score, depth
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

        # Save score and depth.
        elseif startswith(line, "info")
            info = parsesearchinfo(line)
            score = info.score
            depth = info.depth
        end
    end

    if isnothing(bm)
        println("Warning, engine fails to generate a best move!")
        println(fen(board))
        throw(DomainError(bm))
    end

    return bm, score, depth

end


"Read pgn file and analyze the positions in the game."
function analyze(in_pgnfn::String, out_pgnfn::String, engine_filename::String, movetime::Int)
    tstart = time_ns()
    analysisminply = 16

    # Init engine.
    engine = runengine(engine_filename)
    
    for g in gamesinfile(in_pgnfn; annotations=true)
        # Save annotated game to a new game and copy its header.
        mygame = Game()
        mygame.headers = g.headers

        # Parse the game, visit each position.
        while !isatend(g)
            move = nextmove(g)
            bd = g.node.board
            gm_movesan = movetosan(bd, move)

            domove!(mygame, move)  # Save the move on our game.

            if ply(mygame) < analysisminply
                forward!(g)  # Push the move on the main board.
                continue
            end

            # Evaluate this position with the engine.
            bm, score, depth = evaluate(engine, bd, movetime)
            em_movesan = movetosan(bd, bm)
            em_score = round(score.value/100)
            em_comment = em_movesan * " " * string(em_score) * "/" * string(depth)

            # If engine best move and game move are not the same, evaluate the game move too.
            if gm_movesan != em_movesan
                undo = domove!(bd, move)

                bm, score, depth = evaluate(engine, bd, movetime)
                if isnothing(score)
                    gm_comment = bm
                    gm_score = score
                else
                    gm_score = round(-score.value/100)  # cp to p
                    gm_comment = gm_movesan * " " * string(gm_score) * "/" * string(depth)
                end

                undomove!(bd, undo)
            end

            # Add comment.
            if gm_movesan == em_movesan
                comment = "game: " * em_comment
            else
                comment = "game: " * gm_comment * ", engine: " * em_comment
            end

            adddata!(mygame.node, "comment", comment)

            # Add NAGs.
            # https://en.wikipedia.org/wiki/Numeric_Annotation_Glyphs
            if gm_movesan != em_movesan && !isnothing(gm_score)
                # Add ??, from playable to losing score.
                if gm_score <= -3.0 && em_score >= -1.0
                    adddata!(mygame, "nag", 4)
                # Add ?, from playable to bad score.
                elseif gm_score < -1.0 && em_score >= -1.0
                    adddata!(mygame, "nag", 2)
                end
            end

            forward!(g)  # Push the move on the main board.
            
        end

        # Update header.
        setheadervalue!(mygame, "Annotator", "Stockfish @$movetime ms/pos")

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
    engine_filename = "./engine/stockfish_13.exe"
    in_pgnfn = "./pgn/2021-new-in-chess-classic.pgn"
    out_pgnfn = "output_2021-new-in-chess-classic.pgn"
    movetime = 500
    analyze(in_pgnfn, out_pgnfn, engine_filename, movetime)
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
