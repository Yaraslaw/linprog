subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_bf,UNIVERALSET) &
size(B_bf,M2) &
2*M2 >= N + 3*T + 1 &
subset(A_be,UNIVERALSET) &
size(A_be,M3) &
M3 >= N - T &
diff(UNIVERALSET,F,M4) &
inters(B_bf,A_be,M5) &
inters(M5,F,M6) &
inters(M6,M5,M7) &
size(M7,M8) &
2*M8 < N - T + 1

