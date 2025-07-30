subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(A_gn,UNIVERALSET) &
size(A_gn,M2) &
M2 >= N - T &
subset(A_gm,UNIVERALSET) &
size(A_gm,M3) &
M3 >= N - T &
diff(UNIVERALSET,F,M4) &
inters(A_gn,A_gm,M5) &
inters(M5,M4,M6) &
size(M6,0)

