:- module(bot, [
    getTabelaBot/2,
    getDefaultBot/2,
    getQtdJogadasParaBombaMedia/2,
    getQtdJogadasParaBombaGrande/2,
    getQtdJogadasFeitas/2,
    bot_joga/2
]).

:- use_module('./Tabuleiro').

:- dynamic bot/4.

% bot(Tabela, QtdJogadasParaBombaMedia, QtdJogadasParaBombaGrande, QtdJogadasFeitas).

% getters

getTabelaBot(bot(Tabela, _, _, _), Tabela).
getQtdJogadasParaBombaMedia(bot(_, QtdJogadasParaBombaMedia, _, _), QtdJogadasParaBombaMedia).
getQtdJogadasParaBombaGrande(bot(_, _, QtdJogadasParaBombaGrande, _), QtdJogadasParaBombaGrande).
getQtdJogadasFeitas(bot(_, _, _, QtdJogadasFeitas), QtdJogadasFeitas).
getDefaultBot(Tabela,bot(Tabela, 3, 5, 1)).
getAcertou(coordenada(_, _, Acertou), Acertou).

coordenadaNaoAcertada(Coordenada) :-
    getAcertou(Coordenada, false).

coordenadasNaoAcertadas(Tabela, Coordenadas) :-
    findall((X, Y), 
        (
            between(0, 11, Y), 
            between(0, 11, X),
            nth0(Y, Tabela, Linha),
            nth0(X, Linha, Celula),
            coordenadaNaoAcertada(Celula)
        ), 
        Coordenadas).

substitui_na_lista(0, Elem, [_|Tail], [Elem|Tail]).
substitui_na_lista(Index, Elem, [Head|Tail], [Head|NovaTail]) :-
    Index > 0,
    Index1 is Index - 1,
    substitui_na_lista(Index1, Elem, Tail, NovaTail).

atirouNaCoordenada(Tabela, X, Y, NovaTabela) :-
    nth0(Y, Tabela, Linha),
    nth0(X, Linha, coordenada(_, Elem, _)),
    NovaCoord = coordenada(X, Elem, true),
    substitui_na_lista(X, NovaCoord, Linha, NovaLinha),
    substitui_na_lista(Y, NovaLinha, Tabela, NovaTabela).

aplica_tiros(Tabela, [], Tabela).
aplica_tiros(Tabela, [(X, Y) | Resto], NovaTabela) :-
    mainAtirouNaCoordenada(Tabela, Y, X, TabelaModificada, _),
    aplica_tiros(TabelaModificada, Resto, NovaTabela).

coordenadaEspecialAcertada(coordenada(_, Elem, true)) :-
    member(Elem, ['S', 'M', 'T']).

coordenadasVizinhas(X, Y, Vizinhos) :-
    findall((NX, NY), (
        member((DX, DY), [(0,1), (1,0), (0,-1), (-1,0)]), 
        NX is X + DX, NY is Y + DY,
        between(0, 11, NX), between(0, 11, NY)
    ), Vizinhos).

espacosProximosEspeciais(Tabela, EspacosVizinhos) :-
    findall((NX, NY), (
        between(0, 11, Y), between(0, 11, X),
        nth0(Y, Tabela, Linha), nth0(X, Linha, Celula),
        coordenadaEspecialAcertada(Celula),
        coordenadasVizinhas(X, Y, Vizinhos),
        member((NX, NY), Vizinhos),
        nth0(NY, Tabela, LinhaV), nth0(NX, LinhaV, Vizinho),
        getAcertou(Vizinho, false)
    ), EspacosVizinhos).

s(Alvo, [Alvo]).
m((X, Y), Targets) :-
    findall((NX, NY), 
        (
            member((DX, DY), [(0, 0), (0, -1), (0, 1), (-1, 0), (1, 0)]),
            NX is X + DX, 
            NY is Y + DY,
            between(0, 11, NX), 
            between(0, 11, NY)
        ),
        Targets).

l((X, Y), Targets) :-
    findall((NX, NY), 
        (
            member((DX, DY), [(0, 0), (0, -1), (-1,-1), (-1, 0), (0, 1), (1,1), (1, 0), (1,-1), (-1,1)]), 
            NX is X + DX, 
            NY is Y + DY,
            between(0, 11, NX), 
            between(0, 11, NY)
        ),
        Targets).

bot_joga(bot(Tabela, QtdJogadasParaBombaMedia, QtdJogadasParaBombaGrande, QtdJogadasFeitas), bot(NovaTabela,QtdJogadasParaBombaMedia, QtdJogadasParaBombaGrande, NovaQtdJogadasFeitas)) :-

    coordenadasNaoAcertadas(Tabela, NaoAcertados),
    espacosProximosEspeciais(Tabela, ProximosEspeciaisNaoAcertados),

    ( QtdJogadasFeitas mod QtdJogadasParaBombaGrande =:= 0 -> TipoGolpe = 'L' 
    ; QtdJogadasFeitas mod QtdJogadasParaBombaMedia =:= 0 -> TipoGolpe = 'M' 
    ; TipoGolpe = 'S'),

    length(ProximosEspeciaisNaoAcertados,Size),
    (Size>0 -> random_member(Alvo,ProximosEspeciaisNaoAcertados) ; random_member(Alvo,NaoAcertados)), 
    ( TipoGolpe == 'S' -> s(Alvo,Alvos) 
    ; TipoGolpe == 'M' -> m(Alvo,Alvos) 
    ; TipoGolpe == 'L' -> l(Alvo,Alvos) ),
    aplica_tiros(Tabela, Alvos, NovaTabela),
    NovaQtdJogadasFeitas is QtdJogadasFeitas + 1.