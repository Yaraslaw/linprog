subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
B_dy =< N &
B_dy >= 0 &
2*B_dy >= N + 3*T + 1 &
A_dx =< N &
A_dx >= 0 &
A_dx >= N - T &
diff(UNIVERALSET,F,M2) &
size(M2,M3) &
3*B_dy + 2*A_dx + M3 - 5*N < 1 &
1 > 0

