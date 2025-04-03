:- module(tabuleiro, [
    geraTabuleiroString/2,
    geraTabuleiroDispor/1,
    mainAtirouNaCoordenada/5,
    pontuacaoElemento/2
]).

:- use_module('./Coordenada').

% PROBLEMA (resultando em falso no chamado do geraTabuleiroDispor com disporEspacos) - necessita de cortes

% Gera o tabuleiro base e dispões os elementos especiais
geraTabuleiroDispor(TabelaInicial) :-
    geraTabuleiroInicial(12, 12, TabelaInicial).
    %disporEspacos(TabelaInicial, TabelaPronta).  % Com essa regra, o mainTabela retorna falso

% Regras auxiliares da geração do tabuleiro e coordenada
% * Para testar os elementos especiais dispostos, basta trocar para true
geraCoordenada(Coord) :- 
    Coord = coordenada("X", "-", false).  

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

% Regra de lógica de acerto à coordenada (+ pontuação)
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

% Regras de alterar o elemento especial de uma coordenada
setElemEspecialAux([], _, _, _, _, []).
setElemEspecialAux([H | T], NewElemEspecial, I, C, NewElemEspecialPertenceALinha, [H2 | T2]) :-
    (
        NewElemEspecialPertenceALinha ->
        (
            I =:= C ->
            setElem(H, NewElemEspecial, H2) ;
            H2 = H
        ) ;
        H2 = H
    ),
    I2 is I + 1,
    setElemEspecialAux(T, NewElemEspecial, I2, C, NewElemEspecialPertenceALinha, T2).

setElemEspecial([], _, _, _, _, []).
setElemEspecial([H | T], NewElemEspecial, I, L, C, [H2 | T2]) :-
    (I =:= L -> NewElemEspecialPertenceALinha = true ; NewElemEspecialPertenceALinha = false),
    setElemEspecialAux(H, NewElemEspecial, 0, C, NewElemEspecialPertenceALinha, H2),
    I2 is I + 1,
    setElemEspecial(T, NewElemEspecial, I2, L, C, T2).

% Regras para dispor os espaços especiais no tabuleiro (amigos e inimigos)
/* 
Verifica se há espaço livre para a inserção de um grupo de elementos;
Verificando se todos os espaços reservados por um determinado tamanho são válidos;
E se há algum grupo adjacente ou não.
*/
verificarEspacoLivre(Tabela, Linha, Coluna, Tamanho, Horizontal, Char) :-
    (Horizontal -> 
        findall((L, C), (between(0, Tamanho-1, I), C is Coluna + I, C =< 11, L = Linha), EspacosLivres)
    ;
        findall((L, C), (between(0, Tamanho-1, I), L is Linha + I, L =< 11, C = Coluna), EspacosLivres)
    ),
    length(EspacosLivres, Tamanho),
    todosValidos(Tabela, EspacosLivres),
    semGrupoAdjacente(Tabela, EspacosLivres, Char).

todosValidos(_, []).
todosValidos(Tabela, [(L, C) | T]) :-
    nth0(L, Tabela, Linha),
    nth0(C, Linha, Coord),
    getElemEspecial(Coord, '-'),
    todosValidos(Tabela, T).

semGrupoAdjacente(_, [], _).
semGrupoAdjacente(Tabela, [(L, C) | T], Char) :-
    \+ temGrupoAdjacente(Tabela, L, C, Char),
    semGrupoAdjacente(Tabela, T, Char).

temGrupoAdjacente(Tabela, Linha, Coluna, Char) :-
    Direcoes = [(-1, 0), (1, 0), (0, -1), (0, 1)],
    member((DL, DC), Direcoes),
    L is Linha + DL,
    C is Coluna + DC,
    L >= 0, L < 12, C >= 0, C < 12,
    nth0(L, Tabela, LinhaTab),
    nth0(C, LinhaTab, Coord),
    getElemEspecial(Coord, Char).

disporEspacos(Tabela, NovaTabela) :-
    Elementos = [('C', 1, 1), ('E', 1, 1), ('H', 1, 1), ('$', 2, 1),
                 ('#', 2, 1), ('S', 3, 2), ('M', 2, 3), ('T', 1, 5)],
    disporElementos(Elementos, Tabela, NovaTabela).

disporElementos([], Tabela, Tabela).
disporElementos([(Char, Qtd, Tam) | T], Tabela, NovaTabela) :-
    (Tam == 1 -> colocarElemento(Char, Qtd, Tabela, TabelaIntermedia)
    ; colocarGrupo(Char, Tam, Qtd, Tabela, TabelaIntermedia)),
    disporElementos(T, TabelaIntermedia, NovaTabela).

colocarElemento(_, 0, Tabela, Tabela).
colocarElemento(Char, N, Tabela, NovaTabela) :-
    N > 0,
    random_between(0, 11, Linha),
    random_between(0, 11, Coluna),
    nth0(Linha, Tabela, LinhaTab),
    nth0(Coluna, LinhaTab, Coord),
    getElemEspecial(Coord, '-'),
    setElemEspecial(Tabela, Char, 0, Linha, Coluna, TabelaAtualizada), % ANALISAR
    N1 is N - 1,
    colocarElemento(Char, N1, TabelaAtualizada, NovaTabela).

colocarGrupo(_, _, 0, Tabela, Tabela).
colocarGrupo(Char, Tam, Qtd, Tabela, NovaTabela) :-
    random_between(0, 11, Linha),
    random_between(0, 11, Coluna),
    random_member(Horizontal, [true, false]),
    verificarEspacoLivre(Tabela, Linha, Coluna, Tam, Horizontal, Char),
    inserirGrupo(Tabela, Linha, Coluna, Tam, Horizontal, Char, TabelaIntermedia),
    Qtd1 is Qtd - 1,
    colocarGrupo(Char, Tam, Qtd1, TabelaIntermedia, NovaTabela).

inserirGrupo(Tabela, Linha, Coluna, Tam, Horizontal, Char, NovaTabela) :-
    (Horizontal -> findall((Linha, C), (between(0, Tam-1, I), C is Coluna + I), Posicoes)
    ; findall((L, Coluna), (between(0, Tam-1, I), L is Linha + I), Posicoes)),
    inserirElementos(Posicoes, Char, Tabela, NovaTabela).

inserirElementos([], _, Tabela, Tabela).
inserirElementos([(L, C) | T], Char, Tabela, NovaTabela) :-
    nth0(L, Tabela, LinhaTab),
    nth0(C, LinhaTab, Coord),
    getElemEspecial(Coord, '-'),
    setElemEspecial(Tabela, Char, 0, L, C, TabelaAtualizada),  % ANALISAR
    inserirElementos(T, Char, TabelaAtualizada, NovaTabela).

% Regras para contabilização dos espaços amigos e inimigos








% Regras para lógica do drone e mina (espaços especiais)
