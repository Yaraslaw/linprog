subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_bt,UNIVERALSET) &
size(B_bt,M2) &
2*M2 >= N + 3*T + 1 &
subset(A_bs,UNIVERALSET) &
size(A_bs,M3) &
M3 >= N - T &
subset(A_br,UNIVERALSET) &
size(A_br,M4) &
M4 >= N - T &
inters(B_bt,A_bs,M5) &
inters(M5,A_br,M6) &
diff(UNIVERALSET,M6,M7) &
size(M7,M8) &
M8 < 1

