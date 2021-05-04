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
[Annotator "Stockfish 13 @10000 ms/pos"]

1. Nf3 Nf6 2. g3 g6 3. Bg2 Bg7 4. c4 c5 5. Nc3 O-O 6. O-O Nc6 7. d3 d5 8. cxd5 Nxd5 9. Nxd5 Qxd5 10. Be3 Qd6 11. Rc1 Nd4 12. Nxd4 {0.47/24} cxd4 {-0.5/27} 13. Bd2 {0.49/25} Be6 {-0.96/26} (13... Bg4 14. Qa4 a5 15. Qb5 Bxe2 {-0.56/27}) 14. Qa4 {0.9/27} a5 {-0.84/26} 15. Qb5 {0.62/28} (15. Rc2 Rac8 {0.75/28}) Bxa2 $2 {-1.7/29} (15... Bd7 16. Qd5 Qxd5 17. Bxd5 Be5 {-0.77/28}) 16. Bxa5 {1.5/29} Qe6 {-1.7/28} 17. Bf3 {1.85/30} Be5 {-2.26/27} (17... Qb3 18. Qxb3 Bxb3 19. Bb4 Rfe8 {-1.78/29}) 18. Bc7 {2.2/28} Bxc7 {-2.46/26} (18... Bd6 19. Bxb7 {-2.38/28}) 19. Rxc7 {2.65/26} Qd6 {-3.09/25} (19... Rad8 20. Qxb7 Rb8 21. Qa7 Qb6 {-2.65/25}) 20. Rd7 {3.15/24} Qf6 {-3.47/26} (20... Qa6 21. Qxa6 {-3.16/24}) 21. Rxb7 {2.49/25} (21. b3 Qa6 22. Qxa6 Rxa6 23. Rxb7 {3.44/26}) Be6 {-2.5/23} 22. h4 {2.57/24} Rac8 {-3.32/25} (22... Rfc8 23. Rb6 {-2.86/25}) 23. Qb4 {2.82/23} (23. Ra1 Rc2 {3.53/24}) Rfe8 $1 {-2.7/26} (23... Bh3 24. Ra1 e5 25. Qd2 Rb8 {-2.84/24}) 24. Ra1 {2.71/30} h5 {-2.86/28} 25. Qd2 {2.03/23} (25. Kg2 Bg4 {2.6/26}) Bg4 {-1.98/25} 26. Bxg4 {2.06/24} hxg4 {-2.15/26} 27. Rb5 {1.81/22} (27. b4 Ra8 28. Raa7 Rxa7 29. Rxa7 {2.12/25}) Rc7 {-1.88/24} (27... Rc6 28. b4 Rec8 29. Qg5 Rc2 {-1.92/23}) 28. Rba5 {1.51/25} (28. b4 Kg7 {1.79/24}) Kg7 {-1.65/24} 29. Ra6 {1.45/25} (29. b4 Rb8 {1.56/25}) e6 {-1.72/24} (29... Qf5 30. R6a5 e5 31. Rc1 Rec8 {-1.19/26}) 30. Ra8 {1.35/28} (30. Rc1 Rxc1+ 31. Qxc1 Rb8 32. Qd2 {1.76/27}) Rec8 {-2.09/26} (30... Rxa8 31. Rxa8 e5 32. Ra1 Rb7 {-1.36/30}) 31. Rxc8 {1.96/28} Rxc8 {-2.27/28} 32. b4 {2.38/30} Qe5 $1 {-2.26/27} (32... e5 33. b5 Qb6 34. Rb1 Rc5 {-2.4/28}) 33. Qb2 $1 {2.47/30} (33. Kh2 Qf5 34. Kg1 Qe5 35. Qb2 {2.16/27}) Rb8 {-2.52/28} 34. Qd2 {2.49/25} (34. Rc1 Qd5 {2.49/28}) Qd6 $1 {-2.5/26} (34... Qf6 35. Qb2 {-2.57/27}) 35. Qg5 {2.37/25} Rxb4 {-2.62/27} (35... Qxb4 36. Qe5+ {-2.65/27}) 36. h5 {3.42/29} Qb8 {-5.19/26} (36... Rb7 37. Qxg4 {-2.94/27}) 37. Qxg4 {5.08/27} e5 {-5.46/26} (37... Rb1+ 38. Rxb1 {-5.92/28}) 38. hxg6 {5.85/28} fxg6 {-6.13/28} 39. Qd7+ {6.65/28} (39. Qe4 Rb6 40. Ra5 Kf6 41. Qh4+ {6.22/30}) Kh6 {-7.47/27} (39... Kf6 40. Qc6+ {-6.61/29}) 40. Ra7 {7.74/23} (40. Qe7 Rb7 {6.08/28}) Rb1+ {-8.62/28} (40... Qxa7 41. Qxa7 {-8.04/24}) 41. Kg2 {8.73/30} Rb6 {mated in 11} (41... Qxa7 42. Qxa7 e4 43. Qa8 Kg7 {-8.88/27}) 42. Qh3+ {mate in 10} ({mate in 10} 42. Qh7+ Kg5 43. Qh4+ Kf5 44. e4+ dxe3 45. Rf7+ Ke6 46. Rf6+ Ke7 47. Rxg6+ Rf6 48. Qxf6+ Ke8 49. Qh8+ Kd7 50. Qh7+ Kc8 51. Rg8# {319.81/47}) Kg5 {mated in 9} 43. Rf7 {mate in 20} ({mate in 9} 43. Qh4+ Kf5 44. e4+ dxe3 45. Rf7+ Ke6 46. Rf6+ Ke7 47. Rxg6+ Rf6 48. Qxf6+ Ke8 49. Qh8+ Kd7 50. Qh7+ Kc8 51. Rg8# {319.83/60}) Qa8+ {mated in 4} ({mated in 16} 43... Qb7+ 44. Rxb7 Rxb7 45. Qh4+ Kf5 46. Qe4+ Kf6 47. Qxb7 Ke6 48. Qc6+ Ke7 49. Qxg6 Kd7 50. Qf6 e4 51. Qxd4+ Ke7 52. dxe4 Ke6 53. Kf3 Kf7 54. Kg4 Kg6 55. Qd7 Kf6 56. Qe8 Kg7 57. Kg5 Kh7 58. Kf6 Kh6 59. Qh8# {-319.68/42}) 44. f3 {mate in 3} 1-0
```

## Credits
* [Julia Chess](https://github.com/romstad/Chess.jl)
