using Chess, Chess.PGN, Chess.UCI
using Pkg
using ArgParse
using Chain


const VALUE_MATE = 32000


"Command line options"
function parse_commandline()
    s = ArgParseSettings()
    s.prog = "savvy"
    s.description = "Analyze positions in the game and output annotated game."
    s.add_version = true
    s.version = "0.29.3"

    @add_arg_table s begin
        "--engine"
            help = "The filename or path/filename of the engine that will be used to analyze the game."
            arg_type = String
            required = true
        "--inpgn"
            help = "This is the input pgn filename where games will be analyzed."
            arg_type = String
            required = true
        "--outpgn"
            help = "The output pgn filename where position analysis will be saved."
            arg_type = String
            default = "out.pgn"
        "--movetime"
            help = "Time in milliseconds to analyze each position in the game, note 1s=1000ms."
            arg_type = Int
            default = 500
        "--evalstartmove"
            help = "The game move number where the engine starts its analysis."
            arg_type = Int
            default = 1
        "--evalendmove"
            help = "The game move number where the engine ends its analysis."
            arg_type = Int
            default = 1000
        "--engineoptions"
            help = "This is the engine options, example: --engineoptions \"Hash=128, Threads=1, Analysis Contempt=Off\""
            arg_type = String
            default = ""
        "--variationlength"
            help = "The length of engine PV (principal variation) or number of moves in the PV to be saved in the annotated game."
            arg_type = Int
            default = 5
        "--includeexistingcomment"
            help = "A flag to include existing comment in the pgn output."
            action = :store_true
        "--playername"
            help = "An option to analyze the game of a specified player name. Example: --playername \"Carlsen, Magnus\""
            arg_type = String
        "--analyzewinloss"
            help = "A flag to enable analyzing games which have 1-0 or 0-1 results."
            action = :store_true
    end

    return parse_args(s), s.version
end


"Get package version"
function get_pkg_version(name::AbstractString)
    @chain Pkg.dependencies() begin
        values
        [x for x in _ if x.name == name]
        only
        _.version
    end
end


"Create mate comment and is applied when game and engine moves are the same."
function matescorecomment(escore::Score, includeexistingcomment::Bool, existingcomment::Union{Nothing, String})::String
    matecomment = ""    
    movetomate = abs(escore.value)

    # If side to move wins, subtract movetomate by 1. This comment is read after the game move is pushed.
    if escore.value > 0            
        movetomate -= 1
        if movetomate == 0
            if includeexistingcomment && !isnothing(existingcomment)
                matecomment = "$existingcomment checkmate"
            else
                matecomment = "checkmate"
            end
        else
            if includeexistingcomment && !isnothing(existingcomment)
                matecomment = "$existingcomment mate in $(movetomate)"
            else
                matecomment = "mate in $(movetomate)"
            end
        end
    else
        if includeexistingcomment && !isnothing(existingcomment)
            matecomment = "$existingcomment mated in $movetomate"
        else
            matecomment = "mated in $movetomate"
        end
    end

    return matecomment
end


"Build comment from score and depth info"
function scoreanddepthcomment(
    score::Float64,
    depth::Int64,
    existingcomment::Union{Nothing, String}=nothing,
    includeexistingcomment::Bool=false
)::String
    if includeexistingcomment && !isnothing(existingcomment)
        return "$existingcomment $score/$depth"
    end

    return "$score/$depth"
end


"Convert value from centipawn to pawn unit"
function centipawntopawn(value::Int64, ismate::Bool)::Float64
    if ismate
        return round(matenumtocp(value)/100, digits=2)
    end

    return round(value/100, digits=2)
end


"Convert user options in string to dictionary"
function optionstringtodict(engineoptions::String)::Dict{String, String}
    optdict = Dict{String, String}()

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
            optdict[n] = ""
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

            # Not all pv line has a score, check it also.
            if !isnothing(currentpv) && !isnothing(info.score)
                if length(currentpv) == 1
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

                if update_scoreanddepth
                    score = info.score
                    depth = info.depth
                end
            end
        end
    end

    return bm, score, pv, depth
end


"Set engine option"
function dosetoption(engine::Engine, k1::String, v, v1)
    datatype = v1.type
    if datatype == Chess.UCI.check
        value = parse(Bool, v)
        setoption(engine, k1, value)
        println("check: setoption name $k1 value $value")
    elseif datatype == Chess.UCI.spin
        value = parse(Int, v)
        setoption(engine, k1, value)
        println("spin: setoption name $k1 value $value")
    elseif datatype == Chess.UCI.combo
        setoption(engine, k1, "$v")
        println("combo: setoption name $k1 value $v")
    elseif datatype == Chess.UCI.button
        setoption(engine, k1, nothing)
        println("button: setoption name $k1")
    elseif datatype == Chess.UCI.string
        setoption(engine, k1, "$v")
        println("string: setoption name $k1 value $v")
    else
        throw("Option type is not defined.")
    end

    return nothing
end


"Set user options to the engine"
function setengineoption(engine::Engine, engineoptions::Dict)
    if isempty(engineoptions)
        return nothing
    end

    for (k, v) in engineoptions          
        for (k1, v1) in engine.options
            if k != k1
                continue
            end

            dosetoption(engine, k1, v, v1)
            break
        end
    end

    return nothing
end


"""
Add move NAG depending on the game move score and engine best move score.

Ref.: NAG - https://en.wikipedia.org/wiki/Numeric_Annotation_Glyphs
"""
function addmovenag(mygame, em_score, gm_score)
    # Add ?? if game move score turns from playable to losing.
    # If game move score is 3 or more pawns behind but engine score is only 1 pawn behind.
    if gm_score <= -3.0 && em_score >= -1.0
        addnag!(mygame, 4)

    # Add ?? if game move is just equal or less from a winning score.
    elseif em_score >= 3.0 && gm_score <= 0.5
        addnag!(mygame, 4)

    # Add ?, ... from playable to bad score.
    elseif gm_score < -1.0 && em_score >= -1.0
        addnag!(mygame, 2)

    # Add !, if game move is better by at least 5 cp than engine move.
    elseif gm_score - 0.05 >= em_score && abs(em_score) <= 3.0
        addnag!(mygame, 1)
    end

    return nothing
end


"""
Get the threat of the game move.

Push the game move, do null move and evaluate the resulting position. The returned engine
bestmove will be the threat of the game move.
"""
function get_threatmove(e::Engine, g::Game, escore::Int, mt::Int)::Union{Nothing, String}
    bmsan = nothing

    # Calculate the threat move if current engine score is not winning yet.
    if escore >= 3.0
        return bmsan
    end

    # If game move is a capture do not calculate the threat move.
    # Usually it is obvious that the same piece will move to escape the recapture.
    # Also if game move is a check move, we will not calculate the threat move as
    # the king will be captured if we do a null move.
    nextmovesan = movetosan(board(g), nextmove(g))
    if occursin("x", nextmovesan) || occursin("+", nextmovesan)
        return bmsan
    end

    forward!(g)
    bd = board(g)

    # Check game termination.
    if isterminal(board(g))
        back!(g)
        return bmsan
    end

    nbd = donullmove(bd)
    ug = Game(nbd)

    # Evaluate the position after the null move.
    bm, score, _, _ = evaluate(e, ug, mt)
    if score.ismate
        mscore = matenumtocp(score.value)
    else
        mscore = score.value
    end

    # If the best move found is worth at least a pawn ahead consider it as a threat.    
    if mscore > escore && mscore >= 1.0
        # At this moment we do not consider a capture threat move as a threat as it is obvious.
        bmsan = movetosan(nbd, bm)
        if occursin("x", bmsan)
            bmsan = nothing
        end
    end
   
    back!(g)

    return bmsan
end


"Read pgn file and analyze the positions in the game. Save the analysis in output file."
function analyze(in_pgnfn::String, out_pgnfn::String, engine_filename::String;
                movetime::Int64=500, evalstartmove::Int64=1, evalendmove::Int64=1000,
                engineoptions::Dict=Dict(), variationlength::Int64=5,
                includeexistingcomment::Bool=false,
                playername::Union{Nothing, String}=nothing,
                analyzewinloss::Bool=false, progversion::String="")
    tstart = time_ns()

    # Init engine.
    engine = runengine(engine_filename)

    # Set engine options.
    setengineoption(engine, engineoptions)

    game_num = 0

    for g in gamesinfile(in_pgnfn; annotations=true)
        game_num += 1
        println("analyzing game $game_num between $(headervalue(g, "White")) and $(headervalue(g, "Black")) ...")

        # Analyze the game only if one of the players is the one specified in playername option.
        if !isnothing(playername)
            if playername != whiteplayer(g) && playername != blackplayer(g)
                println("Don't analyze game $game_num, $playername is not playing in this game.")
                continue
            end
        end

        # Analyze only those games with 1-0 or 0-1 results.
        if analyzewinloss
            gameresult = headervalue(g, "Result")
            if gameresult != "1-0" && gameresult != "0-1"
                println("Don't analyze game $game_num, result $gameresult is not decisive.")
                continue
            end
        end

        # Save annotated game to a new game and copy its header.
        mygame = Game()
        mygame.headers = g.headers

        # Parse the game, visit each position.
        while !isatend(g)
            move = nextmove(g)
            bd = board(g)
            gm_movesan = movetosan(bd, move)  # gm=game move
            myply = ply(mygame)
            mymovenum = Int(ceil(myply/2))

            existingcomment = nothing
            if includeexistingcomment
                forward!(g)
                existingcomment = comment(g.node)
                back!(g)
            end

            # If current move number is below evalstartmove don't analyze this position.
            if mymovenum < evalstartmove
                domove!(mygame, move)  # save move to mygame
                if includeexistingcomment && !isnothing(existingcomment)
                    addcomment!(mygame, existingcomment)
                end                
                forward!(g)  # Push the move on the main board.            
                continue
            end

            # If current move number is above evalendmove don't analyze this position.
            if mymovenum > evalendmove
                domove!(mygame, move)  # save move to mygame
                if includeexistingcomment && !isnothing(existingcomment)
                    addcomment!(mygame, existingcomment)
                end                
                forward!(g)
                continue
            end

            domove!(mygame, move)  # save move to mygame

            # Evaluate this position with the engine.
            bm, escore, pv, edepth = evaluate(engine, g, movetime)
            em_movesan = movetosan(bd, bm)  # em=engine move

            # Prepare engine variation.
            pvlength = length(pv)

            # If score is mate show all the moves.
            if escore.ismate
                variationlength = pvlength
            end
            em_pv = pv[1 : min(variationlength, length(pv))]

            em_score = centipawntopawn(escore.value, escore.ismate)

            em_comment = scoreanddepthcomment(em_score, edepth, existingcomment, includeexistingcomment)

            # If engine best move and game move are not the same, evaluate the game move too.
            if gm_movesan != em_movesan
                # Push the move and evaluate.
                forward!(g)
                _, gscore, _, depth = evaluate(engine, g, movetime)
                # Restore the position.
                back!(g)

                # Negate the score since we pushed the move before analyzing it.
                gm_score = centipawntopawn(-gscore.value, gscore.ismate)

                gm_comment = scoreanddepthcomment(gm_score, depth, existingcomment, includeexistingcomment)

                # Add comment for the evaluation of game move.
                if gscore.ismate
                    # Read the mate comment after pushing the move.
                    movetomate = abs(gscore.value)
                    if -gscore.value > 0
                        if includeexistingcomment && !isnothing(existingcomment)
                            matecomment = "$existingcomment mate in $movetomate"
                        else
                            matecomment = "mate in $movetomate"
                        end
                    else
                        if includeexistingcomment && !isnothing(existingcomment)
                            matecomment = "$existingcomment mated in $movetomate"
                        else
                            matecomment = "mated in $movetomate"
                        end
                    end
                    addcomment!(mygame, matecomment)
                else
                    addcomment!(mygame, gm_comment)
                end

                # Add NAG - Numeric_Annotation_Glyphs
                addmovenag(mygame, em_score, gm_score)

                # Insert engine move as variation to mygame.

                # Back off 1 ply and add engine pv as variation.
                back!(mygame)

                for (i, m) in enumerate(em_pv)
                    addmove!(mygame, m)
                    
                    # Add a precomment "mate in" or "mated in" in the variation.
                    if i == 1 && escore.ismate
                        matecomment = escore.value > 0 ? "mate in" : "mated in"
                        addprecomment!(mygame, "$matecomment $(abs(escore.value))")
                    end
                end

                # Add comment at the end of the variation.
                adddata!(mygame.node, "comment", scoreanddepthcomment(em_score, edepth, nothing, false))

                # Restore to a node after inserting the variation.
                for _ in em_pv
                    back!(mygame)
                end
                
                forward!(mygame)
            
            # Engine and game move are the same.
            else
                # Add comment for the evaluation of game move. Use the engine analysis.
                if escore.ismate
                    matecomment = matescorecomment(escore, includeexistingcomment, existingcomment)
                    addcomment!(mygame, matecomment)
                else
                    # Add threat move in the comment.
                    threatmove = get_threatmove(engine, g, escore.value, movetime)
                    if !isnothing(threatmove)
                        addcomment!(mygame, "$em_comment ... threatening $threatmove")
                    else
                        addcomment!(mygame, em_comment)
                    end
                end
            end

            forward!(g)  # Push the move on the main board.
            
        end

        # Update header.
        setheadervalue!(mygame, "Annotator", "savvy $progversion, $(engine.name) @$movetime ms/pos")

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
    println("Julia $VERSION")
    println("Chess $(get_pkg_version("Chess"))")

    parsed_args, progversion = parse_commandline()
    println("savvy $progversion")
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
        evalendmove=parsed_args["evalendmove"],
        engineoptions=optdict,
        variationlength=parsed_args["variationlength"],
        includeexistingcomment=parsed_args["includeexistingcomment"],
        playername=parsed_args["playername"],
        analyzewinloss=parsed_args["analyzewinloss"],
        progversion=progversion
    )

    return nothing
end


if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
