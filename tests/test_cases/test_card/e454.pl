subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(C_fg,UNIVERALSET) &
size(C_fg,M2) &
2*M2 >= N - T + 1 &
subset(B_ff,UNIVERALSET) &
size(B_ff,M3) &
2*M3 >= N + 3*T + 1 &
subset(B_fe,UNIVERALSET) &
size(B_fe,M4) &
2*M4 >= N + 3*T + 1 &
subset(A_fd,UNIVERALSET) &
size(A_fd,M5) &
M5 >= N - T &
diff(UNIVERALSET,F,M6) &
inters(C_fg,B_ff,M7) &
inters(M7,B_fe,M8) &
inters(M8,A_fd,M9) &
inters(M9,M6,M10) &
size(M10,0)

