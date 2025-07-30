subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
C_bh =< N &
C_bh >= 0 &
2*C_bh >= N - T + 1 &
B_bg =< N &
B_bg >= 0 &
2*B_bg >= N + 3*T + 1 &
diff(UNIVERALSET,F,M2) &
size(M2,M3) &
2*(C_bh + B_bg + M3 - 2*N) < N - T + 1 &
N - T + 1 > 2*0

