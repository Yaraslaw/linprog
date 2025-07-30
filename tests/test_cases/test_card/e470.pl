subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(A_hd,UNIVERALSET) &
size(A_hd,M2) &
M2 >= N - T &
subset(A_hc,UNIVERALSET) &
size(A_hc,M3) &
M3 >= N - T &
subset(A_hb,UNIVERALSET) &
size(A_hb,M4) &
M4 >= N - T &
diff(UNIVERALSET,F,M5) &
inters(A_hd,A_hc,M6) &
inters(M6,A_hb,M7) &
inters(M7,M5,M8) &
size(M8,0)

