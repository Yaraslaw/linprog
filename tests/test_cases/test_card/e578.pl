subset(F,UNIVERALSET) &
size(UNIVERALSET,N) &
N > 0 &
N > 3*T &
size(F,M1) &
M1 =< T &
B_ep =< N &
B_ep >= 0 &
2*B_ep >= N + 3*T + 1 &
A_eo =< N &
A_eo >= 0 &
A_eo >= N - T &
diff(UNIVERALSET,F,M2) &
size(M2,M3) &
2*(2*B_ep + 2*A_eo + M3 - 4*N) < N - T + 1 &
N - T + 1 > 2*0

