# Savvy
A julia script that analyzes positions in a chess game

## Setup
* Install [Julia](https://julialang.org/downloads/)

## Sample output
```
[Event "New in Chess Classic Prelims 2021"]
[Site "http://www.chessbomb.com"]
[Date "Sat Apr 24 2021"]
[Round "01"]
[White "Carlsen, Magnus"]
[Black "Karjakin, Sergey"]
[Result "1/2-1/2"]
[WhiteFideId "1503014"]
[BlackFideId "14109603"]
[WhiteElo "2847"]
[BlackElo "2757"]
[TimeControl "900+10"]
[WhiteClock "0:01:29"]
[BlackClock "0:01:07"]
[Annotator "Stockfish @500 ms/pos"]

1. e4 e5 2. Nf3 Nc6 3. Bb5 Nf6 4. d3 Bc5 5. c3 O-O 6. O-O d5 7. exd5 Qxd5 8. Bc4 {game: Bc4 0.0/17} Qd8 {game: Qd8 -0.0/17, engine: Qd6 -0.0/18} 9. b4 {game: b4 0.0/17} Bd6 {game: Bd6 -0.0/17, engine: Be7 -0.0/19} 10. Nbd2 {game: Nbd2 0.0/17, engine: Re1 0.0/18} h6 {game: h6 -0.0/18, engine: Ne7 -0.0/19} 11. Re1 {game: Re1 0.0/18} Re8 {game: Re8 -0.0/18, engine: a6 -0.0/18} 12. Bb2 {game: Bb2 0.0/18, engine: a4 0.0/17} a6 {game: a6 -0.0/17, engine: Bf5 -0.0/18} 13. a4 {game: a4 0.0/18, engine: Qc2 0.0/16} Be6 {game: Be6 -1.0/18, engine: Bf5 -0.0/19} 14. b5 {game: b5 1.0/19} Na5 {game: Na5 -1.0/18, engine: axb5 -1.0/19} 15. Bxe6 {game: Bxe6 1.0/19} Rxe6 {game: Rxe6 -1.0/19} 16. c4 {game: c4 1.0/18} Qe7 {game: Qe7 -1.0/18} 17. Qc2 {game: Qc2 1.0/17, engine: Nf1 1.0/17} Nd7 {game: Nd7 -1.0/17, engine: c6 -1.0/17} 18. Re2 {game: Re2 0.0/16, engine: h3 1.0/17} Re8 {game: Re8 -1.0/17, engine: Nc5 -1.0/17} 19. Rae1 {game: Rae1 1.0/18} axb5 {game: axb5 -1.0/19, engine: Bb4 -1.0/18} 20. axb5 {game: axb5 1.0/18, engine: cxb5 1.0/20} b6 {game: b6 -1.0/19} 21. d4 {game: d4 0.0/20, engine: Bc3 0.0/17} exd4 {game: exd4 -0.0/20} 22. Rxe6 {game: Rxe6 0.0/22} fxe6 {game: fxe6 -0.0/20} 23. Bxd4 {game: Bxd4 0.0/20, engine: Nxd4 0.0/19} Bb4 {game: Bb4 -0.0/15, engine: e5 -0.0/19} 24. h3 {game: h3 0.0/16} Nb7 {game: Nb7 -0.0/18} 25. Re2 {game: Re2 0.0/17, engine: Qb3 0.0/17} Bxd2 {game: Bxd2 -1.0/16, engine: Qf7 -0.0/18} 26. Rxd2 {game: Rxd2 1.0/18} Nd6 {game: Nd6 -1.0/18, engine: e5 -1.0/20} 27. Re2 {game: Re2 0.0/19, engine: Ne5 1.0/20} Qf7 {game: Qf7 -1.0/18} 28. Ne5 {game: Ne5 0.0/20, engine: Qa2 0.0/18} Nxe5 {game: Nxe5 -1.0/17, engine: Qf4 -0.0/20} 29. Bxe5 {game: Bxe5 1.0/19} Qf5 {game: Qf5 -1.0/18} 30. Qc3 {game: Qc3 1.0/18} Re7 {game: Re7 -1.0/20} 31. Kh2 {game: Kh2 1.0/17, engine: Qa3 1.0/18} Nb7 $2 {game: Nb7 -2.0/17, engine: Rd7 -1.0/19} 32. Qg3 {game: Qg3 2.0/19} Na5 {game: Na5 -3.0/20, engine: Qg5 -2.0/18} 33. Qc3 {game: Qc3 1.0/19, engine: c5 4.0/19} Rd7 {game: Rd7 -2.0/19} 34. c5 {game: c5 2.0/19} Rd3 {game: Rd3 -1.0/18} 35. Qc2 {game: Qc2 0.0/20, engine: Qb4 1.0/17} Rd5 {game: Rd5 -0.0/22} 36. cxb6 {game: cxb6 0.0/21} Qxc2 {game: Qxc2 -0.0/23} 37. Rxc2 {game: Rxc2 0.0/24} cxb6 {game: cxb6 -0.0/25} 38. Rc8+ {game: Rc8+ 0.0/19} Kh7 {game: Kh7 -0.0/22} 39. f4 {game: f4 0.0/22} g5 {game: g5 -0.0/22} 40. Rc7+ {game: Rc7+ 0.0/21} Kg8 {game: Kg8 -0.0/22} 41. Rg7+ {game: Rg7+ 0.0/22, engine: Re7 0.0/20} Kf8 {game: Kf8 -0.0/22} 42. Rg6 {game: Rg6 0.0/19} Nc4 {game: Nc4 -0.0/20} 43. Bc3 {game: Bc3 0.0/22, engine: Rxe6 0.0/19} gxf4 {game: gxf4 0.0/22} 44. Rxe6 {game: Rxe6 0.0/24} Rxb5 {game: Rxb5 -0.0/24} 45. Rxh6 {game: Rxh6 0.0/22, engine: Re4 0.0/23} Rf5 {game: Rf5 0.0/24} 46. Rc6 {game: Rc6 0.0/22, engine: Kg1 0.0/23} b5 {game: b5 0.0/24} 47. Rc7 {game: Rc7 0.0/20, engine: Kg1 0.0/24} f3 {game: f3 0.0/18, engine: Rg5 0.0/20} 48. gxf3 {game: gxf3 0.0/19} Rxf3 {game: Rxf3 0.0/22} 49. Bd4 {game: Bd4 -0.0/17, engine: Bb4+ 0.0/21} Rd3 {game: Rd3 0.0/17, engine: Nd2 0.0/17} 50. Bf6 {game: Bf6 0.0/18, engine: Ba1 0.0/18} Rf3 {game: Rf3 -0.0/18} 51. Bd4 {game: Bd4 0.0/18, engine: Bg5 0.0/18} Rd3 {game: Rd3 0.0/19} 52. Bc5+ {game: Bc5+ 0.0/18, engine: Ba1 0.0/18} Kg8 {game: Kg8 -0.0/18, engine: Ke8 0.0/18} 53. Rb7 {game: Rb7 0.0/19} Rb3 {game: Rb3 -0.0/17, engine: Rd5 -0.0/19} 54. h4 {game: h4 0.0/19} Ne5 {game: Ne5 -0.0/17, engine: Na5 -0.0/17} 55. h5 {game: h5 0.0/18, engine: Bd6 0.0/18} Rd3 {game: Rd3 -0.0/18} 56. Kg2 {game: Kg2 0.0/19} Rd5 {game: Rd5 0.0/19} 57. Be3 {game: Be3 0.0/22, engine: Rb8+ 0.0/20} Nc4 {game: Nc4 0.0/23} 58. Bf4 {game: Bf4 -0.0/20, engine: Rb8+ 0.0/23} Rxh5 {game: Rxh5 0.0/20} 59. Kf3 {game: Kf3 -0.0/20, engine: Rc7 -0.0/19} Kf8 {game: Kf8 0.0/19, engine: Na5 0.0/22} 60. Ke4 {game: Ke4 -0.0/18, engine: Bg3 -0.0/18} Ke8 {game: Ke8 0.0/21, engine: Na5 0.0/20} 61. Rg7 {game: Rg7 -0.0/19, engine: Ra7 -0.0/18} Kf8 {game: Kf8 0.0/21, engine: Na5 0.0/20} 62. Rg5 {game: Rg5 -0.0/18, engine: Ra7 -0.0/20} Rxg5 {game: Rxg5 0.0/23} 63. Bxg5 {game: Bxg5 -0.0/24} b4 {game: b4 0.0/24, engine: Kf7 0.0/25} 64. Kd4 {game: Kd4 -0.0/28, engine: Bc1 -0.0/26} b3 {game: b3 0.0/31} 65. Bc1 {game: Bc1 -0.0/31} b2 {game: b2 0.0/33} 66. Bxb2 {game: Bxb2 -0.0/34} Nxb2 {game: Nxb2 0.0/34} 1/2-1/2

```

## Credits
* [Julia Chess](https://github.com/romstad/Chess.jl)
