subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(A_v,UNIVERALSET) &
size(A_v,M2) &
M2 >= N - T &
subset(A_u,UNIVERALSET) &
size(A_u,M3) &
M3 >= N - T &
diff(UNIVERALSET,F,M4) &
inters(A_u,A_v,M5) &
inters(M5,M4,M6) &
size(M6,M7) &
2*M7 < N - T + 1

