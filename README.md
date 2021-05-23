# Savvy
A julia script that reads a chess pgn file, analyze the positions in the game and save the annotated game to a file.

## 1. &nbsp; Setup
* Install [Julia](https://julialang.org/downloads/)
* Use the [Julia Chess](https://github.com/romstad/Chess.jl) package

## 2. &nbsp; Command line
#### 2.1. &nbsp; Help
`julia savvy.jl --help`
```julia
Julia 1.6.1
Chess 0.7.0
usage: savvy --engine ENGINE --inpgn INPGN [--outpgn OUTPGN]     
             [--movetime MOVETIME] [--depth DEPTH]
             [--evalstartmove EVALSTARTMOVE]
             [--evalendmove EVALENDMOVE]
             [--engineoptions ENGINEOPTIONS]
             [--variationlength VARIATIONLENGTH]
             [--includeexistingcomment] [--playername PLAYERNAME]
             [--analyzewin] [--analyzedraw] [--analyzewhite]     
             [--analyzeblack] [--analyzeloss] [--version] [-h]   

Analyze positions in the game and output annotated game.

optional arguments:
  --engine ENGINE       The filename or path/filename of the engine
                        that will be used to analyze the game.     
  --inpgn INPGN         This is the input pgn filename where games  
                        will be analyzed.
  --outpgn OUTPGN       The output pgn filename where position      
                        analysis will be saved. (default: "out.pgn")
  --movetime MOVETIME   Time in milliseconds to analyze each position
                        in the game, note 1s=1000ms. (type: Int64)
  --depth DEPTH         The maximum depth that the engine is allowed
                        to analyze. (type: Int64)
  --evalstartmove EVALSTARTMOVE
                        The game move number where the engine starts
                        its analysis. (type: Int64, default: 1)
  --evalendmove EVALENDMOVE
                        The game move number where the engine ends its
                        analysis. (type: Int64, default: 1000)
  --engineoptions ENGINEOPTIONS
                        This is the engine options, example:
                        --engineoptions "Hash=128, Threads=1, Analysis
                        Contempt=Off" (default: "")
  --variationlength VARIATIONLENGTH
                        The length of engine PV (principal variation)
                        or number of moves in the PV to be saved in
                        the annotated game. (type: Int64, default: 5)
  --includeexistingcomment
                        A flag to include existing comment in the pgn
                        output.
  --playername PLAYERNAME
                        An option to analyze the game of a specified
                        player name. Example: --playername "Carlsen,
                        Magnus"
  --analyzewin          A flag to enable analyzing games which have
                        1-0 or 0-1 results or when a specified player
                        name won the game.
  --analyzedraw         A flag to enable analyzing games which have
                        1/2-1/2 results only.
  --analyzewhite        A flag to only analyze the game of a player
                        name when this player is playing white. This
                        is useful when --playername option is used.
  --analyzeblack        A flag to only analyze the game of a player
                        name when this player is playing black. This
                        is useful when --playername option is used.
  --analyzeloss         A flag to enable analyzing games where player
                        name loses the game. This is useful when
                        --playername option is used.
  --version             show version information and exit
  -h, --help            show this help message and exit
```

#### 2.2. &nbsp; Analyze games
Note the duration of analysis controlled by --movetime option is in milliseconds where 1 second = 1000 milliseconds.
```
julia savvy.jl --engine ./engine/stockfish_13.exe --engineoptions "Hash=128, Threads=2" --inpgn ./pgn/2021-new-in-chess-classic.pgn --outpgn analyzed.pgn --movetime 500
```

#### 2.3. &nbsp; Analyze the games of a specific player
`--playername "Carlsen, Magnus"`

#### 2.4. &nbsp; Start the analysis at a given move number
`--evalstartmove 12`

#### 2.5. &nbsp; End the analysis at a given move number
`--evalendmove 30`

#### 2.6. &nbsp; Analyze only those games with 1-0 or 0-1 results
`--analyzewin` or  
`--analyzeloss`

#### 2.7. &nbsp; Analyze games with decisive results by a specific player
`--playername "Carlsen, Magnus" --analyzewin --analyzeloss`

#### 2.8. &nbsp; Analyze games with decisive results in the opening only
`--evalstartmove 4 --evalendmove 24 --analyzewin --analyzeloss`

#### 2.9. &nbsp; Analyze games up to depth 18
`--depth 18`

#### 2.10. &nbsp; Analyze games up to 5 seconds
1 second = 1000 milliseconds, movetime is in milliseconds.  
`--movetime 5000`

#### 2.11. &nbsp; Analyze games at depth 16 and 1s
The engine will stop its analysis when one of the conditions is reached first.  
`--movetime 1000 --depth 16`

#### 2.12. &nbsp; Analyze games of a player where the player lost
`--playername "player name" --analyzeloss`

#### 2.13. &nbsp; Analyze games of a player where the player won as black
`--playername "Carlsen, Magnus" --analyzewin --analyzeblack`

#### 2.14. &nbsp; Analyze games of a player where the player draws as black
`--playername "Carlsen, Magnus" --analyzedraw --analyzeblack`

## 3. &nbsp; Sample output
```
[Event "New in Chess Classic Prelims 2021"]
[Site "http://www.chessbomb.com"]
[Date "2021.04.24"]
[Round "02"]
[White "Le, Quang Liem"]
[Black "Carlsen, Magnus"]
[Result "0-1"]
[WhiteFideId "12401137"]
[BlackFideId "1503014"]
[WhiteElo "2709"]
[BlackElo "2847"]
[TimeControl "900+10"]
[WhiteClock "0:00:47"]
[BlackClock "0:03:47"]
[Annotator "savvy 0.29.3, Stockfish 13 @10000 ms/pos"]

1. d4 Nf6 2. Nf3 d5 3. c4 e6 4. Nc3 h6 5. g3 Bd6 6. Bg2 O-O 7. O-O Nc6 8. b3 dxc4 9. bxc4 e5 10. Nxe5 Nxe5 11. c5 Bxc5 
12. dxe5 {0.24/26} Qxd1 {-0.39/30} 13. Rxd1 {0.26/33} Ng4 {-0.23/33} 14. Ne4 {0.34/33} Bb6 {-0.21/35 ... threatening Bf5} 
15. a4 {0.23/34} Bf5 {-0.54/28} (15... a5 16. Ba3 {-0.23/31}) 16. e3 {0.0/30} (16. h3 Bxe4 {0.55/30}) a5 {-0.18/30} (16... Rad8 17. Bb2 Rxd1+ 18. Rxd1 Re8 {0.0/33}) 17. Bb2 {0.19/33} Rfe8 {-0.13/31} 
18. Nd2 {-0.11/31} (18. Bd4 Nxe5 19. Bxb6 Bxe4 20. Bxe4 {0.29/33}) Nxe5 {0.05/32} 19. Bxe5 {-0.04/29} Rxe5 {0.07/34} 
20. Nc4 {-0.09/34} (20. Bxb7 Rb8 21. Nc4 Rc5 22. Nxb6 {-0.01/35}) Rc5 {0.01/32} 21. Bxb7 {-0.01/32} Rb8 {0.03/32} 
22. Nxb6 {0.0/33} cxb6 {0.0/31} (22... Rxb7 23. Rd8+ Kh7 24. Nd7 Bxd7 {0.06/34}) 23. Ba6 {0.0/31} Kf8 {0.09/30} 
24. Rd4 {0.0/32} Ra8 {0.0/35} (24... Bc2 25. Bd3 Bxd3 26. Rxd3 Rc4 {0.0/33}) 25. Bb5 {0.0/33} (25. Bd3 Bxd3 26. Rxd3 Rc4 27. Rd7 {0.0/37}) Rac8 {0.0/36 ... threatening Bh3} 
26. Kg2 {0.0/35} (26. Bd7 Bxd7 27. Rxd7 Rc4 28. Kg2 {0.0/36}) Ke7 {0.0/36} (26... Rd5 27. Rad1 Be4+ 28. Kf1 Rxd4 {0.0/38}) 
27. Rad1 {0.0/37} Rc1 {0.0/37} (27... R8c7 28. e4 Bg4 29. R1d2 Rc2 {0.0/33}) 28. Rxc1 {0.0/38} Rxc1 {0.0/42} 
29. g4 {-0.12/28} (29. e4 Bg4 30. e5 h5 31. Rd6 {0.0/41}) Be6 {0.05/31} 30. h4 {-0.21/30} (30. h3 Rc5 31. f4 Rd5 32. Re4 {-0.05/30}) g5 {0.0/34} (30... Rb1 31. f3 Rb4 32. Rd1 Bb3 {0.32/32}) 
31. hxg5 {0.0/40} (31. h5 Rc5 32. Kg3 Rc3 33. Rd2 {0.0/38}) hxg5 {0.0/44} 32. f3 {0.0/46} Rc5 {0.0/46} (32... f6 33. Kf2 Rc2+ 34. Kg3 Rc3 {0.0/42}) 
33. Kg3 {0.0/46} Rc3 {0.0/48} (33... Rc1 34. Rd3 f6 35. e4 Rc5 {0.0/42}) 34. Re4 {-0.12/33} (34. e4 f6 35. Rd1 Rc8 36. Rd2 {0.0/49}) Kd6 {0.0/35} (34... Rb3 35. Re5 Kf6 36. f4 gxf4+ {0.0/35}) 
35. f4 {0.0/33} (35. Rd4+ Ke5 36. Kf2 Bd5 37. Rd1 {0.0/39}) f6 {0.17/38} 36. Rd4+ {-0.76/31} (36. f5 {-0.2/35}) Bd5 {0.9/33} 37. Kf2 {-0.97/33 ... threatening e4} Kc5 {0.58/34} (37... Rc2+ {0.96/31}) 
38. fxg5 $2 {-1.77/28} (38. Ke2 Rc2+ {-0.8/36}) Rc2+ {1.76/31} 39. Kg3 {-1.94/35} fxg5 {1.78/34} 40. Rd1 {-2.29/31} (40. Rd3 {-2.12/30}) Rg2+ {2.28/29} 
41. Kh3 {-1.84/35} Rf2 $1 {2.13/31} (41... Rc2 42. Re1 Kb4 43. Kg3 Bb3 {1.72/31}) 42. Rc1+ {-2.51/31} (42. Rd3 Rc2 43. Kg3 Rc1 44. Rd4 {-2.13/30}) Kd6 {2.47/31} 
43. Rc3 {-2.7/32} (43. Re1 Ke5 44. Kg3 Rf3+ 45. Kh2 {-2.59/30}) Ke5 {1.63/29} (43... Rb2 44. Rc8 Rb3 45. Re8 Bf7 {3.02/32}) 
44. Bc6 $1 {-1.12/29} (44. Kg3 Rf3+ 45. Kh2 Kd6 46. Kg1 {-1.63/29}) Be6 {0.6/33} (44... Rb2 45. Bxd5 Kxd5 46. Rd3+ Kc4 {1.81/31}) 
45. Kg3 {-0.75/31} Rb2 {0.44/32} (45... Rf8 46. Bb7 {0.73/32}) 46. Bf3 $4 {-4.0/28} (46. Bb5 Rb3 47. Rc6 Bd5 48. Rg6 {-0.33/33}) Rb3 {3.78/30} 
47. Rxb3 {-6.82/35} (47. Rc1 Rxe3 {-4.25/30}) Bxb3 {7.27/38} 48. Bc6 {-7.75/40} Bd1 {8.05/38} (48... Kd6 49. Be8 Bd1 50. Kg2 Kd5 {7.93/38}) 
49. Kh3 {-8.54/34} (49. e4 Kd4 {-8.23/39}) Kd6 {9.02/38} 50. Bb5 {-9.27/42} (50. Be8 Kc5 51. e4 Bc2 52. e5 {-9.11/38}) Kc5 {9.27/34} 
51. Kg3 {-9.9/29} (51. e4 Bc2 52. e5 Kd5 53. Kg3 {-9.38/38}) Kb4 {10.63/28} 52. e4 {-11.87/27} Bxa4 {14.54/31} 0-1
```

## 4. &nbsp; Credits
* [Julia Chess](https://github.com/romstad/Chess.jl)
