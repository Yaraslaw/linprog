subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_ha,UNIVERALSET) &
size(B_ha,M2) &
2*M2 >= N + 3*T + 1 &
subset(B_gz,UNIVERALSET) &
size(B_gz,M3) &
2*M3 >= N + 3*T + 1 &
subset(B_gy,UNIVERALSET) &
size(B_gy,M4) &
2*M4 >= N + 3*T + 1 &
inters(B_ha,B_gz,M5) &
inters(M5,B_gy,M6) &
size(M6,0)

