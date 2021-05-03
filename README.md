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
[Annotator "Lc0 v0.27.0 @2000 ms/pos"]

1. Nf3 Nf6 2. g3 g6 3. Bg2 Bg7 4. c4 c5 5. Nc3 O-O 6. O-O Nc6 7. d3 d5 8. cxd5 {-0.01/1} Nxd5 {-0.01/15} 9. Nxd5 {0.02/14} Qxd5 {-0.02/15} 10. Be3 {0.03/14} Qd6 {-0.28/11} (10... Bd7 11. Nd4 Qd6 12. Nxc6 Bxc6 {-0.02/14}) 11. Rc1 {0.29/13} Nd4 {-0.27/11} 12. Nxd4 {0.28/10} cxd4 {-0.29/11} 13. Bd2 {0.3/10} Be6 {-0.37/9} (13... Bg4 14. h3 Bf5 15. Qb3 Qd7 {-0.26/10}) 14. Qa4 {0.36/12} a5 {-0.45/9} (14... Rfd8 15. Bxb7 Rab8 16. Bf4 Be5 {-0.35/11}) 15. Qb5 {0.49/13} Bxa2 {-0.76/11} (15... Bd7 16. Qd5 Qxd5 17. Bxd5 Be5 {-0.51/14}) 16. Bxa5 {0.78/11} Qe6 {-0.95/11} (16... Be6 17. Bc7 Qa6 18. Qb4 Qa4 {-0.77/10}) 17. Bf3 {0.82/11} (17. Bxb7 Rab8 18. Bc7 Rxb7 19. Qxb7 {1.0/15}) Be5 $2 {-1.08/13} (17... Qb3 18. Qxb3 Bxb3 19. Bb4 Rfe8 {-0.84/13}) 18. Bc7 {1.12/16} Bxc7 {-1.35/11} (18... Bd6 19. Qxb7 Bxc7 20. Rxc7 Rfb8 {-1.08/15}) 19. Rxc7 {1.37/12} Qd6 {-1.6/10} (19... Rad8 20. Qxb7 Rb8 21. Qa7 Rxb2 {-1.37/11}) 20. Rd7 {1.64/10} Qf6 {-1.51/9} 21. Rxb7 {1.74/9} Be6 {-1.72/9} 22. h4 {1.81/9} Rac8 {-2.14/8} (22... Kg7 23. Rc1 Rfc8 24. Rxc8 Rxc8 {-1.78/9}) 23. Qb4 {1.46/8} (23. Ra1 h6 24. Raa7 Rfe8 25. Rc7 {2.24/10}) Rfe8 {-1.42/10} 24. Ra1 {1.45/9} h5 {-1.42/9} 25. Qd2 {1.18/10} (25. Kg2 Rc2 26. Ra5 Rc1 27. Rc5 {1.52/10}) Bg4 {-1.25/11} 26. Bxg4 {1.26/11} hxg4 {-1.21/11} 27. Rb5 {0.73/10} (27. b4 Rc3 28. b5 Rc5 29. Rc1 {1.33/10}) Rc7 $2 {-1.35/12} (27... Rc6 28. b4 Rec8 29. Qg5 Qxg5 {-0.79/15}) 28. Rba5 {0.86/10} (28. Qg5 Rec8 29. h5 Rc2 30. hxg6 {1.31/18}) Kg7 {-0.88/12} 29. Ra6 {0.84/11} (29. b4 Rec8 30. Qg5 Qxg5 31. Rxg5 {0.95/11}) e6 $2 {-1.02/11} (29... Qf5 30. R6a5 e5 31. Rc1 Qc8 {-0.83/12}) 30. Ra8 {0.93/12} (30. Rc1 Rxc1+ 31. Qxc1 Qe5 32. Qd2 {1.05/14}) Rec8 $2 {-1.47/11} (30... Rxa8 31. Rxa8 e5 32. Re8 Rc5 {-0.93/15}) 31. Rxc8 {1.47/12} Rxc8 {-1.45/11} 32. b4 {1.61/11} Qe5 {-1.67/11} (32... Rb8 33. Qb2 e5 34. b5 Qb6 {-1.56/11}) 33. Qb2 {1.6/12} Rb8 {-1.67/11} 34. Qd2 {0.96/11} (34. e3 Qd5 35. Rc1 Kh7 36. e4 {1.8/11}) Qd6 {-0.99/14} 35. Qg5 {1.04/11} Rxb4 $2 {-1.95/14} (35... Qxb4 36. Qxg4 Qc3 37. Rf1 Qc5 {-0.96/11}) 36. h5 {2.08/15} Qb8 {-3.54/12} (36... Qd5 37. h6+ Kh7 38. Qf6 Kxh6 {-1.93/14}) 37. Qxg4 {3.49/14} e5 {-6.43/13} (37... Rb1+ 38. Rxb1 Qxb1+ 39. Kg2 Qb7+ {-3.3/13}) 38. hxg6 {6.75/15} fxg6 {-11.28/9} (38... Rb1+ 39. Rxb1 Qxb1+ 40. Kg2 fxg6 {-6.8/13}) 39. Qd7+ {11.43/10} Kh6 {-13.49/9} (39... Kf6 40. Ra7 Rb1+ 41. Kg2 Kg5 {-10.16/9}) 40. Ra7 {13.33/10} Rb1+ {-17.22/8} (40... Kg5 41. Qh7 Kf5 42. Rf7+ Ke6 {-11.63/8}) 41. Kg2 {17.3/10} Rb6 {-18.21/9} 42. Qh3+ {16.01/1} (42. Qh7+ Kg5 43. Rf7 Qb7+ 44. Rxb7 {24.39/10}) Kg5 {-16.01/1} 43. Rf7 {38.27/9} Qa8+ {-319.94/4} (43... Qb7+ 44. Rxb7 Rxb7 45. Qe6 Kh6 {-37.25/9}) 44. f3 {319.95/1} 1-0
```

## Credits
* [Julia Chess](https://github.com/romstad/Chess.jl)
