(
    {
      A >= 0, B >= 0, C >= 0, D >= 0, E >= 0, F >= 0, G >= 0, H >= 0,
      A =< 10, B =< 10, C =< 10, D =< 10, E =< 10, F =< 10, G =< 10, H =< 10,
      A + B + C + D + E + F + G + H = 40,
      A + B + C =< 5,
      D + E + F =< 5,
      G + H =< 5
    },
    bb_inf([A, B, C, D, E, F, G, H], A+B+C+D+E+F+G+H, MinVal, Solution)
)