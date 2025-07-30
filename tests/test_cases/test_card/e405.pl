subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_bl,UNIVERALSET) &
size(B_bl,M2) &
2*M2 >= N + 3*T + 1 &
subset(A_bk,UNIVERALSET) &
size(A_bk,M3) &
M3 >= N - T &
diff(UNIVERALSET,F,M4) &
inters(B_bl,A_bk,M5) &
inters(M5,M4,M6) &
size(M6,M7) &
2*M7 < N + 3*T + 1

