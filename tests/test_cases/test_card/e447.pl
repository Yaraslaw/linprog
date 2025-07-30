subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(A_ee,UNIVERALSET) &
size(A_ee,M2) &
M2 >= N - T &
subset(A_ed,UNIVERALSET) &
size(A_ed,M3) &
M3 >= N - T &
diff(UNIVERALSET,F,M4) &
inters(A_ee,A_ed,M5) &
inters(M5,M4,M6) &
size(M6,0)

