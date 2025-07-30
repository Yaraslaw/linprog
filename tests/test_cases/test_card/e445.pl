subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_eb,UNIVERALSET) &
size(C_eb,M2) &
2*M2 >= N - T + 1 &
subset(B_ea,UNIVERALSET) &
size(B_ea,M3) &
2*M3 >= N + 3*T + 1 &
inters(C_eb,B_ea,M4) &
size(M4,0)

