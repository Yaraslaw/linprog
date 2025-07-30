subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
B_bd =< N &
B_bd >= 0 &
2*B_bd >= N + 3*T + 1 &
A_bc =< N &
A_bc >= 0 &
A_bc >= N - T &
diff(UNIVERALSET,F,M2) &
inters(F,M2,M3) &
size(M3,M4) &
2*(B_bd + A_bc + M4 - 2*N) < N - T + 1 &
N - T + 1 > 2*0

