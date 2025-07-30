subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_fc,UNIVERALSET) &
size(B_fc,M2) &
2*M2 >= N + 3*T + 1 &
subset(B_fb,UNIVERALSET) &
size(B_fb,M3) &
2*M3 >= N + 3*T + 1 &
subset(A_fa,UNIVERALSET) &
size(A_fa,M4) &
M4 >= N - T &
subset(A_ez,UNIVERALSET) &
size(A_ez,M5) &
M5 >= N - T &
diff(UNIVERALSET,F,M7) &
inters(B_fc,B_fb,M8) &
inters(M8,A_fa,M9) &
inters(M9,A_ez,M10) &
inters(M10,F,M11) &
inters(M11,M7,M12) &
size(M12,0)

