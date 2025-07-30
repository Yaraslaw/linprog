subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_gu,UNIVERALSET) &
size(B_gu,M2) &
2*M2 >= N + 3*T + 1 &
subset(B_gt,UNIVERALSET) &
size(B_gt,M3) &
2*M3 >= N + 3*T + 1 &
inters(B_gu,B_gt,M5) &
size(M5,0)

