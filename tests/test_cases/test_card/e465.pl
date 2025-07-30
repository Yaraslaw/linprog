subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_gq,UNIVERALSET) &
size(C_gq,M2) &
2*M2 >= N - T + 1 &
subset(B_gp,UNIVERALSET) &
size(B_gp,M3) &
2*M3 >= N + 3*T + 1 &
subset(B_go,UNIVERALSET) &
size(B_go,M4) &
2*M4 >= N + 3*T + 1 &
inters(C_gq,B_gp,M5) &
inters(M5,B_go,M6) &
size(M6,0)

