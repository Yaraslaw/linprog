subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_bq,UNIVERALSET) &
size(B_bq,M2) &
M2 >= N + 3*T + 1 &
subset(A_bp,UNIVERALSET) &
size(A_bp,M3) &
M3 >= N - T &
subset(A_bo,UNIVERALSET) &
size(A_bo,M4) &
M4 >= N - T &
inters(B_bq,A_bp,M5) &
inters(M5,A_bo,M6) &
size(M6,M7) &
2*M7 < N - T + 1

