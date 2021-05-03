# Savvy
A julia script that analyzes positions in a chess game

## Setup
* Install [Julia](https://julialang.org/downloads/)
* Use the [Julia Chess](https://github.com/romstad/Chess.jl) package

## Command line
#### Help
`julia savvy.jl --help`

#### Analyze games
```
julia savvy.jl --engine ./engine/stockfish_13.exe --engineoptions "Hash=128, Threads=2" --inpgn ./pgn/2021-new-in-chess-classic.pgn --outpgn analyzed.pgn --movetime 500
```

## Sample output
```
[Event "New in Chess Classic Prelims 2021"]
[Site "http://www.chessbomb.com"]
[Date "2021.04.24"]
[Round "01"]
[White "Radjabov, Teimour"]
[Black "Jones, Gawain C B"]
[Result "1-0"]
[WhiteFideId "13400924"]
[BlackFideId "409561"]
[WhiteElo "2765"]
[BlackElo "2670"]
[TimeControl "900+10"]
[WhiteClock "0:02:28"]
[BlackClock "0:00:11"]
[Annotator "Stockfish 13 @1000 ms/pos"]

1. Nf3 Nf6 2. g3 g6 3. Bg2 Bg7 4. c4 c5 5. Nc3 O-O 6. O-O Nc6 7. d3 d5 8. cxd5 Nxd5 9. Nxd5 Qxd5 10. Be3 Qd6 11. Rc1 Nd4 12. Nxd4 cxd4 13. Bd2 Be6 14. Qa4 a5 15. Qb5 {0.62/19} Bxa2 $2 {-1.44/20} (15... Bd7 {-0.68/19}) 16. Bxa5 {1.61/21} Qe6 {-1.44/20} 17. Bf3 {1.59/19} Be5 {-1.8/20} (17... Qb3 {-1.5/20}) 18. Bc7 {2.16/21} Bxc7 {-2.26/21} (18... Bd6 {-1.98/22}) 19. Rxc7 {2.11/21} Qd6 {-2.6/21} (19... Rfd8 {-2.44/20}) 20. Rd7 {2.74/21} Qf6 {-2.57/20} 21. Rxb7 {2.77/20} (21. b3 {3.28/20}) Be6 {-2.34/21} 22. h4 {2.43/21} Rac8 {-3.38/19} (22... Rfc8 {-2.5/22}) 23. Qb4 {2.72/19} (23. Ra1 {3.47/19}) Rfe8 {-2.88/20} (23... Bh3 {-2.8/20}) 24. Ra1 {2.48/21} h5 {-2.75/21} 25. Qd2 {1.87/20} (25. Kg2 {2.47/21}) Bg4 {-2.04/19} 26. Bxg4 {1.71/19} (26. Kg2 {2.0/20}) hxg4 {-1.94/20} 27. Rb5 {1.73/20} (27. b4 {1.96/20}) Rc7 {-1.72/20} (27... Rc6 {-1.64/20}) 28. Rba5 {1.71/19} (28. h5 {1.86/20}) Kg7 {-1.46/21} 29. Ra6 {1.44/21} (29. Qg5 {1.28/20}) e6 {-1.35/19} (29... Qf5 {-1.31/22}) 30. Ra8 {1.46/21} (30. b4 {1.36/20}) Rec8 {-2.1/22} (30... Rxa8 {-1.55/22}) 31. Rxc8 {2.23/25} Rxc8 {-1.87/25} 32. b4 {2.13/24} Qe5 {-2.37/20} (32... Rb8 {-2.02/23}) 33. Qb2 {2.62/20} (33. Rb1 {2.35/21}) Rb8 {-2.27/21} 34. Qd2 {2.25/20} Qd6 {-2.48/23} (34... Qf6 {-2.24/21}) 35. Qg5 {2.61/23} Rxb4 {-3.09/21} (35... Qd5 {-2.29/22}) 36. h5 {3.07/21} Qb8 {-3.26/23} (36... Rb7 {-2.96/22}) 37. Qxg4 {4.27/23} e5 {-5.38/22} (37... Rb1+ {-4.35/22}) 38. hxg6 {5.61/24} fxg6 {-5.61/23} 39. Qd7+ {5.91/19} (39. Qe4 {6.01/22}) Kh6 {-6.14/24} (39... Kf6 {-6.02/21}) 40. Ra7 {6.22/23} Rb1+ {-6.4/25} (40... Qxa7 {-6.32/24}) 41. Kg2 {6.4/25} Rb6 {-319.8/30} (41... Qxa7 {-6.48/24}) 42. Qh3+ {319.83/39} (42. Qh7+ {319.81/36}) Kg5 {-319.82/43} 43. Rf7 {75.3/30} (43. Qh4+ {319.83/42}) Qa8+ {-319.94/245} (43... Qb7+ {-76.12/35}) 44. f3 {319.95/245} 1-0
```

## Credits
* [Julia Chess](https://github.com/romstad/Chess.jl)
