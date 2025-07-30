subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_ba,UNIVERALSET) &
size(B_ba,M2) &
2*M2 >= N + 3*T + 1 &
subset(B_z,UNIVERALSET) &
size(B_z,M3) &
M3 >= N - T &
subset(A_y,UNIVERALSET) &
size(A_y,M4) &
M4 >= N - T &
diff(UNIVERALSET,F,M5) &
inters(B_ba,B_z,M6) &
inters(M6,A_y,M7) &
inters(M7,M5,M8) &
size(M8,M9) &
2*M9 < N - T + 1

