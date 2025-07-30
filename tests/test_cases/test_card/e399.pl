subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_x,UNIVERALSET) &
size(B_x,M2) &
2*M2 >= N + 3*T + 1 &
subset(A_w,UNIVERALSET) &
size(A_w,M3) &
M3 >= N - T &
diff(UNIVERALSET,F,M4) &
inters(B_x,A_w,M5) &
inters(M5,M4,M6) &
size(M6,M7) &
2*M7 < N - T + 1

