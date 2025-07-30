subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_dd,UNIVERALSET) &
size(C_dd,M2) &
2*M2 >= N - T + 1 &
subset(B_dc,UNIVERALSET) &
size(B_dc,M3) &
2*M3 >= N + 3*T + 1 & 
subset(A_db,UNIVERALSET) &
size(A_db,M4) &
M4 >= N - T & 
inters(C_dd,B_dc,M5) &
inters(M5,A_db,M6) &
diff(UNIVERALSET,M6,M7) &
size(M7,M8) &
M8 >= 1

