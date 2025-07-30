subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
B_bf =< N &
B_bf >= 0 &
2*B_bf >= N + 3*T + 1 &
A_be =< N &
A_be >= 0 &
A_be >= N - T &
diff(UNIVERALSET,F,M2) &
size(M2,M3) &
B_bf + A_be + M3 - 2*N < N - T &
N - T > 0

