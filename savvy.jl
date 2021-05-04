using Chess, Chess.PGN, Chess.UCI, ArgParse


VALUE_MATE = 32000


"Command line options"
function parse_commandline()
    s = ArgParseSettings()
    s.prog = "savvy"
    s.description = "The program will analyze positions in the game."
    s.add_version = true
    s.version = "0.11.0"    

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
        "--movetime"
            help = "Time in mulliseconds to analyze each position in the game."
            arg_type = Int
            default = 500
        "--evalstartmove"
            help = "The game move number where the engine starts its analysis."
            arg_type = Int
            default = 1
        "--engineoptions"
            help = "--engineoptions \"Hash=128, Threads=1, Analysis Contempt=Off\""
            arg_type = String
            default = ""
    end

    return parse_args(s)
end


"Build comment from score and depth info"
function createcomment(score::Float64, depth::Int64)::String
    return "$score/$depth"
end


"Convert value from centipawn to pawn unit"
function centipawntopawn(value::Int64, ismate::Bool)::Float64
    if ismate
        return round(matenumtocp(value)/100, digits=2)
    end

    return round(value/100, digits=2)
end


function optionstringtodict(engineoptions::String)::Dict
    optdict = Dict{String, Any}()

    if engineoptions == ""
        return optdict
    end

    opt = split(engineoptions, ",")
    opt_clean = strip.(opt, [' '])
    for n in opt_clean
        if occursin("=", n)
            k = split(n, "=")[1]
            v = split(n, "=")[2]
            optdict[k] = v
        else
            # UCI option without value like button
            optdict[n] = nothing
        end
    end

    return optdict
end


"Converts mate value to score cp"
function matenumtocp(matenum::Int)::Int
    score = 0

    if matenum > 0
        score = VALUE_MATE - 2*matenum + 1
    elseif matenum < 0
        score = -VALUE_MATE - 2*matenum
    end

    return score
end


"Evaluate the board position with an engine and returns bestmove, bestscore pv and depth."
function evaluate(engine, game, movetime::Int64)
    bm = nothing
    score = nothing
    pv = nothing
    depth = 0

    if ischeckmate(board(game))
        return bm, Score(-32000, false, Chess.UCI.exact), pv, depth
    end
    
    if isstalemate(board(game))
        return bm, Score(0, false, Chess.UCI.exact), pv, depth
    end

    setboard(engine, game)
    sendcommand(engine, "go movetime $movetime")

    movecount = 0

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

            # Engine like Stockfish outputs a pv with single move even if the previous
            # pv has the same first move and have more than 1 move in the pv, if this is
            # the case, we will not save such pv.
            # Todo: Refactor the following code.
            currentpv = info.pv
            update_scoreanddepth = true
            if !isnothing(currentpv)
                if size(currentpv)[1] == 1
                    movecount += 1
                    # If this is the first time with a single move pv, we save it in our pv.
                    if movecount == 1
                        pv = currentpv
                    else
                        # Replace our pv if current pv move 1 is different from our pv move 1.
                        if !isnothing(pv)
                            if currentpv[1] != pv[1]
                                pv = currentpv
                            else
                                update_scoreanddepth = false
                                # println("Do not replace old pv")
                            end
                        else
                            pv = currentpv
                        end
                    end
                else
                    pv = currentpv
                end
            end

            if update_scoreanddepth
                score = info.score
                depth = info.depth
            end
        end
    end

    return bm, score, pv, depth
end


"Set user options to the engine"
function setengineoption(engine::Engine, engineoptions::Dict)
    if !isempty(engineoptions)
        for (k, v) in engineoptions            
            for (k1, v1) in engine.options
                if k == k1
                    typenum = Int(v1.type)
                    if typenum == 0  # check = 0
                        value = parse(Bool, v)
                        setoption(engine, k1, value)
                        # println("check: setoption name $k1 value $value")
                    elseif typenum == 1  # spin = 1
                        value = parse(Int, v)
                        setoption(engine, k1, value)
                        # println("spin: setoption name $k1 value $value")
                    elseif typenum == 4  || typenum == 2  # string=4 or combo=2
                        setoption(engine, k1, "$v")
                        # println("string/combo: setoption name $k1 value $v")
                    elseif typenum == 3  # button=3
                        setoption(engine, k1, nothing)
                        # println("button: setoption name $k1")
                    else
                        println("no type")
                        setoption(engine, k1, "$v")
                        # println("no type: setoption name $k1 value $v")
                    end

                    break
                end
            end
        end
    end

    return nothing
end


"Read pgn file and analyze the positions in the game."
function analyze(in_pgnfn::String, out_pgnfn::String, engine_filename::String;
                movetime::Int64=500, evalstartmove::Int64=8, engineoptions::Dict=Dict())
    tstart = time_ns()

    # Init engine.
    engine = runengine(engine_filename)

    # Set engine options.
    setengineoption(engine, engineoptions)

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
            bd = board(g)
            gm_movesan = movetosan(bd, move)
            myply = ply(mygame)
            mymovenum = Int(ceil(myply/2))

            # If current move number is below evalstartmove don't analyze this position.
            if mymovenum < evalstartmove
                domove!(mygame, move)  # save move to mygame
                forward!(g)  # Push the move on the main board.
                continue
            end

            domove!(mygame, move)  # save move to mygame

            # Evaluate this position with the engine.
            bm, score, pv, depth = evaluate(engine, g, movetime)
            em_movesan = movetosan(bd, bm)

            # Prepare engine variation.
            varlength = 5  # Todo: create option
            pvlength = size(pv)[1]

            # If score is mate show all the moves.
            if score.ismate
                varlength = pvlength
            end
            em_pv = pv[1 : min(varlength, size(pv)[1])]

            em_score = centipawntopawn(score.value, score.ismate)

            em_comment = createcomment(em_score, depth)

            # If engine best move and game move are not the same, evaluate the game move too.
            if gm_movesan != em_movesan
                # Push the move and evaluate.
                forward!(g)
                _, score, pv, depth = evaluate(engine, g, movetime)
                # Restore the position.
                back!(g)

                # Negate the score since we pushed the move before analyzing it.
                gm_score = centipawntopawn(-score.value, score.ismate)

                gm_comment = createcomment(gm_score, depth)

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

                # Insert engine move as variation to mygame.

                # Back off 1 ply and add moves from engine as variation.
                back!(mygame)
                for m in em_pv
                    addmove!(mygame, m)
                end

                # Add comment at the end of the variation.
                adddata!(mygame.node, "comment", em_comment)

                # Restore to a node after inserting the variation.
                for m in em_pv
                    back!(mygame)
                end
                
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

    return nothing
end


"Initialize some variables before starting to analyze the games in the input pgn file."
function main()
    parsed_args = parse_commandline()
    println("Parsed args:")
    for (arg, val) in parsed_args
        println("    $arg : $val")
    end

    # Convert engine options string to dictionary.
    optdict = optionstringtodict(parsed_args["engineoptions"])

    analyze(
        parsed_args["inpgn"],
        parsed_args["outpgn"],
        parsed_args["engine"],
        movetime=parsed_args["movetime"],
        evalstartmove=parsed_args["evalstartmove"],
        engineoptions=optdict
    )

    return nothing
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
