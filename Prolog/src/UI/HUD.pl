mainScreen(Nome) :-
format('Jogador: ~w', [Nome]), nl, nl,
mainTabela, nl, nl,
inimigosDestruidos(0), nl,
espacosAmigosAtingidos(0), nl, nl,
inventario(55, 2, 1, 0), nl, nl,
moedas(0), nl, nl,
writeln('Atalhos:'),
writeln("'1' -> Usar bomba pequena"),
writeln("'2' -> Usar bomba média"),
writeln("'3' -> Usar bomba grande"),
writeln("'4' -> Usar o drone visualizador de áreas"),
writeln("{COLUNA}{LINHA} -> Coordenada que deseja atacar; Exemplo: C3"),
writeln(""),
writeln("'m' -> Acesso ao mercado"),
writeln("'s' -> Salvar o jogo no estado atual"),
writeln("'q' -> Sair do jogo sem salvar").

geraLinha(0, []) :- !.
geraLinha(NumLinhas, ["X " | T2]) :-
NumLinhas2 is NumLinhas - 1,
geraLinha(NumLinhas2, T2).

geraTabela(_, 0, []) :- !.
geraTabela(NumLinhas, I, [L | T2]) :- 
I > 0,
geraLinha(NumLinhas, L),
I2 is I - 1,
geraTabela(NumLinhas, I2, T2).

inteiroParaString(N, S3) :-
atom_number(A, N), 
atom_string(A, S),
string_concat(S, ' ', S2),
(N < 10 -> string_concat(' ', S2, S3) ; S3 = S2).

adicionaNumeros(X, Y, _, []) :- Y is X + 1, !.
adicionaNumeros(NumLinhas, I, [H | T], [R | C]) :-
I =< NumLinhas,
I2 is I + 1,
inteiroParaString(I, S),
append([S], H, R),
adicionaNumeros(NumLinhas, I2, T, C).

concatenaCabecalho(T, NewT) :-
append([["   ", "A ", "B ", "C ", "D ", "E ", "F ", "G ", "H ", "I ", "J ", "K ", "L "]], T, NewT).

imprimiTabela([]) :- write("").
imprimiTabela([H | T]) :-
atomic_list_concat(H, '', Str),
writeln(Str),
imprimiTabela(T).

mainTabela :-
geraTabela(12, 12, Tabela),
adicionaNumeros(12, 1, Tabela, NewT),
concatenaCabecalho(NewT, TabelaPronta),
imprimiTabela(TabelaPronta).

inimigosDestruidos(X) :-
format('Inimigos: ~w/6', [X]).

espacosAmigosAtingidos(X) :-
format('Espaços Amigos: ~w/3', [X]).

inventario(A, B, C, D) :-
writeln('Inventário:'),
format('Bombas pequenas: ~w | Bombas médias: ~w | Bombas grandes: ~w', [A, B, C]), nl,
format('Drone visualizador de áreas: ~w', [D]).

moedas(X) :-
format('Moedas: ~w', [X]).