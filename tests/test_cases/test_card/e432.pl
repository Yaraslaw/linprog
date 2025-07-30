subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
subset(B_df,UNIVERALSET) &
size(B_df,M2) &
2*M2 >= N + 3*T + 1 &
subset(B_de,UNIVERALSET) &
size(B_de,M3) &
2*M3 >= N + 3*T + 1 & 
inters(B_df,B_de,M5) &
size(M5,M6) &
2*M6 < N + 3*T + 1

