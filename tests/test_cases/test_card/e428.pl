subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_cv,UNIVERALSET) &
size(C_cv,M2) &
2*M2 >= N - T + 1 &
subset(B_cu,UNIVERALSET) &
size(B_cu,M3) &
2*M3 >= N + 3*T + 1 & 
diff(UNIVERALSET,F,M4) &
inters(C_cv,B_cu,M5) &
inters(M5,M4,M6) &
size(M6,M7) &
2*M7 < N + 3*T + 1

