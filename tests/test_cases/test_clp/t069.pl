/*

Solution: 
I = 4,
V = [7, 3, 4, 7],
{C>=4, B>=3, A=C+B},
{D>=7}.

V = [7, 3, 4, 0], 
is NOT a solution, because:
D >= 7
*/

( {A=B+C,
 B >= 3,
 C >= 4,
 D >= 7},
 bb_inf([A, B, C, D], C, I, V))