subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_dz,UNIVERALSET) &
size(C_dz,M2) &
2*M2 >= N - T + 1 &
subset(A_dy,UNIVERALSET) &
size(A_dy,M3) &
M3 >= N - T &
inters(C_dz,A_dy,M4) &
size(M4,0)

