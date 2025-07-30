(
    {
      A >= 0, B >= 0, C >= 0, D >= 0, E >= 0,
      F >= 0, G >= 0, H >= 0, I >= 0, J >= 0,
      A =< 12, B =< 12, C =< 12, D =< 12, E =< 12,
      F =< 12, G =< 12, H =< 12, I =< 12, J =< 12,
      A + B + C + D >= 20,
      E + F + G + H + I + J = 28,
      2*B + 3*C + D >= 15,
      G >= F + 2,
      H + I >= 10,
      J =< A + 4,
      D = E + 1
    },
    bb_inf([A, B, C, D, E, F, G, H, I, J], 2*A - B + 3*C + D - E + 2*F + G - 2*H + 4*I - J, MinVal, Solution)
)