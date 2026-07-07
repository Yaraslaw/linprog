/*  Linprog: Linear and Mixed-Integer Programming Library for SWI-Prolog

    Author:        Yaraslaw Akhramenka
                   Alfredo Capozucca
                   Maximiliano Cristiá

    Copyright (c) 2025-2026, Yaraslaw Akhramenka,
                        Alfredo Capozucca,
                        Maximiliano Cristiá
    All rights reserved.

    This file is part of Linprog package.

    Linprogq is a SWI-Prolog library providing support for Linear Programming
    (LP) and Mixed-Integer Linear Programming (MILP), with full compatibility
    with the CLP(R) interface. It leverages the GNU Linear Programming Kit
    (GLPK) as a backend solver to ensure robust and efficient optimisation.
*/

:- module(linprogq,
	  [ {}/1,
        entailed/1,
        inf/2, 
        sup/2,
        minimize/1,
        maximize/1,
        bb_inf/5,
	    bb_inf/4,
        bb_inf/3,
        dump/3,
        bb_inf_b/6,
        bb_inf_b/5,
        bb_inf_b/4,
        set_time_limit/1,
        get_time_limit/1,
        set_eps/1,
        get_eps/1, 
        set_solver/1,
        get_solver/1
	  ]).

dbg() :- fail.


/* entailed, inf/sup, minimize/maximize */

negate(Rel,_) :-
	var(Rel),
	!,
	instantiation_error(Rel).

negate((A,B),(Na;Nb)) :-
	!,
	negate(A,Na),
	negate(B,Nb).

negate((A;B),(Na,Nb)) :-
	!,
	negate(A,Na),
	negate(B,Nb).

negate(A<B,A>=B) :- !.
negate(A>B,A=<B) :- !.
negate(A=<B,A>B) :- !.
negate(A>=B,A<B) :- !.
negate(A=:=B,A=\=B) :- !.
negate(A=B,A=\=B) :- !.
negate(A=\=B,A=:=B) :- !.
negate(Rel,_) :-
	type_error(clpq_constraint, Rel).

linking([], []).
linking([H|Tail], [Hn|Tn]) :-
    (number(H), number(Hn) -> true
    ;
        % put_attr(H, clpqLUX, name_n_AllVars('nouni', _)), 
        % H is Hn
        {H =:= Hn}
    ),
    linking(Tail, Tn).

minimize(E) :- 
    findEmALL(E, IntsOrig),
    prepareIntsToBB_INF(IntsOrig, Ints),
    prepareObjToBB_INF(E, Obj, _),
    get_exprs(Cons),
    b_getval(timeLimit, TimeLimit),
    b_getval(eps, Eps),
    b_getval(solver, Solver),
    call(Solver, Cons, Ints, Obj, _, _V, St, Eps, 0, TimeLimit),
    % call for chechking for 4.9999 problem (todo list)
    call(Solver, Cons, Ints, Obj, _, Vint, _, Eps, 1, TimeLimit),
    % (V == Vint -> true; fail),
    % linprog_glpk(Cons, Ints, Obj, _, V, St, Eps, 0, TimeLimit),
    % adding comparation with minimize_glpk for ints 
    (St == 4; St == 6 -> fail, !; true),
    linking(IntsOrig, Vint).



maximize(E) :- minimize((-1)*E).


entailed(E) :- 
    negate(E, En),
    \+ {En}.


findR([], [], _, _).
findR([H|Tail], R, Ints, NewInts) :-
    findR(Tail, OldR, Ints, NewInts),
    (replaceEmAll(H, SingleR, Ints, NewInts) -> R = [SingleR|OldR]; R = OldR).



dump(Ints, NewInts, R) :-
    get_cons(Cons),
    findR(Cons, R, Ints, NewInts).

inf(E, I) :- bb_inf([], E, I).

sup(E, I) :- 
    bb_inf([], (-1)*E, PreI), 
    I is (-1)*PreI.






check(_, []) :- fail.

check(X, [H|Tail]) :- % !,
    (H == X -> true;check(X, Tail)). 


unAtoB([], [], []) :- !.
unAtoB(A, [], Res) :- !,
    Res = A.
unAtoB([], B, Res) :- !,
    Res = B.

unAtoB([H|Tail], B, Res) :- 
    % !,
    (check(H, B) 
    ->
        unAtoB(Tail, B, Res)
    ;
        unAtoB(Tail, B, ResN),

        Res = [H|ResN]).



findEmALL(X, Res) :- 
    (integer(X);float(X)),
	!,
    Res = [].

findEmALL(X, Res) :- 
    var(X), \+ compound(X), 
    !,
    Res = [X].


findEmALL(A+B, Res) :- 
	!,
    findEmALL(A, ResA), findEmALL(B, ResB), 
    unAtoB(ResA, ResB, Res).

findEmALL(A*B, Res) :- 
	!,
    findEmALL(A, ResA), findEmALL(B, ResB), 
    unAtoB(ResA, ResB, Res).

findEmALL(A-B, Res) :- 
	!,
    findEmALL(A, ResA), findEmALL(B, ResB), 
    unAtoB(ResA, ResB, Res).

findEmALL(A=B, Res) :- 
	!,
    findEmALL(A, ResA), findEmALL(B, ResB), 
    unAtoB(ResA, ResB, Res).

findEmALL(A=<B, Res) :- 
	!,
    findEmALL(A, ResA), findEmALL(B, ResB), 
    unAtoB(ResA, ResB, Res).  

findEmALL(A>=B, Res) :- 
	!,
    findEmALL(A, ResA), findEmALL(B, ResB), 
    unAtoB(ResA, ResB, Res).

findEmALL(A>B, Res) :- 
	!,
    findEmALL(A, ResA), findEmALL(B, ResB), 
    unAtoB(ResA, ResB, Res).

findEmALL(A<B, Res) :- 
	!,
    findEmALL(A, ResA), findEmALL(B, ResB), 
    unAtoB(ResA, ResB, Res).

findEmALL(A=:=B, Res) :-
    !,
    findEmALL(A, ResA), findEmALL(B, ResB), 
    unAtoB(ResA, ResB, Res).

findEmALL(A=\=B, Res) :-
    !,
    findEmALL(A, ResA), findEmALL(B, ResB), 
    unAtoB(ResA, ResB, Res).

findEmALL(A/B, Res) :-
    !,
    findEmALL(A, ResA), findEmALL(B, ResB), 
    unAtoB(ResA, ResB, Res).
    

findEmALL((A, B), Res) :- 
    !, 
    findEmALL(A, ResA), findEmALL(B, ResB), 
    unAtoB(ResA, ResB, Res).

findEmALL((A; B), Res) :- 
    !, 
    findEmALL(A, ResA), findEmALL(B, ResB), 
    unAtoB(ResA, ResB, Res).

findEmALL(A, _) :-
    write('ERROR -> findEmALL -> Unkown predicate in : '),
    writeln(A).


/* -------------- */


user:message_hook(query(no), query, _C) :- !, fail.
user:message_hook(query(yes(A, B, [_C]-[])), query, _X) :- !,
    print_message(query, query(yes(A, B, []-[]))).


/* No output for linprogq attributes */
:- set_prolog_flag(write_attributes, ignore).


% WE NEED MORE MEMORY!
% :- set_prolog_flag(stack_limit, 32_000_000_000). % 8MB stack limit, default is 4MB


user:attribute_goals(Var) --> 
    {get_attr(Var, linprog, _)}, [].

/* load locally, then through installation */
:- use_module(library(shlib)).
:- (   catch(load_foreign_library(linprog_glpk_file), _, fail)
    ->  true
    ;   use_foreign_library(foreign(linprog_glpk_file))
    ).
% :- use_module(library(clpfd)).
% :- use_module(library(ordsets)).
:- nb_setval(timeLimit, 1000000). % time limit for GLPK, 1000s by default

:- nb_setval(eps, 0.001). % epsilon for GLPK, 0.001 by default
:- nb_setval(solver, linprog_glpk). % GLPK solver by default

set_time_limit(T) :- 
    integer(T),
    !,
    nb_setval(timeLimit, T).

get_time_limit(T) :- 
    nb_getval(timeLimit, T).

set_eps(E) :- 
    number(E),
    !,
    nb_setval(eps, E).

get_eps(E) :-
    nb_getval(eps, E).

set_solver(S) :-
    member(S, [linprog_glpk]),
    !,
    nb_setval(solver, S).

get_solver(S) :-
    nb_getval(solver, S).

% :- set_prolog_flag(gc, false).


eqFloat(A, B) :-
    (A < B 
    -> 
        B-A =< 1e-9
    ; 
        A-B =< 1e-9).

makeXbeY(X, Y) :-
    % writeln('Do I really cannot floor such a number...'),
    Yint is floor(Y),
    Ynext is Yint + 1,
    % writeln('Nah... jk, floor of Y is ' : Yint),
    (eqFloat(Y, Yint) -> X is Yint;
    (eqFloat(Y, Ynext) -> X is Ynext;
    X is Y 
    )).


% Store - list of strings
compressListWithStore([], Res) :- % returns an Array of Ints, thats are not in the Store
    % !,
    % writeln('nothing to say'),
    Res = [].

compressListWithStore([H|Tail], Res) :- 
    var(H),
    !,
    
    (get_attr(H, linprog, _) 
    -> 
        compressListWithStore(Tail, Res)
    ;
        compressListWithStore(Tail, ResWas),
        Res = [H|ResWas]
    ).

compressListWithStore([H|Tail], Res) :-
    (number(H)), % in case var was already unified
    !,
    compressListWithStore(Tail, Res).

compressListWithStore([H|Tail], Res) :-
    !,
    writeln('ERROR -> compressListWithStore -> Cannot compress ' : H),
    compressListWithStore(Tail, Res).


/* replacing term_stirng */
:- flag(var_counter, _, 1).
annotate(V, K) :- 
    var(V), integer(K),
    !,
    atomic_list_concat(['_', K], '', Name),
    atom_string(Name, NameStr),
    list_to_ord_set([V], VOrdSet),
    put_attr(VNew, linprog, name_n_AllVars(NameStr, VOrdSet)),
    V = VNew.

/* This predicate added an *init* attribute 
to each var in the list*/ 
addingAttr(X) :-
    !, 
    get_flag(var_counter, K),
    addingAttr2(X, K, Knew),
    set_flag(var_counter, Knew).

addingAttr2([], X, X) :- !.
addingAttr2([H|Tail], C0, C1) :- 
    !,
    addingAttr2(Tail, C0, C1Was),
    (get_attr(H, linprog, _) -> C1 is C1Was ; 
    annotate(H, C1Was),
    C1 is C1Was + 1
    % H = Hattr,
    % writeln('H now' : H),
    ).

/* This predicate takes already prepared constraint 
and check if this constraint can be added (if so, adds it)
 */
checkAddingConstraint(Constraint) :- 
    get_exprs(ExprS),
    Cons = [Constraint|ExprS],
    % writeln('Calling minimize [checkAdding Const]'),
    % writeln('Cons[checkAddingConstraint]'), writeln(Cons),
    b_getval(timeLimit, TimeLimit),
    b_getval(eps, Eps),
    b_getval(solver, Solver),
    call(Solver, Cons, [], '', _, _, Status, Eps, 1, TimeLimit),
    % linprog_glpk(Cons, [], '', _, _, Status, Eps, 1, TimeLimit),
    % writeln('Status[checkAddingConstraint]' : Status),
    (
        Status == 4 
    -> fail
    ;   
        % writeln('Constraint to add ' : Constraint), 
        % snapshot(store_expr(Constraint))
        store_expr(Constraint)
    ).


/* Hook that checks whether unification of two vars is possible 
for LP to be solvable */
linprog:attr_unify_hook(name_n_AllVars(XName, XOrdSet), YRaw) :-
    append_to_file('logs.txt', 'attr_unify_hook BEGIN'), 
    (number(YRaw) -> Y is YRaw + 0.0; Y = YRaw),
    (XName == 'nouni' -> /*write('nouni')*/ true ;
    ((number(Y)) -> store_vars((XName, Y));true),


    (get_attr(Y, linprog, name_n_AllVars(YName, YOrdSet))
    ->   

        string_concat('1*', XName, XName1),
        string_concat('-1*', YName, YName1),
        string_concat(XName1, YName1, Expr),
        string_concat(Expr, '=0', _Constraint),
        % writeln('Checking is good'),
        % write(XOrdSet), write('+'), write(YOrdSet), writeln('='),
        ord_union(XOrdSet, YOrdSet, UnionXY),
        % writeln('Common store of X and Y is ' : UnionXY),
        put_attr(Y, linprog, name_n_AllVars(YName, UnionXY))
        % writeln('Y have attr of Common store'),

        % writeln('All fine, till Im trying to change the main attr'),
        % XOrdSet = UnionAll
    ;   (number(Y)
        ->  
            !,
            % writeln('Get to num[integer]'),
            % to avoid 1e-5 format
            % number_string(Y, YS),
            format(string(YS), '~6f', [Y]),
            string_concat(XName, '=', Xeq),
            string_concat(Xeq, YS, _Constraint)
            % store_expr(Constraint)
            % writeln('Constratin to check' : Constraint),
            % checkAddingConstraint(Constraint)


        ;
            (var(Y)
            ->  
                !,
                put_attr(Y, linprog, name_n_AllVars(XName, XOrdSet))
            ;
                (nonvar(Y) -> !, true;     
                    writeln('ERROR -> [unify_hook] -> Idk how to assign this ....'), writeln(Y)
                )
            )
        )
    )),
    append_to_file('logs.txt', 'Hook ended fine').


/* Takes a list of variables, 
returns a list of strings - their names  
all vars MUST have a linprog attribute, otherwise - fail.
*/
takeInts([], []).
takeInts([H|Tail], Res) :- 
    var(H), 
    !,
    takeInts(Tail, ResWas),
    get_attr(H, linprog, name_n_AllVars(HName, _)),
    Res = [HName|ResWas].

takeInts([_|Tail], Res) :- 
    !,
    takeInts(Tail, Res).


/* Takes a list of vars, 
returns a set of all linked vars.
*/
/* NOTE : Call only with all attributed vars! */
createUnification([], Res) :-
    list_to_ord_set([], Res).
createUnification([H|Tail], Res) :-
    var(H),
    !,
    createUnification(Tail, ResWas),
    /* TODO: savetiness */
    get_attr(H, linprog, name_n_AllVars(_, HOrdSet)),
    ord_union(ResWas, HOrdSet, Res).

createUnification([H|Tail], Res) :-
    (number(H)),
    !, % skipping integer
    createUnification(Tail, Res).

createUnification([H|Tail], Res) :-
    writeln('ERROR -> [putUnification] -> Unknown variables :'),
    writeln(H),
    createUnification(Tail, Res).  


/* Used with createUnification. Takes a list 
of variables, 

*/
putUnification([], _).
putUnification([H|Tail], Set) :- 
    var(H),
    !, 
    get_attr(H, linprog, name_n_AllVars(HName, _)),
    put_attr(H, linprog, name_n_AllVars(HName, Set)),
    putUnification(Tail, Set).

putUnification([H|Tail], Set) :-
    (number(H)),
    !, % skipping integers
    putUnification(Tail, Set).

putUnification([H|Tail], Set) :-
    writeln('ERROR -> [putUnification] -> Unknown variables :'),
    writeln(H),
    putUnification(Tail, Set).

updatingStore(List, OrdSet) :- 
    createUnification(List, OrdSet),
    % writeln('List of vars, that are in Bound' : List),
    % writeln('Unification' : OrdSet),
    putUnification(OrdSet, OrdSet)
    .


% no usage ({A};{B}) to optimize time
:- use_module(library(clpq), [{}/1 as cons]).

{A, B} :-
    !,
	({A}, {B}).

{A; B} :-
    !,
	({A};{B}).

{Bound} :- 
    !, 
    append_to_file('logs.txt', '{} Begin'), 

    term_variables(Bound, Vars), % SWI-specific predicate to get all variables in Bound
    addingAttr(Vars), % Adding attributes to all variables in Vars

    append_to_file('logs.txt', 'Bound: '),
    append_to_file('logs.txt', Bound),
    
    exprConverter(Bound, BoundStr),

    append_to_file('logs.txt', 'Updated Bound: '),
    append_to_file('logs.txt', BoundStr),
    append_to_file('logs.txt', 'BoundStr ended. '), 


    call(cons(Bound)), % Calling CLP(Q) to check satisfiability of the constraint

    (BoundStr == '' -> append_to_file('logs.txt', 'GOODNIGHT'), true; 

    store_expr(BoundStr),
    !),
    append_to_file('logs.txt', '{} Ended').
    % clean_store.



exprConverter((Bound1, Bound2), Res) :- 
    !,
    exprConverter(Bound1, ResA), 
    exprConverter(Bound2, ResB),
    (ResA == '' -> Res = ResB;
    (ResB == '' -> Res = ResA;
    atomic_list_concat([ResA, ',', ResB], ResRaw),
    atom_string(ResRaw, Res))).


exprConverter((Bound1; Bound2), Res) :- 
    !,
    exprConverter(Bound1, ResA), 
    exprConverter(Bound2, ResB),
    (ResA == '' -> Res = ResB;
    (ResB == '' -> Res = ResA;
    atomic_list_concat([ResA, ';', ResB], ResRaw),
    atom_string(ResRaw, Res))).

exprConverter(Bound, Res) :- 
    !,
    % write('String got : '), writeln(Bound), 
    normalize(Bound, Res).
    % writeln('String norm ' : Res).
    % print_term_type(Res).


% ------------------------------------------- Normalization ------------------------------------------


normalize(ExprL =< ExprR, BoundNormalized) :- % dupl for more signs 
    !,
    parser(ExprL - ExprR, ExprN, NumBoundRHS),
    (ExprN == '' -> (0 =< NumBoundRHS -> BoundNormalized = ''; fail);
    % to avoid 1e-5.
    format(string(NumBoundRHSStr), '~6f', [NumBoundRHS]),
    % number_string(NumBoundRHS, NumBoundRHSStr),
    atomic_list_concat([ExprN, '=<', NumBoundRHSStr], BoundNormalizedRaw),
    atom_string(BoundNormalizedRaw, BoundNormalized)).

normalize(ExprL >= ExprR, BoundNormalized) :- % dupl for more signs 
    !,
    parser(ExprL - ExprR, ExprN, NumBoundRHS),
    (ExprN == '' -> (0 >= NumBoundRHS -> BoundNormalized = ''; fail)
    ;
     % to avoid 1e-5.
    format(string(NumBoundRHSStr), '~6f', [NumBoundRHS]),
    atomic_list_concat([ExprN, '>=', NumBoundRHSStr], BoundNormalizedRaw),
    atom_string(BoundNormalizedRaw, BoundNormalized)).

normalize(ExprL =:= ExprR, BoundNormalized) :-
    !,
    normalize(ExprL = ExprR, BoundNormalized).  

normalize(ExprL =\= ExprR, BoundNormalized) :-
    % very bad, but it is what it is (clpq doing the same)
    !,
    b_setval(unstrong, true),
    normalize(ExprL < ExprR, BoundNormalized)
    ;
    normalize(ExprL > ExprR, BoundNormalized). 
    

normalize(ExprL = ExprR, BoundNormalized) :- % dupl for more signs 
    !,
    parser(ExprL - ExprR, ExprN, NumBoundRHS),
    % writeln('Parser ended'),
    % writeln(ExprN),
    % writeln(NumBoundRHS),
    % nl,
    (ExprN == '' -> (0 =:= NumBoundRHS -> BoundNormalized = ''; fail)
    ;
     % to avoid 1e-5.
    format(string(NumBoundRHSStr), '~6f', [NumBoundRHS]),
    % number_string(NumBoundRHS, NumBoundRHSStr),
    atomic_list_concat([ExprN, '=', NumBoundRHSStr], BoundNormalizedRaw),
    atom_string(BoundNormalizedRaw, BoundNormalized)).



normalize(ExprL < ExprR, BoundNormalized) :- 
    !,
    b_setval(unstrong, true), 
    parser(ExprL - ExprR, ExprN, NumBoundRHS),
    (ExprN == '' -> (0 =:= NumBoundRHS -> BoundNormalized = ''; fail)
    ;
     % to avoid 1e-5.
    format(string(NumBoundRHSStr), '~6f', [NumBoundRHS]),
    % number_string(NumBoundRHS, NumBoundRHSStr),
    atomic_list_concat([ExprN, '<', NumBoundRHSStr], BoundNormalizedRaw),
    atom_string(BoundNormalizedRaw, BoundNormalized)).


normalize(ExprL > ExprR, BoundNormalized) :- 
    !,
    b_setval(unstrong, true),
    parser(ExprL - ExprR, ExprN, NumBoundRHS),
    (ExprN == '' -> (0 =:= NumBoundRHS -> BoundNormalized = ''; fail)
    ;
    % to avoid 1e-5.
    format(string(NumBoundRHSStr), '~6f', [NumBoundRHS]),
    % number_string(NumBoundRHS, NumBoundRHSStr),
    atomic_list_concat([ExprN, '>', NumBoundRHSStr], BoundNormalizedRaw),
    atom_string(BoundNormalizedRaw, BoundNormalized)).

normalize(Exp, _) :-
    writeln('PLEASE use only <,>,=:=,=\\=,=<,=,>='),
    writeln(Exp),
    fail.


parser(Expr, ExprN, NumB_RHS) :- 
    % write('Expression recived'), write_canonical(Expr), nl,
    open(Expr, ExprOpened),
    % write('Expression opend '), write_canonical(ExprOpened), nl,
    compress(ExprOpened, ExprList, NumBoundLHS),
    % writeln('Expression compressed'), writeln(ExprList),
    % writeln('And bound[lhs] is '), writeln(NumBoundLHS),
    decompressStr(ExprList, ExprN, _),
    % writeln('Result is '), writeln(ExprN),
    % writeln(NumBoundLHS),
    NumB_RHS is (-1) * NumBoundLHS + 0.0,
    !.

    
minus(A, Res) :- 
    number(A),
    !,
    % writeln('number(A)'),
    % write(A), nl,
    Res is (-1)*A. 

minus(A, Res) :- 
    var(A), 
    !,
    % writeln('var(A)'),
    Res = -A.

minus(-A, Res) :- 
    var(A),
    !,
    Res = A.

minus(A*B, Res) :-
	(var(A);number(A)), (var(B);number(B)),
    !,
    % writeln('A*B'),
    (number(A) -> Anew is (-1)*A, Bnew = B; Anew = (-1)*B, Bnew = A),
    Res = Anew*Bnew.

minus(A+B, Res) :-
    !,
    % writeln('A+B'),
    % write(A), write(', '), write(B), nl,
    minus(A, An), minus(B, Bn),
    Res = An + Bn.

minus(A-B, Res) :- 
    !,
    % writeln('A-B'),
    minus(A, An), minus(B, Bn), 
    Res = An - Bn.

open(A, Res) :- 
    number(A),
    !,
    Res = A. 

open(A, Res) :- 
    var(A),
    !, 
    Res = A. 

open(A+B, Res) :- 
    (number(A)),(number(B)),
    !,
    Res is A+B. % do not garantee that there is only 1 bounder number. 


open(A+B, Res) :- 
    !,
    open(A, Anew), 
    open(B, Bnew),
    (
        (number(Anew)), (number(Bnew)) 
        -> 
            Res is Anew+Bnew
        ; 
            Res = Anew+Bnew
    ).

open(A-B, Res) :- 
    !,
    open(A, Anew), 
    open(B, Bnew),
    minus(Bnew, Bup), 
    Res = Anew+Bup. 

open(A*B, Res) :- % FOLLOW THE ORDER 
    var(A), number(B),
    !,
    Res = B*A.

open(-A, Res) :-
    var(A),
    !,
    Res = (-1)*A.

open(A*B, Res) :- 
    !,
    open(A, Anew), 
    open(B, Bnew),
    /* TODO: upd types */ 
    ((number(Anew), number(Bnew)) -> Res is Anew*Bnew;
    (number(Anew), \+ compound(Bnew) -> Res = Anew*Bnew; 
    (number(Bnew), \+ compound(Anew) -> Res = Bnew*Anew;
    (number(Anew), Bnew =.. [+, Left, Right] 
    -> open(Anew*Left, AL), open(Anew*Right, AR), Res = AL + AR;
    (number(Bnew), Anew =.. [+, Left, Right]
    -> open(Bnew*Left, BL), open(Bnew*Right, BR), Res = BL + BR;
    (number(Anew), Bnew =.. [-, Left, Right] 
    -> open(Anew*Left, AL), open(Anew*Right, AR), Res = AL - AR;
    (number(Bnew), Anew =.. [-, Left, Right]
    -> open(Bnew*Left, BL), open(Bnew*Right, BR), Res = BL - BR;
    (number(Anew), Bnew =.. [*, Left, Right], number(Left)
    -> K is Anew * Left, Res = K * Right;
    (number(Bnew), Bnew =.. [*, Left, Right], number(Right)
    -> K is Bnew * Left, Res = K * Right;
    writeln('UNKOWN PREDICATE (or incorrect order in multiplication)')
    
    ))))))))).


% -----------------------------------Compress------------------------------------------------------------

compress_sorted_list_of_pairs([], [[VarStr, Coef]], Var, Coef) :-
    get_attr(Var, linprog, name_n_AllVars(VarStr, _ ) ).

compress_sorted_list_of_pairs([H|T], Res, Var, Coef) :-
    H = VarChecking-CoefChecking,
    (VarChecking == Var
    -> 
        CoefNext is CoefChecking + Coef,
        compress_sorted_list_of_pairs(T, Res, Var, CoefNext)
    ;
        compress_sorted_list_of_pairs(T, ResTail, VarChecking, CoefChecking),
    get_attr(Var, linprog, name_n_AllVars(VarStr, _) ),
        Res = [[VarStr, Coef]|ResTail]
    ).

compress_sorted_list_of_pairs([], []).
compress_sorted_list_of_pairs([H|T], Res) :-
    H = Var-Coef,
    compress_sorted_list_of_pairs(T, Res, Var, Coef).
    

/**
DOC: IsLMneg - is left-most number negative
if so, IsLMneg = -1
else   IsLMneg =  1

*/

compress(Ex, Res, Num) :- 
    compress(Ex, ResUnCompressed, Num, 1),

    keysort(ResUnCompressed, ResSorted),

    compress_sorted_list_of_pairs(ResSorted, Res),
    !.
    % writeln('The process finished').


compress(Int, Res, Num, IsLMneg) :- 
    (integer(Int) ; float(Int)),
    !, % no clpq interact 
    Res = [], 
    Num is Int * IsLMneg.

compress(Int, Res, Num, IsLMneg) :- 
    number(Int), 
    !, % due to clpq interact 
    IntNOCLPQ is float(Int),
    Res = [], 
    Num is IntNOCLPQ * IsLMneg.


compress(Symb, Res, Num, IsLMneg) :- 
    var(Symb), 
    !,
    % writeln('Find a var' : Symb),
    % add(Symb, IsLMneg, [], Res),
    Res = [Symb-IsLMneg],
    % writeln('Added a var' : Res), 
    Num is 0.

compress(-(Symb), Res, Num, IsLMneg) :-
	% writeln(Symb), writeln(IsLMneg),
    var(Symb), integer(IsLMneg),
    !,
    Coef is (-1)*IsLMneg,
    Res = [Symb-Coef],
    % add(Symb, Coef, [], Res),
    Num is 0.
    
/*
compress(-(-(Symb)), Res, Num, IsLMneg) :-
    !,
    % writeln('Something was in -- ' : Symb),
    compress(Symb, Res, Num, IsLMneg).
*/


compress(A*B, Res, Num, IsLMneg) :- 
    number(A), var(B), 
    !,
    % writeln('Find A*B, where var is B'), writeln(B),
    Cmp is IsLMneg * A, 
    % add(B, Cmp, [], Res),
    Res = [B-Cmp],
    Num is 0.

compress(A*B, Res, Num, IsLMneg) :- 
    var(A), number(B), 
    !,
    % writeln('Find A*B, where var is A'), writeln(A),
    Cmp is IsLMneg * B,
    % add(A, IsLMneg*B, [], Res),
    Res = [A-Cmp],
    Num is 0.

compress(A+B, Res, Num, IsLMneg) :- 
    !,
    % writeln('Find A Sum'),
    compress(A, ResA, NumA, IsLMneg), 
    compress(B, ResB, NumB, 1), 
    % un(ResA, ResB, Res),
    append([ResA, ResB], Res),
    Num is NumA + NumB.

compress(A-B, Res, Num, IsLMneg) :- 
    !,
    % writeln('Find a subtracktion'), 
    compress(A, ResA, NumA, IsLMneg),
    compress(B, ResB, NumB, -1), 
    append(ResA, ResB, Res),
    Num is NumA + NumB.

% -----------------------------------DEcompress------------------------------------------------------------



decompressStr([], '', '').

decompressStr([H|Tail], Res, SignRet) :- 
    decompressStr(Tail, ResTail, Sign),
    nth0(1, H, Num),
    nth0(0, H, Str),
    (Num == 0 
    -> 
        Res = ResTail, SignRet = Sign
    ;
        (Num >= 0 -> SignRet = '+'; SignRet = ''), 

        % to avoid 1e-5 format
        % number_string(Num, NumStr),
        format(string(NumStr), '~6f', [Num]),
        atom_string(Sign, SignStr),
        atom_string(ResTail, ResTailStr),

        atomic_list_concat([NumStr, '*', Str, SignStr, ResTailStr], ResRaw),
        atom_string(ResRaw, Res)

    ).

% -----------------------------------BB_INF------------------------------------------------------------



prepareIntsToBB_INF(IntsOrig, Res) :-

    /* Checking that in the Store there are no duplicates */
    compressListWithStore(IntsOrig, IntsForAdding), 
    /* Adding attributes to new variables */
    addingAttr(IntsForAdding),

    takeInts(IntsOrig, Res),
    !.



prepareObjToBB_INF(ObjOrig, Res, ResNum) :- 
% write('prepareObjToBB_INF was called '), nl,
    parser(ObjOrig, Res, Num),
    ResNum is (-1) * Num,
    !.

base_check([]).
base_check([H|T]) :-
    (var(H);number(H)), base_check(T), !.


% ************* Used by {log} *********************

bb_inf(A, B, C) :- bb_inf(A, B, C, _).
bb_inf(A, B, C, D) :- 
    b_getval(eps, Eps),
    bb_inf(A, B, C, D, Eps).

bb_inf(IntsOrig, ObjOrig, Inf, Vertex, Eps) :- 
    bb_inf_b(IntsOrig, ObjOrig, Inf, Vertex, Eps, St),
    (St == 6 -> fail, !; true).


append_to_file(FileName, Content) :-
    (dbg -> 
    open(FileName, append, Stream),
    write(Stream, Content),
    nl(Stream),
    close(Stream)
    ; true).


/* bb_inf_b - same as bb_inf, but it also returns status and failing means  
nofeasible solution exists (St = 4). Unboundness - St = 6, Feasible - St = 5 */
bb_inf_b(A, B, C, St) :- bb_inf_b(A, B, C, _, St).
bb_inf_b(A, B, C, D, St) :- 
    b_getval(eps, Eps),
    bb_inf_b(A, B, C, D, Eps, St).

bb_inf_b(IntsOrig, ObjOrig, Inf, Vertex, Eps, St) :- 
    !,append_to_file('logs.txt', 'BB_INF started'),  
    % write('IntsOrig '), writeln(IntsOrig), write('ObjOrig'), writeln(ObjOrig),
    % write('Inf '), writeln(Inf), write('Vertex '), writeln(Vertex), nl, nl,
    base_check(IntsOrig),
    get_exprs(Cons),
    prepareIntsToBB_INF(IntsOrig, Ints),
    prepareObjToBB_INF(ObjOrig, Obj, Const),
    % writeln('BB_INF WAS CALLED'),
    % writeln('[glpk]With:'),
    % writeln('Cons' : Cons), writeln('Ints' : Ints), writeln('Obj' : Obj), 
    append_to_file('logs.txt', 'BB_INF WAS CALLED With:\nCons:'),
    append_to_file('logs.txt', Cons),
    append_to_file('logs.txt', 'Ints:'),
    append_to_file('logs.txt', Ints),
    append_to_file('logs.txt', 'Obj:'),
    append_to_file('logs.txt', Obj),
    append_to_file('logs.txt', '\n'),
    b_getval(timeLimit, TimeLimit),
    b_getval(solver, Solver),

    % sorting constraints by length
    sort_by_length(Cons, ConsSBL),



    call(Solver, ConsSBL, Ints, Obj, InfWithoutConst, Vertex, St, Eps, 1, TimeLimit),
    % linprog_glpk(Cons, Ints, Obj, InfWithoutConst, Vertex, St, Eps, 1, TimeLimit),
    % write('BB_INF_FINISHED_WITH_STATUS_'), 
    % write(St),
    % nl,
    ((St == 4) -> fail, !;true),
    (St == 1 
        -> writeln('GLPK behaves bad, try more times :D'),
            throw(error(time_limit, context(bb_inf/4, 
                'Wrong glpk status')))
        ; true),
    InfFloat is InfWithoutConst + Const,
    % writeln('BB_INF InfFloat' : InfFloat),
    makeXbeY(Inf, InfFloat)
    % , writeln('BB_INF Inf' : Inf)
    % , writeln('Vertex ' : Vertex)
    ,!, append_to_file('logs.txt', 'BB_INF ended')
    .


sort_by_length(Strs, StrsNew) :- 
    findall(Len-S, (member(S, Strs), string_length(S, Len)), Pairs),

    msort(Pairs, PairsACS),
    reverse(PairsACS, PairsDESC),

    findall(S2, (member((_-S2), PairsDESC)), StrsNew).

% **********************************************
% Local constraint store

% Define a dynamic predicate to hold the list of expressions
:- dynamic 
	stored_expression/1,
    stored_variables/1,
    stored_constraints/1.

:- initialization(init_store).

init_store :-
    nb_setval(store, []),
    nb_setval(store_advensed, []),
    nb_setval(store_vars, []).



get_exprs(ExprList) :-
    b_getval(store, ExprList)
    .

store_expr(Expr) :- 
    % writeln(Expr),
    b_getval(store, StoreWas),
    % term_string(Expr, ExprS),
    b_setval(store, [Expr|StoreWas])
    .


get_vars(Vars) :-
    b_getval(store_vars, Vars).

store_vars(Var) :-
    b_getval(store_vars, Store),
    b_setval(store_vars, [Var|Store]).
    
get_cons(Cons) :-
    b_getval(store_advensed, Cons).
