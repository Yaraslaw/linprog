subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_da,UNIVERALSET) &
size(C_da,M2) &
2*M2 >= N - T + 1 &
subset(B_cz,UNIVERALSET) &
size(B_cz,M3) &
2*M3 >= N + 3*T + 1 & 
subset(A_cy,UNIVERALSET) &
size(A_cy,M4) &
M4 >= N - T & 
inters(C_da,B_cz,M5) &
inters(M5,A_cy,M6) &
size(M6,0)

