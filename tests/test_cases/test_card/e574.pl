subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
C_eg =< N &
C_eg >= 0 &
2*C_eg >= N - T + 1 &
B_ef =< N &
B_ef >= 0 &
2*B_ef >= N + 3*T + 1 &
A_ee =< N &
A_ee >= 0 &
A_ee >= N - T &
diff(UNIVERALSET,F,M2) &
size(M2,M3) &
C_eg + 2*B_ef + A_ee + M3 - 4*N < 1 &
1 > 0

