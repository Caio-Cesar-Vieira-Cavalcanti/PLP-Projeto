:- use_module('./Coordenada').
:- use_module('../UI/HUD').

geraCoordenada(Coord) :- 
Coord = coordenada("X", " ", false).

geraLinha(0, []) :- !.
geraLinha(NumLinhas, [Coord | T2]) :-
    NumLinhas2 is NumLinhas - 1,
    geraCoordenada(Coord),
    geraLinha(NumLinhas2, T2).

geraTabuleiroInicial(_, 0, []) :- !.
geraTabuleiroInicial(NumLinhas, I, [L | T2]) :- 
    I > 0,
    geraLinha(NumLinhas, L),
    I2 is I - 1,
    geraTabuleiroInicial(NumLinhas, I2, T2).

elemEspecialOuMascara(Coord, R) :-
getAcertou(Coord, Acertou),
getElemEspecial(Coord, ElemEspecial),
getMascara(Coord, Mascara),
(Acertou -> string_concat(ElemEspecial, " ", R) ; string_concat(Mascara, " ", R)).

% Caso queira ver a visualização da tabela, retire o parâmetro, descomente as últimas linhas e rode essa regra.
geraTabuleiroString(TabelaStr) :-
geraTabuleiroInicial(12, 12, Tabela),
mapTabuleiro(12, 12, Tabela, TabelaStr).
% adicionaNumeros(12, 1, TabelaStr, NewT),
% concatenaCabecalho(NewT, TabelaPronta),
% imprimiTabela(TabelaPronta).

mapTabuleiroRecursivo([], []) :- !.
mapTabuleiroRecursivo([H | T], [H2 | T2]) :-
elemEspecialOuMascara(H, H2),
mapTabuleiroRecursivo(T, T2).

mapTabuleiro(_, _, [], []) :- !.
mapTabuleiro(NumArrays, I, [H | T], [H2 | T2]) :-
I > 0,
mapTabuleiroRecursivo(H, H2),
I2 is I - 1,
mapTabuleiro(NumArrays, I2, T, T2).