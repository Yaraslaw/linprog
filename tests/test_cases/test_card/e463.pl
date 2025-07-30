subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(A_gl,UNIVERALSET) &
size(A_gl,M2) &
M2 >= N - T &
subset(A_gk,UNIVERALSET) &
size(A_gk,M3) &
M3 >= N - T &
inters(A_gl,A_gk,M4) &
size(M4,M5) &
2*M5 < N - T + 1

