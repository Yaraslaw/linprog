/*
TODO: when creating the interface other predicates are not available any more.
*/

:- module(linprog,
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




% :- multifile user:message_hook/3.

user:message_hook(query(no), query, _C) :- !, fail.
user:message_hook(query(yes(A, B, [_C]-[])), query, _X) :- !,
    % writeln('message[xd]'), writeln(A), writeln(B), writeln(C).
    print_message(query, query(yes(A, B, []-[]))).

% user:message_hook(_A, _B, _C) :- true.

/* No output for linprog attributes */
:- set_prolog_flag(write_attributes, ignore).


% WE NEED MORE MEMORY!
% :- set_prolog_flag(stack_limit, 32_000_000_000). % 8MB stack limit, default is 4MB


user:attribute_goals(Var) --> 
    {get_attr(Var, linprog, _)}, [].




% Next, a clause that says "if the attribute is NOT from linprog, do nothing to it."
% But do NOT fail, or you break other modules' attributes!
% user:attribute_goals(_Var, _Value, []) :-
%     true.


:- load_foreign_library(linprog_glpk_file).
% :- use_module(library(clpfd)).
:- use_module(library(ordsets)).
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

/* Hotfix! TODO: create a list that stores used variables */
% :- set_prolog_flag(gc, false).


% TODO: add license	  
%:- license(gpl_swipl, 'CLP(Q)').

%:- use_module(library(dialect)).
%:- expects_dialect(swi).


/*

FOR V1 THESE PREDICATES ARE PARSED FROM CLPQ 

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

linking([], []).
linking([H|Tail], [Hn|Tn]) :-
    (number(H), number(Hn) -> true
    ;
        put_attr(H, linprog, name_n_AllVars('nouni', _)), 
        makeXbeY(H, Hn)),
    linking(Tail, Tn).


:- nb_setval(unstrong, false).
minimize(E) :- 
    b_getval(unstrong, UnStrong),
    (UnStrong -> (!, fail) ; true),
    findEmALL(E, IntsOrig),
    prepareIntsToBB_INF(IntsOrig, Ints),
    prepareObjToBB_INF(E, Obj, _),
    get_exprs(Cons),
    b_getval(timeLimit, TimeLimit),
    b_getval(eps, Eps),
    b_getval(solver, Solver),
    % writeln('here'), 
    call(Solver, Cons, Ints, Obj, _, V, St, Eps, 0, TimeLimit),
    % call for chechking for 4.9999 porblem (todo list)
    % writeln('here2'),
    % call(Solver, Cons, Ints, Obj, _, Vint, _, Eps, 1, TimeLimit),
    % writeln(V), writeln(Vint), 
    % (V == Vint -> true; fail, !),
    % linprog_glpk(Cons, Ints, Obj, _, V, St, Eps, 0, TimeLimit),
    % adding comparation with minimize_glpk for ints 
    (St == 4; St == 6 -> fail, !; true),
    linking(IntsOrig, V).


maximize(E) :- minimize((-1)*E).


entailed(E) :- 
    negate(E, En),
    \+ {En}.


findR([], [], _, _).
findR([H|Tail], R, Ints, NewInts) :-
    findR(Tail, OldR, Ints, NewInts),
    (replaceEmAll(H, SingleR, Ints, NewInts) 
    -> 
        R = [SingleR|OldR]
    ;
        R = OldR).



dump(Ints, NewInts, R) :-
    get_cons(Cons),
    findR(Cons, R, Ints, NewInts).

inf(E, I) :- bb_inf([], E, I).

sup(E, I) :- 
    bb_inf([], (-1)*E, PreI), 
    I is (-1)*PreI.
*/


% ************* Used by {log} *********************
% {Constraint}
%
% Adds the constraint Constraint to our own constraint store.
% Adapted from original implementation. 
%


add_LB(XNew, Mn, ResWas, Res) :-
    (number(Mn) -> 
        Bound is Mn,
        Res = [XNew >= Bound|ResWas]
    ;Res = ResWas).

add_UB(XNew, Mx, ResWas, Res) :-
    (number(Mx) -> 
        Bound is Mx,
        Res = [XNew =< Bound|ResWas]
    ;Res = ResWas).



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
    (number(X)),
	!,
    Res = [].

findEmALL(X, Res) :- 
    var(X), \+ compound(X), 
    !,
    Res = [X].


findEmALL(C, Res) :- 
    C =.. [_, A, B],
	!,
    findEmALL(A, ResA), findEmALL(B, ResB), 
    unAtoB(ResA, ResB, Res).

findEmALL(-C, Res) :- 
    !, 
    findEmALL(C, Res).

isInList(_, [], [], _) :- fail.
isInList(S, [H|Tail], [_|TNew], R) :-
    number(H),
    !,
    isInList(S, Tail, TNew, R).

isInList(S, [H|Tail], [HNew|TNew], R) :-
    var(H), 
    !,
    get_attr(H, linprog, name_n_AllVars(Name, _)),
    (S == Name -> R = HNew, !; isInList(S, Tail, TNew, R)).


isUnified(_, _, []) :- fail. 
isUnified(A, Res, [(Name, Val)|T]) :- 
    % nl, write('b'), write(A), writeln('b'), writeln(Name), writeln(Val), nl, 
    (A == Name -> Res = Val; isUnified(A, Res, T)).


/* A - string */
alreadyKnown(A, Res) :- 
    get_vars(Vars), 
    isUnified(A, Res, Vars).


replaceEmAll(A, Res, _, _, 0) :-
    (number(A)),
    !,
    Res is A.

replaceEmAll(A, Res, ListVars, ListNewVars, NumOfReplaced) :- 
    string(A),
    !,
    
    (isInList(A, ListVars, ListNewVars, ANew),
    NumOfReplaced is 1
    ;
    alreadyKnown(A, ANew),
    NumOfReplaced is 0),
    
    Res = ANew.

replaceEmAll(A, Res, ListVars, ListNewVars, NumOfReplaced) :-
    A =.. [Op, L, R],
    replaceEmAll(L, ResL, ListVars, ListNewVars, NumOfReplacedL),
    replaceEmAll(R, ResR, ListVars, ListNewVars, NumOfReplacedR),
    NumOfReplaced is NumOfReplacedL + NumOfReplacedR,
    Res =.. [Op, ResL, ResR].


replaceEmAll(A, Res, ListVars, ListNewVars) :-
    replaceEmAll(A, Res, ListVars, ListNewVars, NOR),
    (NOR == 0 -> fail; true).


number_to_string(Number, String) :-
    number_codes(Number, Codes),
    atom_codes(String, Codes).


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


find_bounds_for_var(X, Mn, Mx) :- 
    var(X),
    !,
    get_exprs(Cons),
    % writeln('Note, Cons are' : Cons),
    get_attr(X, linprog, name_n_AllVars(XStored, _)),
    term_string(XStored, XStoredStr),
    % writeln('Calling minimize with Cons ' : Cons), 
    % writeln('And obj' : XStoredStr),
    % writeln('Simplex method'),
    b_getval(timeLimit, TimeLimit),
    b_getval(eps, Eps),
    b_getval(solver, Solver),
    call(Solver, Cons, [], XStoredStr, Mn, _, St1, Eps, 0, TimeLimit),
    % linprog_glpk(Cons, [], XStoredStr, Mn, _, St1, Eps, 0, TimeLimit),
    
    (St1 == 4 -> writeln('assignment for min FAILS')
    ;true),
    
    
    string_concat('-1*', XStored, XStoredMinus),
    term_string(XStoredMinus, XStoredMinusStr),
    % writeln('Calling minimize with Cons ' : Cons), 
    % writeln('And obj' : XStoredMinusStr),
    % writeln('Simplex method'),
    b_getval(timeLimit, TimeLimit),
    b_getval(eps, Eps),
    b_getval(solver, Solver),
    call(Solver, Cons, [], XStoredMinusStr, MxRaw, _, St2, Eps, 0, TimeLimit),
    % linprog_glpk(Cons, [], XStoredMinusStr, MxRaw, _, St2, Eps, 0, TimeLimit),
    (St2 == 4 
    -> 
        writeln('assignment for max FAILS') 
    ;true),

    Mx is -MxRaw. % due to coef -1


assignment([]) :- !.

assignment([X|Vars]) :- 
    var(X),
    !,
    % writeln(X), writeln(Mn), writeln(MX), 
    write('\t\t[assignment] Was : '), write(X), writeln('->'), 
    

    find_bounds_for_var(X, Mn, Mx),
    

    % writeln('Vertex mx' : Vx),
    % writeln('For constraints Cons ' : Cons), 
    % writeln('X' : X),
    % writeln(', also known as ' : XStored),
    % write(XStored), write(' in : ['), write(Mn), write(', '), write(Mx), writeln(']'),
    (eqFloat(Mn, Mx) 
    -> 
        get_attr(X, linprog, name_n_AllVars(XName, _)),
        makeXbeY(Val, Mn), 
        store_vars((XName, Val)),
        put_attr(X, linprog, name_n_AllVars('nouni', _)),
        X is Val
    ;true),
    % writeln('Well, for real, X is ' : X),
    % X in Mn..Mx, Z
    % write('Now X  is '), writeln(X), 
    % writeln('\t\tNext station is '),
    % writeln(Vars),
    assignment(Vars).

assignment([X|Vars]) :-
    (number(X)),
    !, %skipping integers. 
    assignment(Vars).

assignment(A) :-
    % !, % other unknown cases (parhapse after X is)
    writeln('ERROR -> assignment -> WOW [bug]'), writeln(A), fflush(stdout).




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


/* ! - are nessesary due to unknown catcher */
prepareToStore([], Res) :-
    !,
    Res = ''.
prepareToStore([H|Tail], Res) :- 
    var(H),
    !,
    % writeln('Was here'),
    prepareToStore(Tail, ResWas),
    get_attr(H, linprog, HS),
    string_concat(HS, ',', HSC),
    string_concat(HSC, ResWas, Res).

prepareToStore(A, B) :-
    writeln('ERROR -> Unknown [prepareToStore] '),
    writeln(A),
    writeln(B).



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





/* This predicate added an *init* attribuite 
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
    % writeln('H was ' : H),
    % term_to_string(H, HStr), 
    % list_to_ord_set([H], HOrdSet),
    % Attr = name_n_AllVars(HStr, HOrdSet),
    % % writeln('Attr to put' : HOrdSet), 
    % put_attr(Hattr, linprog, Attr), 
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
    % writeln('Assignment for some ATTR var was called:'),
    % write('Var Attribute [name]:'), write(XName), write(' , [ordset]:'), writeln(XOrdSet),
    % writeln('Assign to '), writeln(Y),
    % (var(Y) -> writeln('Y is a var') ; wrieln('Y is not a var')),

    (get_attr(Y, linprog, name_n_AllVars(YName, YOrdSet))
    ->   
	% writeln('It is eq to Y with attrs:'),
        % write('Var Attribute [Yname]' : YName), writeln(' , [Yordset]' : YOrdSet),
        string_concat('1*', XName, XName1),
        string_concat('-1*', YName, YName1),
        string_concat(XName1, YName1, Expr),
        string_concat(Expr, '=0', _Constraint),
        % store_expr(Constraint),
        % checkAddingConstraint(Constraint),
        % writeln('Checking is good'),
        % write(XOrdSet), write('+'), write(YOrdSet), writeln('='),
        ord_union(XOrdSet, YOrdSet, UnionXY),
        % writeln('Common store of X and Y is ' : UnionXY),
        put_attr(Y, linprog, name_n_AllVars(YName, UnionXY))
        % writeln('Y have attr of Common store'),
        % updatingStore([Y], UnionAll)
        % assignment(UnionAll) % going for all variables that can be changed

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
            % assignment(XOrdSet) % going for all variables that can be changed


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


/*
not certain how this works, thus commented 
attribute_goals(Var) -->
    { get_attr(Var, linprog, Attr) },
    [ put_attr(Y, linprog, Attr), X=Y].
*/


/* Takes a list of variables, 
returns a list of strings - thier names  
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
:- use_module(library(clpq), [{}/1 as cons, inf/2, sup/2, minimize/1, maximize/1, entailed/1, dump/3]).

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



    % NT is 2 + 3,
    % write('[{}] Bound : '),
    % writeln(Bound),

    /* Finding All Variables in constraints (returns list) */
    % findEmALL(Bound, IntsForAddingFind),
    % writeln('IntsForAddingFind'),writeln(IntsForAddingFind),
    % append_to_file('logs.txt', 'findEmALL done'),
    /* Checking if variable does not have an attribute */
    % compressListWithStore(IntsForAddingFind, IntsForAdding), 
    % append_to_file('logs.txt', 'compressListWithStore done'), 
    % writeln('Compressed with store done'),
    /* Adding attributes to new variables */
    % length(IntsForAdding, Len),
    % writeln('Number of new variables to add ' : Len),
    % addingAttr(IntsForAdding),
    % append_to_file('logs.txt', 'addingAttr done'), 
    % writeln('IntsForAdding after adding Attr'), writeln(IntsForAdding),

    /* Creating String version to add it to the Store */
    % prepareToStore(IntsForAdding, IntsNewStr),
    % Ints = [IntsNewStr|IntsWas],
    % writeln('Ints'), writeln(Ints),
    

    /* Vars are good, now constraints */
    % writeln('Till here all fine'),
     /* Normilizing all the constraints */
    append_to_file('logs.txt', 'Bound: '),
    append_to_file('logs.txt', Bound),
    
    exprConverter(Bound, BoundStr),

    append_to_file('logs.txt', 'Updated Bound: '),
    append_to_file('logs.txt', BoundStr),
    append_to_file('logs.txt', 'BoundStr ended. '), 
    % writeln('BoundStr is '),
    % writeln(BoundStr),

    call(cons(Bound)), % Calling CLPQ to check satisfiability of the constraint

    (BoundStr == '' -> append_to_file('logs.txt', 'GOODNIGHT'), true; 
    % writeln('After resturcture ' : BoundStr),
    /* Get already stored constraints */
    
    % get_exprs(ExprS),
    % writeln('Stored expr' : ExprS),

    /* Creating a new array to hand over to GLPK */
    % Cons = [BoundStr|ExprS],

    % writeln('Cons'), writeln(Cons),
    % writeln('Ints' : []),
    % writeln('Find_bounds was called'),

    /* Calling GLPK */
    % find_bounds(Cons, IntsNew, Ver, Status),
    % writeln('Minimize as find sol was called'),
    % writeln('Duple Ints for one more time...'),
    % writeln(Ints),
    % b_getval(timeLimit, TimeLimit),
    % b_getval(eps, Eps),
    % b_getval(solver, Solver),
    append_to_file('logs.txt', 'All before Simplex Call done'),
    % writeln('Calling with Cons: '), writeln(Cons), 

    % ignore(call(Solver, Cons, [], '', _, _, Status, Eps, 0, TimeLimit)),

    % linprog_glpk(Cons, [], '', _, _, Status, Eps, 0, TimeLimit),
    append_to_file('logs.txt', 'Simplex call done'),
    % writeln('Vertex ': Vertex),
    % writeln('Status'), writeln(Status),
    /* Checking for status */
    % (Status == 4
    %     -> append_to_file('logs.txt', 'Status 4!'), fail
    %     ;
    %     (
                
    %             % writeln('Prepared to store' : IntsNewStr),
    %         append_to_file('logs.txt', 'Status is not 4'), 
    %             /* If constraints are good, store new constraints, new variables */
    %             % snapshot(store_expr(BoundStr)), 
                % writeln(BoundStr),
                store_expr(BoundStr),
    %             append_to_file('logs.txt', 'Store_exp done'), 
    %             create_con_advensed(Bound, BoundAdvensed),
    %         append_to_file('logs.txt', 'create_con_advensed done'),
    %             store_cons(BoundAdvensed),
    %         append_to_file('logs.txt', 'store_cons done'), 
    %             % store_vars(IntsNewStr),
    %             % writeln('Vars in constraint are' : IntsForAddingFind),

            
    %     )
	    
	    % updatingStore(IntsForAddingFind, AllUsedVars),
	    % append_to_file('logs.txt', 'updatingStore done'), 
            
	    /* And assign each variable its range */

	    % assignment(AllUsedVars)
    % ),
    % writeln('Everything is fine, lets finish the work'),
    !),
    append_to_file('logs.txt', '{} Ended').
    % clean_store.



exprConverter((Bound1, Bound2), Res) :- 
    !,
    % writeln('Was here...'),
    % writeln('[raw]' : Bound1), 
    % writeln('[raw]' : Bound2),
    exprConverter(Bound1, ResA), 
    exprConverter(Bound2, ResB),
    (ResA == '' -> Res = ResB;
    (ResB == '' -> Res = ResA;
    atomic_list_concat([ResA, ',', ResB], ResRaw),
    atom_string(ResRaw, Res))).
    % writeln('Un ' : Res).


exprConverter((Bound1; Bound2), Res) :- 
    !,
    % writeln('Why am I using ;???'),
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

% ---------------- DELETE ----------
print_term_type(Term) :-
    (   var(Term)
    ->  write('Term is a variable.')
    ;   string(Term)
    ->  write('Term is a string.')
    ;   atom(Term)
    ->  write('Term is an atom.')
    ;   number(Term)
    ->  write('Term is a number.')
    ;   is_list(Term)
    ->  write('Term is a list.')
    ;   compound(Term)
    ->  write('Term is a compound term.')
    ;   write('Unknown type.')
    ),
    nl. 
% ------------------------- ------------------



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
     % number_string(NumBoundRHS, NumBoundRHSStr),
    % writeln('Type of NumBoundRHS' : NumBoundRHS),
    % print_term_type(NumBoundRHS),
    % writeln('Type of ExprN' : ExprN), 
    % print_term_type(ExprN),
    atomic_list_concat([ExprN, '>=', NumBoundRHSStr], BoundNormalizedRaw),
    atom_string(BoundNormalizedRaw, BoundNormalized)).

normalize(ExprL =:= ExprR, BoundNormalized) :-
    !,
    normalize(ExprL = ExprR, BoundNormalized).  

normalize(ExprL =\= ExprR, BoundNormalized) :-
    % very bad, but it is what it is 
    !,
    b_setval(unstrong, true),
    normalize(ExprL < ExprR, BoundNormalized)
    ;
    normalize(ExprL > ExprR, BoundNormalized). 
    

normalize(ExprL = ExprR, BoundNormalized) :- % dupl for more signs 
    !,
    % writeln('Parser starts'),
    % writeln(ExprL = ExprR),
    % (var(ExprL), var(ExprR) 
    % -> writeln('Is it really usfull?'), ExprL = ExprR
    % ;true),
    % writeln('Does it kepp going?'),
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


create_con_advensed(Con, Res) :-
    Con =.. [Sign, LHS, RHS],
    open(LHS-RHS, ExprOpened),
    compress(ExprOpened, ExprList, NumBoundLHS),
    decompressAdv(ExprList, ExprN), 
    NumB_RHS is (-1)*NumBoundLHS + 0.0,
    Res =.. [Sign, ExprN, NumB_RHS].

    
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
    % writeln('tHE REAL PROCCESS BEGIN'),
    % writeln('Its alive' : 2+3),
    
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
    % writeln('Get results :'),
    % writeln(ResA), writeln(ResB),
    % un(ResA, ResB, Res), 
    append(ResA, ResB, Res),
    % writeln('Unification is '),
    % writeln(Res),
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

        % writeln('OMG:'),
        % print_term_type(NumStr),
        % print_term_type(Str),
        % print_term_type(SignStr),
        % print_term_type(ResTailStr),

        atomic_list_concat([NumStr, '*', Str, SignStr, ResTailStr], ResRaw),
        atom_string(ResRaw, Res)

        % print_term_type(Res),
        % writeln('Res' : Res).
    ).




decompressAdv([], '').

decompressAdv([H|Tail], Res) :- 
    decompressAdv(Tail, ResTail),
    nth0(1, H, Num),
    nth0(0, H, Str),
    (Num == 0 
    -> 
        Res = ResTail
    ;
        (ResTail == '' 
        -> 
            Res =.. [*, Num, Str]
        ;
            (Num > 0 
            -> 
                Pair =.. [*, Num, Str],
                Res =.. [+, ResTail, Pair]
            ;
                NumABS is (-1) * Num,
                Pair =.. [*, NumABS, Str],
                Res =.. [-, ResTail, Pair]
            )   
        )
    ).

% -----------------------------------End------------------------------------------------------------









prepareIntsToBB_INF(IntsOrig, Res) :-

    /* Checking that in the Store there are no duplicates */
    compressListWithStore(IntsOrig, IntsForAdding), 
    /* Adding attributes to new variables */
    addingAttr(IntsForAdding),

    updatingStore(IntsForAdding, _),

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


% Initialise the store to an empty list
% :- assertz(stored_expression('0=0')).
% :- assertz(stored_variables([])).

/*
store_expr(Expr) :-
    % writeln('Entering store_expr with ' : Expr), 
    retract(stored_expression(ExprList)),
    term_string(Expr, ExprS),
    assertz(stored_expression([ExprS | ExprList])),
    % writeln('Stored expression added: ' : [ExprS | ExprList]),
    undo(del(ExprS))
    , writeln('Leaving store_expr, added undo with ' : ExprS)
store_expr(Expr)    .
*/



% Predicate to get the stored expressions
/*
get_exprs(ExprList) :- 
    !,
    undo(writeln('get_exprs back outcome point')),
    undo(writeln('adding undo before outcome jff')),
    findall(X, stored_expression(X), ExprList)
    , writeln('All I found is ' : ExprList)
    , undo(writeln('Get_exprs back enter point'))
    % , undo(writeln(ExprList))
    ,!
    .

b_assertz(Term) :-
    % get_exprs(Was), writeln('Store was ' : Was),
    assertz(Term, Ref),
    % get_exprs(Now), writeln('Store now ' : Now),
    undo(writeln('Undo of sotring finished finex1')),
    undo(writeln('Undo of sotring finished finex2')),
    undo((writeln('erasing'), erase(Ref))).

store_expr(Expr) :-
    % writeln('Adding to storage' : Expr),
    undo(writeln('Undo at the beggining of store_expr')),
    term_string(Expr, ExprS),
    b_assertz(stored_expression(ExprS)).
*/

:- initialization(init_store).

init_store :-
    nb_setval(store, []),
    nb_setval(store_advensed, []),
    nb_setval(store_vars, []).



get_exprs(ExprList) :-
    b_getval(store, ExprList)
    .

store_expr(Expr) :- 
    % writeln('ADDED CONSTRAIN : '),
    % writeln(Expr),
    b_getval(store, StoreWas),
    % term_string(Expr, ExprS),
    b_setval(store, [Expr|StoreWas])
    .

get_cons(Cons) :-
    b_getval(store_advensed, Cons).

store_cons(Con) :-
    b_getval(store_advensed, Store),
    b_setval(store_advensed, [Con|Store]).


get_vars(Vars) :-
    b_getval(store_vars, Vars).

store_vars(Var) :-
    b_getval(store_vars, Store),
    b_setval(store_vars, [Var|Store]).
    

/*
get_exprs(ExprList) :-
    stored_expression(ExprList). 
*/

% Maxi 
p(X) :-
 term_string(X,S),
 write(S),nl,
 assertz(expr(S)).



% **********************************************
% Helpers for debugging purposes

% Predicate to display the list of stored expressions
show_all_exprs :-
    get_exprs(ExprList),
    write('Stored expressions: \n'), 
    print_list(ExprList).


print_list([]).
print_list([Head|Tail]) :-
    write(Head), print_list(Tail).

 

reverse_list([], []).
reverse_list([H|T], Reversed) :-
    reverse_list(T, RevTail),
    round(H, RH),
    append(RevTail, [RH], Reversed).
    


strings_to_terms([], []).
strings_to_terms([String|Rest], [Term|TermRest]) :-
    term_string(Term, String),
    strings_to_terms(Rest, TermRest).


% Base case: the length of an empty list is 0
list_length([], 0).

% Recursive case: the length of a list is 1 plus the length of its tail
list_length([_|Tail], Length) :-
    list_length(Tail, TailLength),
    Length is TailLength + 1.


/*
% Main predicate to split the input list
split_expressions([String], List) :-
    split_string(String, ",", " ", SubStrings), % Split by ',' and trim spaces
    maplist(string_to_atom, SubStrings, List).

% Convert a string to an atom (if needed)
string_to_atom(Str, Atom) :-
    atom_string(Atom, Str).
*/
/*
% Example usage
?- split_expressions(["X<Y, Y>=5, min(X,Y)>0"], Result).
% Expected Result: ["X<Y", "Y>=5", "min(X,Y)>0"]
*/


% Predicate to convert a string into a term and keep the variable names
string_to_term_with_vars(String, Term, VarNames) :-
    read_term_from_atom(String, Term, [variable_names(VarNames)]).


% Predicate to convert a list of strings into a list of terms
strings_to_terms([], [], []).
strings_to_terms([String|Strings], [Term|Terms], [VarNames|VarsList]) :-
    string_to_term_with_vars(String, Term, VarNames),
    strings_to_terms(Strings, Terms, VarsList).






























































% *************************************
% More predicates in library(clpqr)

/*

entailed(+Constraint)
Succeeds if Constraint is necessarily true within the current constraint store.
This means that adding the negation of the constraint to the store results in failure.
Implemented in 
https://github.com/SWI-Prolog/packages-clpqr/blob/master/clpq/nf_q.pl



inf(+Expression, -Inf)
Computes the infimum of Expression within the current state of the constraint store and returns that infimum in Inf. 
This predicate does not change the constraint store.



sup(+Expression, -Sup)
Computes the supremum of Expression within the current state of the constraint store and returns that supremum in Sup.
This predicate does not change the constraint store.



minimize(+Expression)
Minimizes Expression within the current constraint store. 
This is the same as computing the infimum and equating the expression to that infimum.



maximize(+Expression)
Maximizes Expression within the current constraint store. 
This is the same as computing the supremum and equating the expression to that supremum.



bb_inf(+Ints, +Expression, -Inf, -Vertex, +Eps)
This predicate is offered in CLP(R) only. 
It computes the infimum of Expression within the current constraint store, with the additional constraint that in that infimum, all variables in Ints have integral values.
Vertex will contain the values of Ints in the infimum.
Eps denotes how much a value may differ from an integer to be considered an integer.
E.g. when Eps = 0.001, then X = 4.999 will be considered as an integer (5 in this case). Eps should be between 0 and 0.5.



bb_inf(+Ints, +Expression, -Inf)
The same as bb_inf/5 or bb_inf/4 but without returning the values of the integers.
In CLP(R), an error margin of 0.001 is used.


dump(+Target, +Newvars, -CodedAnswer)
Returns the constraints on Target in the list CodedAnswer where all variables of Target have been replaced by NewVars.
This operation does not change the constraint store. E.g. in
   
dump([X,Y,Z],[x,y,z],Cons)

Cons will contain the constraints on X, Y and Z, where these variables have been replaced by atoms x, y and z. 


*/
