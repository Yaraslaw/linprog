subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_dq,UNIVERALSET) &
size(C_dq,M2) &
M2 >= N - T + 1 &
subset(A_dp,UNIVERALSET) &
size(A_dp,M3) &
M3 >= N - T &
inters(C_dq,A_dp,M4) &
size(M4,0)

