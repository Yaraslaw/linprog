subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_di,UNIVERALSET) &
size(B_di,M2) &
2*M2 >= N + 3*T + 1 &
subset(B_dh,UNIVERALSET) &
size(B_dh,M3) &
2*M3 >= N + 3*T + 1 & 
inters(B_di,B_dh,M4) &
size(M4,M5) &
2*M5 < N + 3*T + 1

