/*

Solution: 
I = 2,
V = [1, 1, 2, 5],
{D>=5},
{B>=1, A>=1, C=B+A}.

V = [1, 1, 2, 0], 
is NOT a solution, because:
D >= 5
*/

( {D >= 5,
 C=A+B,
 A >= 1, B >= 1},
 bb_inf([A, B, C, D], C,I,V))