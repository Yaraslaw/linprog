subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_dn,UNIVERALSET) &
size(C_dn,M2) &
2*M2 >= N - T + 1 &
diff(UNIVERALSET,F,M3) &
inters(C_dn,M3,M4) &
size(M4,0)

