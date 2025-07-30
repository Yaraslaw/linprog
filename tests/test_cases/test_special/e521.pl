subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
C_bb =< N &
C_bb >= 0 &
2*C_bb >= N - T + 1 &
B_ba =< N &
B_ba >= 0 &
2*B_ba >= N + 3*T + 1 &
A_z =< N &
A_z >= 0 &
A_z >= N - T &
diff(UNIVERALSET,F,M2) &
size(M2,M3) &
2*(C_bb + B_ba + A_z + M3 - 3*N) < N - T + 1 &
N - T + 1 > 2*0

