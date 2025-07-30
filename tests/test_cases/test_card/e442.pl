subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_dw,UNIVERALSET) &
size(C_dw,M2) &
2*M2 >= N - T + 1 &
subset(C_dv,UNIVERALSET) &
size(C_dv,M3) &
2*M3 >= N - T + 1 &
inters(C_dw,C_dv,M4) &
size(M4,0)

