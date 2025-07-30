subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_bj,UNIVERALSET) &
size(C_bj,M2) &
2*M2 >= N - T + 1 &
subset(B_bi,UNIVERALSET) &
size(B_bi,M3) &
2*M3 >= N + 3*T + 1 &
diff(UNIVERALSET,F,M4) &
inters(C_bj,B_bi,M5) &
inters(M5,M4,M6) &
size(M6,M7) &
2*M7 < N - T + 1

