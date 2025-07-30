consult('setlog.pl').
set_prolog_flag(answer_write_options,[max_depth(0)]).
set_prolog_flag(toplevel_print_options, [quoted(true), portray(true), spacing(next_argument)]).
time(once(rsetlog(
un(A1,A2,A3)  & 
un(A3,A4,A5)  & 
un(A5,A6,A7)  & 
un(A7,A8,A9)  & 
un(A9,A10,A11)  & 
un(A11,A12,A13)  & 
un(A13,A14,A15)  & 
un(A15,A16,A17)  & 
un(A17,A18,A19)  & 
size(A1,N1)  & 
size(A2,N2)  & 
size(A4,N4)  & 
size(A6,N6)  & 
size(A8,N8)  & 
size(A10,N10)  & 
size(A12,N12)  & 
size(A14,N14)  & 
size(A16,N16)  & 
size(A18,N18)  & 
size(A19,N19)  & 
N1 + N2 + N4 + N6 + N8 + N10 + N12 + N14 + N16 + N18 < N19












,2000,__C,__R,[fix_size]))).


