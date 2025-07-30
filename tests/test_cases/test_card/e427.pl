subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_ct,UNIVERALSET) &
size(C_ct,M2) &
2*M2 >= N - T + 1 &
subset(C_cs,UNIVERALSET) &
size(C_cs,M3) &
2*M3 >= N - T + 1 & 
diff(UNIVERALSET,F,M4) &
inters(C_ct,C_cs,M5) &
inters(M5,M4,M6) &
size(M6,0)

