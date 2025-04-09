:- module(tabuleiro, [
    geraTabuleiroString/2,
    geraTabuleiroDispor/1,
    mainAtirouNaCoordenada/5,
    contabilizarAmigos/2,
    contabilizarInimigos/2,
    tiroBombaMedia/5,
    tiroBombaGrande/5,
    drone/4,
    desfazVisualizacaoDrone/2
]).

:- use_module('./Coordenada').

% Gera o tabuleiro base e dispões os elementos especiais
geraTabuleiroDispor(TabelaPronta) :-
    geraTabuleiroInicial(12, 12, TabelaInicial),
    mainDisporElem(TabelaInicial, TabelaPronta). 

% Regras auxiliares da geração do tabuleiro e coordenada

% * Para testar os elementos especiais dispostos, basta trocar para true
geraCoordenada(Coord) :- 
    Coord = coordenada('X', '-', false).  

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
    (Acertou -> string_concat(ElemEspecial, ' ', R) ; string_concat(Mascara, ' ', R)).

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
    Tam2 is Tamanho-1,
    (Horizontal -> 
        findall((L, C), (between(0, Tam2, I), C is Coluna + I, C =< 11, L = Linha), EspacosLivres)
    ;
        findall((L, C), (between(0, Tam2, I), L is Linha + I, L =< 11, C = Coluna), EspacosLivres)
    ),
    length(EspacosLivres, Tamanho),
    todosValidos(Tabela, EspacosLivres),
    semGrupoAdjacente(Tabela, EspacosLivres, Char).

todosValidos(_, []) :- !.
todosValidos(Tabela, [(L, C) | T]) :-
    nth0(L, Tabela, Linha),
    nth0(C, Linha, Coord),
    getElemEspecial(Coord, '-'),
    todosValidos(Tabela, T).

semGrupoAdjacente(_, [], _) :- !.
semGrupoAdjacente(Tabela, [(L, C) | T], Char) :-
    Direcoes = [(-1, 0), (1, 0), (0, -1), (0, 1)],
    \+ temGrupoAdjacente(Tabela, L, C, Char, Direcoes),
    semGrupoAdjacente(Tabela, T, Char).

temGrupoAdjacente(_, _, _, _, []) :- fail. 
temGrupoAdjacente(Tabela, Linha, Coluna, Char, [(DL, DC) | _]) :-
    L is Linha + DL,
    C is Coluna + DC,
    L >= 0, L < 12,
    C >= 0, C < 12,
    nth0(L, Tabela, LinhaTab),
    nth0(C, LinhaTab, Coord),
    getElemEspecial(Coord, OutroChar),
    OutroChar == Char, !. 

temGrupoAdjacente(Tabela, Linha, Coluna, Char, [_ | Resto]) :-
    temGrupoAdjacente(Tabela, Linha, Coluna, Char, Resto).

% Dispor os espaços ao tabuleiro, até encontrar um caso que for êxito para todos os espaços
mainDisporElem(Tabela, NovaTabela) :-
    (disporEspacos(Tabela, NovaTabela) -> !
    ; mainDisporElem(Tabela, NovaTabela)).

disporEspacos(Tabela, NovaTabela) :-
    Elementos = [('C', 1, 1), ('E', 1, 1), ('H', 1, 1), ('$', 2, 1),
                 ('#', 2, 1), ('S', 3, 2), ('M', 2, 3), ('T', 1, 5)],
    disporElementos(Elementos, Tabela, NovaTabela).

disporElementos([], Tabela, Tabela) :- !.
disporElementos([(Char, Qtd, Tam) | T], Tabela, NovaTabela) :-
    (Tam =:= 1 -> colocarElemento(Char, Qtd, Tabela, TabelaIntermedia)
    ; colocarGrupo(Char, Tam, Qtd, Tabela, TabelaIntermedia)),
    disporElementos(T, TabelaIntermedia, NovaTabela).

colocarElemento(_, 0, Tabela, Tabela) :- !.
colocarElemento(Char, N, Tabela, NovaTabela) :-
    N > 0,
    random_between(0, 11, Linha),
    random_between(0, 11, Coluna),
    nth0(Linha, Tabela, LinhaTab),
    nth0(Coluna, LinhaTab, Coord),
    getElemEspecial(Coord, '-'),
    setElemEspecial(Tabela, Char, 0, Linha, Coluna, TabelaAtualizada),
    N1 is N - 1,
    colocarElemento(Char, N1, TabelaAtualizada, NovaTabela).

colocarGrupo(_, _, 0, Tabela, Tabela) :- !.
colocarGrupo(Char, Tam, Qtd, Tabela, NovaTabela) :-
    random_between(0, 11, Linha),
    random_between(0, 11, Coluna),
    random_member(Horizontal, [true, false]),
    verificarEspacoLivre(Tabela, Linha, Coluna, Tam, Horizontal, Char),
    inserirGrupo(Tabela, Linha, Coluna, Tam, Horizontal, Char, TabelaIntermedia),
    Qtd1 is Qtd - 1,
    colocarGrupo(Char, Tam, Qtd1, TabelaIntermedia, NovaTabela).

inserirGrupo(Tabela, Linha, Coluna, Tam, Horizontal, Char, NovaTabela) :-
    Tam2 is Tam-1,
    (Horizontal -> findall((Linha, C), (between(0, Tam2, I), C is Coluna + I), Posicoes)
    ; findall((L, Coluna), (between(0, Tam2, I), L is Linha + I), Posicoes)),
    inserirElementos(Posicoes, Char, Tabela, NovaTabela).

inserirElementos([], _, Tabela, Tabela) :- !.
inserirElementos([(L, C) | T], Char, Tabela, NovaTabela) :-
    nth0(L, Tabela, LinhaTab),
    nth0(C, LinhaTab, Coord),
    getElemEspecial(Coord, '-'),
    setElemEspecial(Tabela, Char, 0, L, C, TabelaAtualizada), 
    inserirElementos(T, Char, TabelaAtualizada, NovaTabela).

% Regras para contabilização dos espaços amigos e inimigos

contabilizarAmigos(Tabela, Total) :-
    flatten(Tabela, TabelaPlanificada),
    include(ehAmigoAcertado, TabelaPlanificada, AmigosAcertados),
    length(AmigosAcertados, Total).

ehAmigoAcertado(Coordenada) :-
    getAcertou(Coordenada, true),
    getElemEspecial(Coordenada, Elem),
    member(Elem, ['C', 'E', 'H']).

contabilizarInimigos(Tabela, Total) :-
    GruposInimigos = [('S', 2), ('M', 3), ('T', 5)],
    contabilizarTodosGrupos(GruposInimigos, Tabela, 0, Total).

contabilizarTodosGrupos([], _, Total, Total).
contabilizarTodosGrupos([(Char, Tamanho) | Resto], Tabela, Acum, TotalFinal) :-
    contarGrupo(Char, Tamanho, Tabela, Qtde),
    NovoAcum is Acum + Qtde,
    contabilizarTodosGrupos(Resto, Tabela, NovoAcum, TotalFinal).

contarGrupo(Char, Tamanho, Tabela, Qtde) :-
    findall(1, (
        between(0, 11, Linha),
        between(0, 11, Coluna),
        ehGrupoValido(Tabela, Char, Tamanho, (Linha, Coluna))
    ), Lista),
    length(Lista, Qtde).

ehGrupoValido(Tabela, Char, Tamanho, (Linha, Coluna)) :-
    ( grupoHorizontalValido(Tabela, Char, Tamanho, Linha, Coluna)
    ; grupoVerticalValido(Tabela, Char, Tamanho, Linha, Coluna)
    ).

grupoHorizontalValido(Tabela, Char, Tamanho, Linha, Coluna) :-
    ColunaMax is Coluna + Tamanho - 1,
    ColunaMax =< 11,

    (Coluna =:= 0 ;
     ColAntes is Coluna - 1,
     nth0(Linha, Tabela, LinhaLista),
     nth0(ColAntes, LinhaLista, CoordAntes),
     getElemEspecial(CoordAntes, Outro),
     Outro \= Char),

    T2 is Tamanho-1,
    forall(between(0, T2, Offset),
        (   Col is Coluna + Offset,
            nth0(Linha, Tabela, LinhaLista),
            nth0(Col, LinhaLista, Coord),
            getElemEspecial(Coord, Char),
            getAcertou(Coord, true)
        )
    ),

    (ColunaMax =:= 11 ;
     ColDepois is ColunaMax + 1,
     nth0(Linha, Tabela, LinhaLista),
     nth0(ColDepois, LinhaLista, CoordDepois),
     getElemEspecial(CoordDepois, Outro2),
     Outro2 \= Char).

grupoVerticalValido(Tabela, Char, Tamanho, Linha, Coluna) :-
    LinhaMax is Linha + Tamanho - 1,
    LinhaMax =< 11,

    (Linha =:= 0 ;
     LinhaAntes is Linha - 1,
     nth0(LinhaAntes, Tabela, LinhaListaAntes),
     nth0(Coluna, LinhaListaAntes, CoordAntes),
     getElemEspecial(CoordAntes, Outro),
     Outro \= Char),

    T2 is Tamanho-1,
    forall(between(0, T2, Offset),
        (   Lin is Linha + Offset,
            nth0(Lin, Tabela, LinhaLista),
            nth0(Coluna, LinhaLista, Coord),
            getElemEspecial(Coord, Char),
            getAcertou(Coord, true)
        )
    ),

    (LinhaMax =:= 11 ;
     LinhaDepois is LinhaMax + 1,
     nth0(LinhaDepois, Tabela, LinhaListaDepois),
     nth0(Coluna, LinhaListaDepois, CoordDepois),
     getElemEspecial(CoordDepois, Outro2),
     Outro2 \= Char).

% Regras para bombas

tiroBombaMedia(Tabela0, L, C, Tabela5, TotalMoedasGanhas) :-
    C2 is C - 1,
    C3 is C + 1,
    L2 is L - 1,
    L3 is L + 1,
    mainAtirouNaCoordenada(Tabela0, L, C, Tabela1, MoedasGanhas1),
    mainAtirouNaCoordenada(Tabela1, L, C2, Tabela2, MoedasGanhas2),
    mainAtirouNaCoordenada(Tabela2, L, C3, Tabela3, MoedasGanhas3),
    mainAtirouNaCoordenada(Tabela3, L2, C, Tabela4, MoedasGanhas4),
    mainAtirouNaCoordenada(Tabela4, L3, C, Tabela5, MoedasGanhas5),
    TotalMoedasGanhas is MoedasGanhas1 + MoedasGanhas2 + MoedasGanhas3 + MoedasGanhas4 + MoedasGanhas5.

tiroBombaGrande(Tabela0, L, C, Tabela5, TotalMoedasGanhas) :-
    C2 is C - 1,
    C3 is C + 1,
    L2 is L - 1,
    L3 is L + 1,
    tiroBombaMedia(Tabela0, L, C, Tabela1, MoedasGanhas1),
    mainAtirouNaCoordenada(Tabela1, L2, C2, Tabela2, MoedasGanhas2),
    mainAtirouNaCoordenada(Tabela2, L3, C2, Tabela3, MoedasGanhas3),
    mainAtirouNaCoordenada(Tabela3, L2, C3, Tabela4, MoedasGanhas4),
    mainAtirouNaCoordenada(Tabela4, L3, C3, Tabela5, MoedasGanhas5),
    TotalMoedasGanhas is MoedasGanhas1 + MoedasGanhas2 + MoedasGanhas3 + MoedasGanhas4 + MoedasGanhas5.

atirouNaMina(Tabela1, L, C, Tabela5, TotalMoedasGanhas) :-
    C2 is C - 1,
    C3 is C + 1,
    L2 is L - 1,
    L3 is L + 1,
    mainAtirouNaCoordenada(Tabela1, L, C2, Tabela2, MoedasGanhas2),
    mainAtirouNaCoordenada(Tabela2, L, C3, Tabela3, MoedasGanhas3),
    mainAtirouNaCoordenada(Tabela3, L2, C, Tabela4, MoedasGanhas4),
    mainAtirouNaCoordenada(Tabela4, L3, C, Tabela5, MoedasGanhas5),
    TotalMoedasGanhas is MoedasGanhas2 + MoedasGanhas3 + MoedasGanhas4 + MoedasGanhas5.

checaSeAcertouNaMina(Coord, MinaFoiAcertada) :-
    getElemEspecial(Coord, ElemEspecial),
    (ElemEspecial == '#' -> MinaFoiAcertada = true ; MinaFoiAcertada = false).

% Regras para lógica do drone

drone(Tabela, C, L, NovaTabela) :-
    visualizacaoDrone(Tabela, C, L, T1),
    C1 is C - 1, visualizacaoDrone(T1, C1, L, T2),
    C2 is C + 1, visualizacaoDrone(T2, C2, L, T3),
    L1 is L - 1, visualizacaoDrone(T3, C, L1, T4),
    L2 is L + 1, visualizacaoDrone(T4, C, L2, T5),
    visualizacaoDrone(T5, C1, L1, T6),
    visualizacaoDrone(T6, C1, L2, T7),
    visualizacaoDrone(T7, C2, L1, T8),
    visualizacaoDrone(T8, C2, L2, NovaTabela).

visualizacaoDrone(Tabela, C, L, NovaTabela) :-
    C >= 0, C =< 11, L >= 0, L =< 11,
    atualizaCoordenada(Tabela, L, C, NovaTabela), !.
visualizacaoDrone(Tabela, _, _, Tabela).  

atualizaCoordenada(Tabela, L, C, NovaTabela) :-
    nth0(L, Tabela, Linha),
    nth0(C, Linha, Coord),
    mascaraViraInterrogacao(Coord, NovoCoord),
    substituiNaLinha(Linha, C, NovoCoord, NovaLinha),
    substituiNaLinha(Tabela, L, NovaLinha, NovaTabela).

mascaraViraInterrogacao(Coord, NovoCoord) :-
    getElemEspecial(Coord, Especial),
    (Especial \= '-' ->
        setMascara(Coord, '?', NovoCoord)
    ;
        setMascara(Coord, '-', NovoCoord)
    ).

desfazVisualizacaoDrone([], []).
desfazVisualizacaoDrone([Linha | T], [NovaLinha | NT]) :-
    desfazLinhaDrone(Linha, NovaLinha),
    desfazVisualizacaoDrone(T, NT).

desfazLinhaDrone([], []).
desfazLinhaDrone([C | T], [NovoC | NT]) :-
    getMascara(C, Masc),
    (Masc \= 'X' -> setMascara(C, 'X', NovoC) ; NovoC = C),
    desfazLinhaDrone(T, NT).

substituiNaLinha(Lista, Index, Elem, NovaLista) :-
    same_length(Lista, NovaLista),
    append(Prefixo, [_|Sufixo], Lista),
    length(Prefixo, Index),
    append(Prefixo, [Elem|Sufixo], NovaLista).