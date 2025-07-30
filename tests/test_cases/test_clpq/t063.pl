(
    {
      A >= 0, B >= 0, C >= 0, D >= 0, E >= 0, F >= 0,
      A =< 10, B =< 10, C =< 10, D =< 10, E =< 10, F =< 10,
      A + B + C + D + E + F = 20,
      A + B + C >= 15,
      D + E + F >= 10,
      A + D =< 5,
      B + E =< 5,
      C + F =< 5
    },
    bb_inf([A, B, C, D, E, F], A+B+C+D+E+F, MinVal, Solution)
)