subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_cr,UNIVERALSET) &
size(C_cr,M2) &
2*M2 >= N - T + 1 & 
subset(B_cq,UNIVERALSET) &
size(B_cq,M3) &
2*M3 >= N + 3*T + 1 & 
diff(UNIVERALSET,F,M4) &
inters(C_cr,B_cq,M5) &
inters(M4,M5,M6) &
size(M6,M7) &
M7 < N - T

