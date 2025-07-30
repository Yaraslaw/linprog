subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_gx,UNIVERALSET) &
size(B_gx,M2) &
2*M2 >= N + 3*T + 1 &
subset(B_gw,UNIVERALSET) &
size(B_gw,M3) &
2*M3 >= N + 3*T + 1 &
subset(A_gv,UNIVERALSET) &
size(A_gv,M4) &
M4 >= N - T &
inters(B_gx,B_gw,M5) &
inters(M5,A_gv,M6) &
size(M6,0)

