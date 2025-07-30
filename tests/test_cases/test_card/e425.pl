subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_cp,UNIVERALSET) &
size(C_cp,M2) &
2*M2 >= N - T + 1 & 
subset(B_co,UNIVERALSET) &
size(B_co,M3) &
2*M3 >= N + 3*T + 1 & 
diff(UNIVERALSET,F,M4) &
inters(C_cp,B_co,M5) &
inters(M5,F,M6) &
inters(M6,M4,M7) &
size(M7,0)

