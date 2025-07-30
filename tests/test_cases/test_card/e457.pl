subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_fs,UNIVERALSET) &
size(B_fs,M2) &
2*M2 >= N + 3*T + 1 &
subset(B_fr,UNIVERALSET) &
size(B_fr,M3) &
2*M3 >= N + 3*T + 1 &
subset(A_fq,UNIVERALSET) &
size(A_fq,M4) &
M4 >= N - T &
subset(A_fp,UNIVERALSET) &
size(A_fp,M5) &
M5 >= N - T &
diff(UNIVERALSET,F,M7) &
inters(B_fs,B_fr,M8) &
inters(M8,A_fq,M9) &
inters(M9,A_fp,M10) &
inters(M10,M7,M11) &
size(M11,M12) &
2*M12 < N + 3*T + 1

