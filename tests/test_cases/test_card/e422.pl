subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_ch,UNIVERALSET) &
size(C_ch,M2) &
2*M2 >= N - T + 1 & 
subset(B_cg,UNIVERALSET) &
size(B_cg,M3) &
2*M3 >= N + 3*T + 1 & 
diff(UNIVERALSET,F,M4) &
inters(C_ch,B_cg,M5) &
inters(M5,M4,M6) &
size(M6,0)

