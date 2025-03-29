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

geraTabuleiroString(Tabela, TabelaStr) :-
mapTabuleiro(12, 12, Tabela, TabelaStr).

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

capturaElemAtirado(MatrizCoord, L, C, ElemEspecial, NewCoord) :-
nth0(L, MatrizCoord, Linha),
nth0(C, Linha, Coord),
getElemEspecial(Coord, ElemEspecial),
setAcertou(Coord, NewCoord).

atirouNaCoordenadaAux([], _, _, _, _, []).
atirouNaCoordenadaAux([H | T], NewCoord, I, C, NewCoordPertenceAEssaLinha, [H2 | T2]) :-
(NewCoordPertenceAEssaLinha -> 
(I =:= C -> H2 = NewCoord ; H2 = H)
; H2 = H),
I2 is I + 1,
atirouNaCoordenadaAux(T, NewCoord, I2, C, NewCoordPertenceAEssaLinha, T2).

% essa regra deverá ter um parâmetro a mais para retornar as moedas ganhas pela coordenada acertada, consequentemente, mainAtirouNaCoordenada tbm terá esse parâmetro a mais.
atirouNaCoordenada([], _, _, _, _, []).
atirouNaCoordenada([H | T], NewCoord, I, L, C, [H2 | T2]) :-
(I =:= L -> NewCoordPertenceAEssaLinha = true ; NewCoordPertenceAEssaLinha = false),
atirouNaCoordenadaAux(H, NewCoord, 0, C, NewCoordPertenceAEssaLinha, H2),
I2 is I + 1,
atirouNaCoordenada(T, NewCoord, I2, L, C, T2).

mainAtirouNaCoordenada(MatrizCoord, L, C, NovaMatrizCoord, MoedasGanhas) :-
capturaElemAtirado(MatrizCoord, L, C, ElemEspecial, NewCoord),
atirouNaCoordenada(MatrizCoord, NewCoord, 0, L, C, NovaMatrizCoord),
pontuacaoElemento(ElemEspecial, MoedasGanhas).

pontuacaoElemento('S', 25) :- !.
pontuacaoElemento('M', 34) :- !.
pontuacaoElemento('T', 40) :- !.
pontuacaoElemento('$', 250) :- !.
pontuacaoElemento(_, 0).