subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
C_eb =< N &
C_eb >= 0 &
2*C_eb >= N - T + 1 &
B_ea =< N &
B_ea >= 0 &
2*B_ea >= N + 3*T + 1 &
A_dz =< N &
A_dz >= 0 &
A_dz >= N - T &
diff(UNIVERALSET,F,M2) &
size(M2,M3) &
C_eb + 2*B_ea + 2*A_dz + M3 - 5*N < 1 &
1 > 0

