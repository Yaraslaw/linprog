subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_ck,UNIVERALSET) &
size(C_ck,M2) &
2*M2 >= N - T + 1 & 
subset(B_cj,UNIVERALSET) &
size(B_cj,M3) &
2*M3 >= N + 3*T + 1 & 
subset(B_ci,UNIVERALSET) &
size(B_ci,M4) &
2*M4 >= N + 3*T + 1 & 
diff(UNIVERALSET,F,M5) &
inters(C_ck,B_cj,M6) &
inters(M6,B_ci,M7) &
inters(M7,M5,M8) &
size(M8,0)

