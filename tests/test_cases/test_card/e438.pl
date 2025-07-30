subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(A_do,UNIVERALSET) &
size(A_do,M2) &
M2 >= N - T &
diff(UNIVERALSET,F,M3) &
inters(A_do,M3,M4) &
size(M4,0)

