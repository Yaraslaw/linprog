subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(A_ca,UNIVERALSET) &
size(A_ca,M2) &
M2 >= N - T & 
diff(UNIVERALSET,F,M3) &
inters(A_ca,M3,M4) &
size(M4,M5) &
2*M5 < N - T + 1

