subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_by,UNIVERALSET) &
size(C_by,M2) &
2*M2 >= N - T + 1 & 
diff(UNIVERALSET,F,M3) &
inters(C_by,M3,M4) &
size(M4,M5) &
2*M5 < N - T + 1

