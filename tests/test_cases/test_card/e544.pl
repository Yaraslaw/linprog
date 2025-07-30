subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
C_cj =< N &
C_cj >= 0 &
2*C_cj >= N - T + 1 &
B_ci =< N &
B_ci >= 0 &
2*B_ci >= N + 3*T + 1 &
diff(UNIVERALSET,F,M2) &
inters(F,M2,M3) &
size(M3,M4) &
C_cj + B_ci + M4 - 2*N < 1 &
1 > 0

