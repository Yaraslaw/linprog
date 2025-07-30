subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_fw,UNIVERALSET) &
size(B_fw,M2) &
2*M2 >= N + 3*T + 1 &
subset(B_fv,UNIVERALSET) &
size(B_fv,M3) &
2*M3 >= N + 3*T + 1 &
subset(A_fu,UNIVERALSET) &
size(A_fu,M4) &
M4 >= N - T &
subset(A_ft,UNIVERALSET) &
size(A_ft,M5) &
M5 >= N - T &
diff(UNIVERALSET,F,M7) &
inters(B_fw,B_fv,M8) &
inters(M8,A_fu,M9) &
inters(M9,A_ft,M10) &
inters(M10,M7,M11) &
size(M11,M12) &
2*M12 < N - T + 1

