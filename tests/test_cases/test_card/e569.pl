subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
B_du =< N &
B_du >= 0 &
2*B_du >= N + 3*T + 1 &
A_dt =< N &
A_dt >= 0 &
A_dt >= N - T &
diff(UNIVERALSET,F,M2) &
size(M2,M3) &
B_du + 2*A_dt + M3 - 3*N < 1 &
1 > 0

