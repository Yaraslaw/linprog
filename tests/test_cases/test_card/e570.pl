subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
B_dw =< N &
B_dw >= 0 &
2*B_dw >= N + 3*T + 1 &
A_dv =< N &
A_dv >= 0 &
A_dv >= N - T &
diff(UNIVERALSET,F,M2) &
size(M2,M3) &
2*B_dw + 2*A_dv + M3 - 4*N < 1 &
1 > 0

