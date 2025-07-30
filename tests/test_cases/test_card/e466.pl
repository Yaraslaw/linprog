subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_gs,UNIVERALSET) &
size(C_gs,M2) &
2*M2 >= N - T + 1 &
subset(B_gr,UNIVERALSET) &
size(B_gr,M3) &
2*M3 >= N + 3*T + 1 &
inters(C_gs,B_gr,M5) &
size(M5,0)

