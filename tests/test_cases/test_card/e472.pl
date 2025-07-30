subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(A_hi,UNIVERALSET) &
size(A_hi,M2) &
M2 >= N - T &
subset(A_hh,UNIVERALSET) &
size(A_hh,M3) &
M3 >= N - T &
subset(A_hg,UNIVERALSET) &
size(A_hg,M4) &
M4 >= N - T &
inters(A_hi,A_hh,M5) &
inters(M5,A_hg,M6) &
size(M6,0)

