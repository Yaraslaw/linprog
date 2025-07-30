subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_bn,UNIVERALSET) &
size(C_bn,M2) &
2*M2 >= N - T + 1 &
subset(A_bm,UNIVERALSET) &
size(A_bm,M3) &
M3 >= N - T &
diff(UNIVERALSET,F,M4) &
inters(C_bn,A_bm,M5) &
inters(M5,M4,M6) &
size(M6,M7) &
2*M7 < N - T + 1

