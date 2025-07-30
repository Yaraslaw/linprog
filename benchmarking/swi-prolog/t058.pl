(
    {
      A >= 0, B >= 0, C >= 0, D >= 0, E >= 0, F >= 0, G >= 0,
      A =< 15, B =< 15, C =< 15, D =< 15, E =< 15, F =< 15, G =< 15,
      A + B + C + D + E + F + G >= 30,
      A + B + C >= 12,
      D + E + F + G >= 20,
      2*B + 3*C + D >= 18,
      E = A + 2
    },
    bb_inf([A, B, C, D, E, F, G], 2*A + 3*B - C + 2*D - E + F + 4*G, MinVal, Solution)
)