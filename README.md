# Savvy
A julia script that analyzes positions in a chess game

## 1. &nbsp; Setup
* Install [Julia](https://julialang.org/downloads/)
* Use the [Julia Chess](https://github.com/romstad/Chess.jl) package

## 2. &nbsp; Command line
#### 2.1. &nbsp; Help
`julia savvy.jl --help`

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
`--analyzewinloss`

#### 2.7. &nbsp; Analyze games with decisive results by a specific player
`--playername "Carlsen, Magnus" --analyzewinloss`

#### 2.8. &nbsp; Analyze games with decisive results in the opening only
`--evalstartmove 4 --evalendmove 24 --analyzewinloss`

## 3. &nbsp; Sample output
```
[Event "New in Chess Classic Prelims 2021"]
[Site "http://www.chessbomb.com"]
[Date "2021.04.24"]
[Round "03"]
[White "Carlsen, Magnus"]
[Black "Dominguez Perez, Leinier"]
[Result "1-0"]
[BlackClock "0:00:27"]
[BlackElo "2758"]
[BlackFideId "3503240"]
[ECO "C54"]
[TimeControl "900+10"]
[WhiteClock "0:06:59"]
[WhiteElo "2847"]
[WhiteFideId "1503014"]
[Annotator "Stockfish 13 @30000 ms/pos"]

1. e4 e5 2. Nf3 Nc6 3. Bc4 Bc5 4. c3 Nf6 5. d3 d6 6. O-O O-O 7. Re1 a5
8. Bg5 h6 9. Bh4 g5 10. Bg3 Ba7 11. Nbd2 Nh7 12. Nf1 h5 13. h4 g4
14. N3h2 {-0.25/29} Ne7 {-0.26/29} (14... Be6 15. Bb3 {0.26/29})
15. Qd2 {0.71/31} Kg7 {-0.59/33} (15... b5 16. Bxb5 f5
17. exf5 Nxf5 {-0.54/34}) 16. d4 {0.47/33} Ng6 {-0.37/35}
17. Rad1 {0.54/35} Nxh4 {-0.4/32} (17... Be6 18. Bxe6 fxe6
19. Ne3 Nxh4 {-0.27/35})
18. dxe5 {0.43/35} Ng6 $2 {-1.83/33} (18... Be6 19. Bxe6 {-0.46/34})
19. exd6 {1.89/36} h4 {-2.21/35} (19... Be6 20. dxc7 Qxd2
21. Nxd2 h4 {-1.76/35}) 20. d7 {2.36/36} Bxd7 {-2.5/39}
21. Qxd7 {2.55/38} Qxd7 $1 {-2.62/37} (21... hxg3 22. Nxg3 Qxd7
23. Rxd7 Ne5 {-2.79/37}) 22. Rxd7 {2.58/38} hxg3 {-2.72/37}
23. Nxg3 {2.82/38} Ne5 {-2.63/37} 24. Rxc7 {2.68/36} Rfc8 {-2.74/36}
25. Rxc8 {2.71/35} Rxc8 {-2.92/35} 26. Be2 {2.52/33} Nf6 {-2.58/35}
27. Rd1 {2.63/33} Kg6 {-2.98/33} (27... Kh6 28. Nhf1 Kg6
29. a3 Kg5 {-2.73/32}) 28. Nhf1 {2.57/34} Kg5 {-2.9/33}
29. Ne3 {2.76/30} (29. a4 Rh8 30. Ne3 Bxe3
31. fxe3 {2.84/34}) Bxe3 {-2.86/34} (29... Rc7 30. Kf1 Bxe3 31. fxe3 Nc6 {-2.64/29})
30. fxe3 {3.08/33} Rc7 {-3.24/33} (30... a4 {-3.13/31})
31. Kf2 {3.18/35} Rd7 {-3.49/37} (31... b6 32. Rd4 Rc5 33. a4 Rc8 {-3.48/32})
32. Rd4 {3.51/34} (32. Rxd7 Nfxd7 33. b4 a4 34. Bb5 {3.62/37}) Nc6 {-3.86/33} (32... Rc7 33. Bb5 {-3.58/32})
33. Rxd7 {3.28/35} (33. Bb5 Nxd4 {4.04/36}) Nxd7 {-3.78/36}
34. Nf5 {3.37/35} (34. Bb5 Nc5 {3.96/33}) Nce5 {-4.18/32} (34... Nc5 35. Nd6 Kf6 36. Kg3 a4 {-3.36/34})
35. Nd6 {4.51/37} (35. b4 b6 36. Nd6 Kh4 37. Bb5 {4.58/35}) b6 {-4.72/34}
36. Bc4 {3.09/33} (36. b4 Kh4 {4.41/35}) Kf6 {-4.01/34} (36... Nxc4 37. Nxc4 {-3.68/34})
37. b4 {4.24/34} Ke7 {-4.24/36} 38. Nf5+ {4.29/32} Kd8 {-4.32/34} (38... Kf8 39. Ba6 {-4.15/34})
39. Bd5 {4.33/31} axb4 {-4.99/34} (39... f6 40. Kg3 {-4.71/30}) 40. cxb4 {4.96/35} Nd3+ {-5.12/36}
41. Kg3 {5.09/36} Nxb4 {-5.29/35} 42. Bxf7 {5.54/37} Ne5 {-5.3/35}
43. Bb3 {5.36/35} Kd7 {-5.39/36} (43... Nbd3 44. Nd6 {-5.69/33})
44. Nh6 {5.62/34} Kd6 {-6.31/36} (44... Ned3 45. Nxg4 {-5.75/33})
45. Nxg4 {6.37/35} Nbd3 {-7.59/40} (45... Ned3 46. Bc4 {-6.58/36})
46. Nxe5 {8.0/40} Kxe5 {-8.13/37} 47. Kh4 {5.9/40} (47. Bc4 Nb2 48. Bd5 Nd1 49. Kh4 {8.25/39}) Nc5 {-8.8/35} (47... Ne1 48. g4 {-8.44/37})
48. Bd5 {9.45/37} (48. Bc2 Nb7 49. g4 Nd6 50. g5 {9.43/35}) Kf6 {-9.04/41}
49. g4 {9.96/39} (49. Kh5 Nd7 50. g4 Ne5 51. Bb3 {9.75/41}) Nd7 {-10.15/40} 50. Kh5 {10.36/38} Ne5 {-10.52/37}
51. g5+ {11.11/33} (51. Bb3 Kg7 52. Kg5 Ng6 53. Bd5 {10.68/38}) Kg7 {-11.81/35}
52. Bb3 {10.12/37} (52. a4 Ng6 53. Be6 Ne5 54. Bb3 {13.4/36}) b5 {-10.6/36}
53. a3 {11.2/32} (53. Be6 Kh7 {10.65/39}) Kh7 {-12.87/33} (53... Nc6 54. Bd1 {-11.72/31})
54. Bd1 {13.88/33} Nc4 {-16.67/32} (54... Nc6 55. e5 {-15.23/32})
55. e5 {16.68/32} (55. Be2 Nxe3 {21.06/33}) Kg7 {-20.0/29}
56. e6 {16.01/31} (56. Be2 Nxe3 57. Bxb5 Nf5 58. a4 {21.83/33}) Nxa3 {mated in 16} (56... Nxe3 57. Be2 {-19.64/33})
57. e7 {mate in 14} Kf7 {mated in 14}
58. g6+ {mate in 13} Kxe7 {mated in 13}
59. g7 {mate in 12} Kf7 {mated in 11} ({mated in 12} 59... Nc4 60. g8=Q Kd6 61. Qf8+ Kc6 62. Bf3+ Kb6 63. Qb4 Nxe3 64. Qd4+ Ka5 65. Qxe3 Kb4 66. Qd4+ Kb3 67. Bd1+ Ka2 68. Qd5+ Kb2 69. Qb3+ Ka1 70. Bc2 b4 71. Qb1# {-319.76/89})
60. Kh6 {mate in 10} 1-0
```

## 4. &nbsp; Credits
* [Julia Chess](https://github.com/romstad/Chess.jl)
