subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_cb,UNIVERALSET) &
size(B_cb,M2) &
2*M2 >= N + 3*T + 1 & 
diff(UNIVERALSET,F,M3) &
inters(B_cb,M3,M4) &
size(M4,M5) &
2*M5 < N - T + 1

