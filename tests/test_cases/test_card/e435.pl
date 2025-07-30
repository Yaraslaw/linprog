subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_dk,UNIVERALSET) &
size(B_dk,M2) &
2*M2 >= N + 3*T + 1 &
subset(B_dj,UNIVERALSET) &
size(B_dj,M3) &
2*M3 >= N + 3*T + 1 & 
inters(B_dk,B_dj,M4) &
size(M4,0)

