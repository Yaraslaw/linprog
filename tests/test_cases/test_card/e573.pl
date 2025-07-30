subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
B_ed =< N &
B_ed >= 0 &
2*B_ed >= N + 3*T + 1 &
A_ec =< N &
A_ec >= 0 &
A_ec >= N - T &
diff(UNIVERALSET,F,M2) &
inters(F,M2,M3) &
size(M3,M4) &
2*B_ed + 2*A_ec + M4 - 4*N < 1 &
1 > 0

