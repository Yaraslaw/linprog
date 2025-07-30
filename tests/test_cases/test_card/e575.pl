subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
B_ei =< N &
B_ei >= 0 &
2*B_ei >= N - T + 1 &
A_eh =< N &
A_eh >= 0 &
2*A_eh >= N + 3*T + 1 &
diff(UNIVERALSET,F,M2) &
size(M2,M3) &
2*B_ei + 2*A_eh + M3 - 4*N < N - T &
N - T > 0

