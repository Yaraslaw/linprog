(
    {
      A >= 0, B >= 0, C >= 0, D >= 0, E >= 0, F >= 0,
      G >= 0, H >= 0, I >= 0, J >= 0, K >= 0, L >= 0,
      M >= 0, N >= 0,
      A =< 12, B =< 12, C =< 12, D =< 12, E =< 12, F =< 12,
      G =< 12, H =< 12, I =< 12, J =< 12, K =< 12, L =< 12,
      M =< 12, N =< 12,
      A + B + C + D + E + F + G = 30,
      H + I + J + K + L + M + N >= 32,
      B >= A + 1,
      D + E >= 10,
      F = C + 5,
      2*H + 3*I >= 20,
      J >= B + 2,
      K = A + 3,
      L + M >= 8,
      N =< G + 4
    },
    bb_inf([A, B, C, D, E, F, G, H, I, J, K, L, M, N],
           3*A - 2*B + C + D - E + 2*F + G + H - 2*I + 4*J - K + L + M - N,
           MinVal, Solution)
)