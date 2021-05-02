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
julia savvy.jl --engine ./engine/stockfish_13.exe --hashmb 128 --numthreads 1 --inpgn ./pgn/2021-new-in-chess-classic.pgn --outpgn analyzed.pgn --movetime 500
```

## Sample output
```
[Event "New in Chess Classic Prelims 2021"]
[Site "http://www.chessbomb.com"]
[Date "Sat Apr 24 2021"]
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
[Annotator "Stockfish @500 ms/pos"]

1. Nf3 Nf6 2. g3 g6 3. Bg2 Bg7 4. c4 c5 5. Nc3 O-O 6. O-O Nc6 7. d3 d5 8. cxd5 {0.0/18} Nxd5 {0.0/20} 9. Nxd5 {0.0/22} Qxd5 {0.0/22} 10. Be3 {0.0/23} Qd6 {-1.0/18} (10... Bxb2 {0.0/23}) 11. Rc1 {0.0/19} Nd4 {-0.0/19} 12. Nxd4 {1.0/21} cxd4 {-0.0/20} 13. Bd2 {0.0/17} Be6 {-1.0/19} (13... Bg4 {-1.0/17}) 14. Qa4 {1.0/19} a5 {-1.0/19} 15. Qb5 {1.0/18} (15. Rc2 {1.0/19}) Bxa2 $2 {-2.0/20} (15... Bd7 {-1.0/19}) 16. Bxa5 {2.0/19} Qe6 {-1.0/17} (16... Be6 {-2.0/17}) 17. Bf3 {1.0/18} (17. Bc7 {2.0/18}) Be5 $2 {-2.0/19} (17... Qb3 {-1.0/19}) 18. Bc7 {2.0/20} Bxc7 {-2.0/21} (18... Bd6 {-2.0/21}) 19. Rxc7 {2.0/21} Qd6 {-3.0/19} (19... Rab8 {-2.0/20}) 20. Rd7 {3.0/20} Qf6 {-3.0/18} 21. Rxb7 {2.0/20} (21. Qb4 {3.0/19}) Be6 {-2.0/21} 22. h4 {2.0/20} Rac8 {-3.0/18} (22... Rfc8 {-2.0/21}) 23. Qb4 {2.0/18} (23. Ra1 {3.0/19}) Rfe8 {-2.0/19} 24. Ra1 {2.0/20} h5 {-3.0/19} 25. Qd2 {2.0/18} (25. Kg2 {3.0/19}) Bg4 {-2.0/18} (25... Ra8 {-2.0/19}) 26. Bxg4 {2.0/18} (26. Kg2 {2.0/18}) hxg4 {-2.0/19} 27. Rb5 {2.0/18} Rc7 {-2.0/19} (27... Rc6 {-2.0/19}) 28. Rba5 {1.0/19} (28. b4 {2.0/19}) Kg7 {-1.0/19} (28... Rec8 {-2.0/18}) 29. Ra6 {2.0/20} (29. Qg5 {1.0/20}) e6 {-1.0/19} (29... Qf5 {-1.0/21}) 30. Ra8 {1.0/20} (30. b4 {1.0/19}) Rec8 $2 {-2.0/22} (30... Rxa8 {-1.0/22}) 31. Rxc8 {2.0/22} Rxc8 {-2.0/21} 32. b4 {2.0/21} Qe5 {-2.0/19} (32... Rb8 {-2.0/21}) 33. Qb2 {2.0/20} (33. Rb1 {2.0/21}) Rb8 {-2.0/20} 34. Qd2 {2.0/19} (34. Rc1 {2.0/19}) Qd6 {-2.0/19} (34... Rb7 {-2.0/19}) 35. Qg5 {2.0/21} Rxb4 {-3.0/21} (35... Qxb4 {-2.0/20}) 36. h5 {3.0/21} Qb8 {-3.0/20} (36... Rb7 {-3.0/20}) 37. Qxg4 {3.0/21} e5 {-5.0/22} (37... Rb1+ {-3.0/22}) 38. hxg6 {6.0/21} fxg6 {-6.0/20} 39. Qd7+ {6.0/19} Kh6 {-6.0/20} 40. Ra7 {6.0/21} Rb1+ {-6.0/21} 41. Kg2 {6.0/23} Rb6 {-0.0/30} (41... Qxa7 {-6.0/25}) 42. Qh3+ {0.0/39} (42. Qh7+ {0.0/36}) Kg5 {-0.0/42} 43. Rf7 {75.0/28} (43. Qh4+ {0.0/44}) Qa8+ {-0.0/245} (43... Qb7+ {-76.0/33}) 44. f3 {0.0/245} 1-0
```

## Credits
* [Julia Chess](https://github.com/romstad/Chess.jl)
