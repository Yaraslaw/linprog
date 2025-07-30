subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_cn,UNIVERALSET) &
size(C_cn,M2) &
2*M2 >= N - T + 1 & 
subset(C_cm,UNIVERALSET) &
size(C_cm,M3) &
2*M3 >= N - T + 1 & 
subset(B_cl,UNIVERALSET) &
size(B_cl,M4) &
2*M4 >= N + 3*T + 1 & 
diff(UNIVERALSET,F,M5) &
inters(C_cn,C_cm,M6) &
inters(M6,B_cl,M7) &
inters(M7,M5,M8) &
size(M8,0)

