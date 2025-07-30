%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Write the answer                 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
append_to_file(File, Content) :- 
    open(File, append, Stream),
    writeln(Stream, Content), 
    close(Stream).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Using for converting entries     %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


parse(FileNameInput, FileNameOutput) :- 
    open(FileNameInput, read, StreamIn), 
    read_string(StreamIn, "\n", "\r", _Sep, Heading),
    % read_string(StreamIn, _, Heading),
    Struct = linprog(name(""), entries([]), ints([]), signRHS([]), buf([':-time((\n']), vars([])),
    parser(Heading, Struct, Ans, StreamIn),
    close(StreamIn), 
    open(FileNameOutput, write, StreamOut), 
    maplist(write(StreamOut), Ans), % Ans is a list of strings !!!!
    close(StreamOut),
    !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


parse_name(Str, Struct, StructNew, NextHeading, Stream) :- 

    read_string(Stream, "\n", "\r", _Sep, NextHeading),
    Struct = linprog(name(_Name), entries(E), ints(Ints), signRHS(SignRHS), buf(B), vars(Vars)),
    nth0(1, Str, NameNew), 
    StructNew = linprog(name(NameNew), entries(E), ints(Ints), signRHS(SignRHS), buf(B), vars(Vars)).
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_row(Str, Type, Name) :- 
    split_string(Str, " ", " ", [TypeS, NameS]), 
    atom_string(Type, TypeS),
    atom_string(Name, NameS).


parse_rows(Stream, Struct, StructNew, NextHeading) :-
    read_string(Stream, "\n", "\r", _Sep, Str),
    % read_string(Stream, _, Str),
    
    (read_row(Str, Type, Name) -> 
        parse_rows(Stream, Struct, StructUPD, NextHeading),
        StructUPD = linprog(name(NameLinprog), entries(E), ints(Ints), signRHS(SignRHS), buf(B), vars(Vars)),
        append([SignRHS, [Name-Type]], SignRHSNew),
        StructNew = linprog(name(NameLinprog), entries(E), ints(Ints), signRHS(SignRHSNew), buf(B), vars(Vars));
    
    NextHeading = Str, StructNew = Struct
    ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*  
Output: either: [RName-CName-Vals]
or [RName-CName-Vals, RName-CName-Vals]

Names: [CName]
*/
read_col(Line, Coefs, Names) :-
    % Split the line into tokens by whitespace
    % Line =.. [CNameS, RNameS, ValS],
    split_string(Line, " ", " ", [CNameS, RNameS, ValSRaw]),
    string(CNameS), string(RNameS), string(ValSRaw),
    number_checker(ValSRaw, ValS),
    !,

    % Transform a variable name into "V"+name, because in
    % Prolog all names must be with capital fist letter.
    string_concat("V", CNameS, CNameSP),

    % Convert to atoms (if desired)
    atom_string(CName, CNameSP),
    atom_string(RName, RNameS),


    Coefs = [RName-(CName-ValS)],
    Names = [CName].

read_col(Line, Coefs, Names) :- 
    % Split the line into tokens by whitespace
    split_string(Line, " ", " ", [CNameS, RNameS1, ValS1Raw, RNameS2, ValS2Raw]),
    string(CNameS), string(RNameS1), string(ValS1Raw), string(RNameS2), string(ValS2Raw),
    number_checker(ValS1Raw, ValS1),
    number_checker(ValS2Raw, ValS2),
    !,

    % Transform a variable name into "V"+name, because in
    % Prolog all names must be with capital fist letter.
    string_concat("V", CNameS, CNameSP),

    % Convert to atoms (if desired)
    atom_string(CName, CNameSP),
    atom_string(RName1, RNameS1),
    atom_string(RName2, RNameS2),


    Coefs = [RName1-(CName-ValS1), RName2-(CName-ValS2)],
    Names = [CName].


parse_cols(Stream, Struct, StructNew, NextHeading, IsInt) :-
    read_string(Stream, "\n", "\r", _Sep, Str),
    % read_string(Stream, _, Str),

    (sub_string(Str, _, _, _, "MARKER") -> 
    (sub_string(Str, _, _, _, "INTORG") -> 
        parse_cols(Stream, Struct, StructNew, NextHeading, 1);
        parse_cols(Stream, Struct, StructNew, NextHeading, 0)
    );
    (read_col(Str, Coefs, Names) -> 

        parse_cols(Stream, Struct, StructUPD, NextHeading, IsInt),
        StructUPD = linprog(name(NameLinprog), entries(E), ints(Ints), signRHS(SignRHS), buf(B), vars(Vars)),
        append([E, Coefs], ENew),
        (IsInt == 1 -> append([Ints, Names], IntsRaw); IntsRaw = Ints),
        sort(IntsRaw, IntsNew),

        append([Vars, Names], VRaw),
        sort(VRaw, VarsNew),
        
        StructNew = linprog(name(NameLinprog), entries(ENew), ints(IntsNew), signRHS(SignRHS), buf(B), vars(VarsNew));

    NextHeading = Str, StructNew = Struct
    )).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_rhs(Line, RhsBounds) :- 
    split_string(Line, " ", " ", [Rhs, RNameS, ValSRaw]), 
    string(Rhs), string(RNameS), string(ValSRaw),
    number_checker(ValSRaw, ValS),
    !,
    % Convert to atoms (if desired)
    atom_string(RName, RNameS),
    atom_string(Val, ValS),
    
    RhsBounds = [RName-Val].

read_rhs(Line, RhsBounds) :- 
    split_string(Line, " ", " ", [Rhs, RNameS1, ValS1Raw, RNameS2, ValS2Raw]), 
    string(Rhs), string(RNameS1), string(ValS1Raw), string(RNameS2), string(ValS2Raw),
    number_checker(ValS1Raw, ValS1),
    number_checker(ValS2Raw, ValS2),
    !,
    % Convert to atoms (if desired)
    atom_string(RName1, RNameS1),
    atom_string(RName2, RNameS2),
    
    RhsBounds = [RName1-ValS1, RName2-ValS2].


parse_rhs(Stream, Struct, StructNew, NextHeading) :- 
    read_string(Stream, "\n", "\r", _Sep, Str),
    % read_string(Stream, _, Str), 

    (read_rhs(Str, RhsBounds) ->

        parse_rhs(Stream, Struct, StructUPD, NextHeading),
        StructUPD = linprog(name(NameLinprog), entries(E), ints(Ints), signRHS(SignRHS), buf(B), vars(Vars)),
        append([SignRHS, RhsBounds], SignRHSNew),
        StructNew = linprog(name(NameLinprog), entries(E), ints(Ints), signRHS(SignRHSNew), buf(B), vars(Vars));
    
    NextHeading = Str, StructNew = Struct
    ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

read_bound(Line, Type, Name, ValS) :-
    split_string(Line, " ", " ", [Type, _, NameRaw, ValSRaw]),
    number_checker(ValSRaw, ValS), 
    string_concat("V", NameRaw, NameStr),

    atom_codes(Name, NameStr). 

read_bound(Line, Type, Name) :-
    split_string(Line, " ", " ", [Type, _, NameRaw]),
    string_concat("V", NameRaw, NameStr),

    atom_codes(Name, NameStr). 



parse_bounds(Stream, Struct, StructNew, NextHeading) :-
    read_string(Stream, "\n", "\r", _Sep, Str),
    % read_string(Stream, _, Str), 

    (read_bound(Str, Type, Name, ValS) -> 
        
        parse_bounds(Stream, Struct, StructUPD, NextHeading),
        StructUPD = linprog(name(NameLinprog), entries(E), ints(Ints), signRHS(SignRHS), buf(B), vars(Vars)),
        (member(Name, Vars) -> 
            !,select(Name, Vars, VarsNew),!;
            VarsNew = Vars),
        ((Type == "LO"; Type == "LI") -> 
            string_concat("{", ValS, T1),
            string_concat(T1, " =< ", T2),
            string_concat(T2, Name, T3),
            string_concat(T3, "},\n", Update);
        ((Type == "UP"; Type == "UI") ->
            string_concat("{0 =< ", Name, T0),
            string_concat(T0, "}, {", T00),
            string_concat(T00, ValS, T1),
            string_concat(T1, " >= ", T2),
            string_concat(T2, Name, T3),
            string_concat(T3, "},\n", Update);
        (Type == "FX" -> 
            string_concat("{", Name, T1),
            string_concat(T1, " = ", T2),
            string_concat(T2, ValS, T3),
            string_concat(T3, "},\n", Update);
        writeln("Unknown Bound"), writeln(Str)
        ))),
        append([B, [Update]], BNew), 
        StructNew = linprog(name(NameLinprog), entries(E), ints(Ints), signRHS(SignRHS), buf(BNew), vars(VarsNew))

    ; 
        (read_bound(Str, Type, Name) -> 

            parse_bounds(Stream, Struct, StructUPD, NextHeading),
            StructUPD = linprog(name(NameLinprog), entries(E), ints(Ints), signRHS(SignRHS), buf(B), vars(Vars)),
            (Type == "PL" -> Update="";
            (member(Name, Vars) -> 
                !,select(Name, Vars, VarsNew),!;
                VarsNew = Vars),
            ((Type == "FR";Type == "MI") -> Update="";
            
            (Type == "BV" -> 
                string_concat("{", Name, T1),
                string_concat(T1, " = 0; 1 = ", T2),
                string_concat(T2, Name, T3),
                string_concat(T3, "},\n", Update);
            writeln("Unknown Bound: "), writeln(Str)
            ))),
            append([B, [Update]], BNew), 
            StructNew = linprog(name(NameLinprog), entries(E), ints(Ints), signRHS(SignRHS), buf(BNew), vars(VarsNew))
    
        ; 
            NextHeading = Str, StructNew = Struct
        )
    ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

is_sign(H) :- 
    H == 'N'; H == 'L'; H == 'G'; H == 'E'.


find_type([], _) :- !, fail.

find_type([H|Rest], Ans) :- 
    (is_sign(H) -> Ans = H; find_type(Rest, Ans)).


find_RHS([], "0"). % 0 by default
find_RHS([H|Rest], Ans) :-
    (\+ compound(H), \+ is_sign(H) -> Ans = H; find_RHS(Rest, Ans)).



construct([], "") :- !.
construct([H|Rest], Ans) :- 
    ((string(H) ; atom(H)) -> construct(Rest, Ans); 

        H = (CName-Val),
        construct(Rest, AnsWas),
        (AnsWas == "" -> IsNeg = '-'; sub_string(AnsWas, 0, 1, _, IsNeg)),
        (IsNeg == '-' -> 
        with_output_to(string(Ans), format('~w*~w ~w', [Val, CName, AnsWas]));
        with_output_to(string(Ans), format('~w*~w + ~w', [Val, CName, AnsWas])))).


convert_LOR([], [], _).
convert_LOR([(_RName-V)|ConsTail], [AnsRawHead|AnsRawTail], ObjSTR) :- 
    find_type(V, Type),
    construct(V, LHS),
    (Type == 'N' ->   

        ObjSTR = LHS, AnsRawHead = ""
    ;
    find_RHS(V, RHS),

        (Type == 'E' -> Sign = '='; Type == 'G' -> Sign = '>='; Type == 'L' -> Sign = '=<' ; writeln("Unknown Type:"),writeln(Type)),
        with_output_to(string(AnsRawHead), format('{~w ~w ~w},\n', [LHS, Sign, RHS]))
    ),

    convert_LOR(ConsTail, AnsRawTail, ObjSTR).


conver_to_BB(Ints, BB_Function, ObjSTR) :-
    /* Closing time( () ) / 1 */
    with_output_to(string(BB_Function), format('bb_inf(~w, ~w, Answer), writeln(Answer))).\n', [Ints, ObjSTR])).



addingPosit(AnsCons, [], Result) :- Result = AnsCons.
addingPosit(AnsCons, [H|T], AnsConsFull) :- 
    addingPosit(AnsCons, T, AnsConsFullWas), 
    with_output_to(string(Str), format('{0 =< ~w},\n', [H])),
    append([AnsConsFullWas, [Str]], AnsConsFull).




mps_to_clpq(Struct, Ans) :- 
    !,
    Struct = linprog(name(_Name), entries(E), ints(Ints), signRHS(SignRHS), buf(B), vars(Vars)),
    % writeln('Current buffer is'),
    % writeln(B),
    append([E, SignRHS], ListOfRows),
    sort(ListOfRows, NtListOfRows),
    group_pairs_by_key(NtListOfRows, Cons),
    convert_LOR(Cons, AnsRaw, ObjSTR),
    append([B, AnsRaw], AnsCons),
    addingPosit(AnsCons, Vars, AnsConsFull),
    conver_to_BB(Ints, BB_Function, ObjSTR),
    append([AnsConsFull, [BB_Function]], Ans).
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parser(Heading, Struct, Ans, Stream) :- 
    !,
    split_string(Heading, " ", " ", Str), 
    (Str == ["ENDATA"] -> !, mps_to_clpq(Struct, Ans);
        (nth0(0, Str, "NAME") -> !, parse_name(Str, Struct, StructNew, NextHeading, Stream);
        (nth0(0, Str, "ROWS") -> !, parse_rows(Stream, Struct, StructNew, NextHeading);
        (nth0(0, Str, "COLUMNS") -> !, parse_cols(Stream, Struct, StructNew, NextHeading, 0); % No flags were applied
        (nth0(0, Str, "RHS") -> !, parse_rhs(Stream, Struct, StructNew, NextHeading);
        (nth0(0, Str, "BOUNDS") -> !, parse_bounds(Stream, Struct, StructNew, NextHeading);
        (sub_string(Heading, 0, 1, _, "*");Str==[]) -> !, StructNew = Struct, read_string(Stream, "\n", "\r", _Sep, NextHeading);
        writeln("Unknown format found"), writeln(Str)
        ))))),
        parser(NextHeading, StructNew, Ans, Stream)).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Helpers

number_checker(NumStr, NumStrChecked) :-
    (
        sub_string(NumStr, 0, 1, _, ".") -> 
            string_concat("0", NumStr, NumStrFrontChecked)
            
        ;  
            (sub_string(NumStr, 0, 2, _, "-.") ->
            sub_string(NumStr, 2, _, 0, NumStrRest), 
            string_concat("-0.", NumStrRest, NumStrFrontChecked)
            ;
            NumStrFrontChecked = NumStr
            )
    ),
    (sub_string(NumStrFrontChecked, _, 1, 0, ".") ->
        string_concat(NumStrFrontChecked, "0", NumStrChecked);
        NumStrChecked = NumStrFrontChecked
    ).
