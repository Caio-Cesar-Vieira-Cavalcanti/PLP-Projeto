:- module(bot, [
    getTabelaBot/2,
    getDefaultBot/2,
    getQtdJogadasParaBombaMedia/2,
    getQtdJogadasParaBombaGrande/2,
    getQtdJogadasFeitas/2,
    setTabelaBot/3, 
    setTabelaQtdJogadasParaBombaMedia/3,
    setTabelaQtdJogadasParaBombaGrande/3,
    setQtdJogadasFeitas/3,
    bot_joga/0
]).

:- dynamic bot/4.

% bot(Tabela, QtdJogadasParaBombaMedia, QtdJogadasParaBombaGrande, QtdJogadasFeitas).

% getters
getTabelaBot(bot(Tabela, _, _, _), Tabela).
getQtdJogadasParaBombaMedia(bot(_, QtdJogadasParaBombaMedia, _, _), QtdJogadasParaBombaMedia).
getQtdJogadasParaBombaGrande(bot(_, _, QtdJogadasParaBombaGrande, _), QtdJogadasParaBombaGrande).
getQtdJogadasFeitas(bot(_, _, _, QtdJogadasFeitas), QtdJogadasFeitas).

% setters
setTabelaBot(bot(_, QtdJogadasParaBombaMedia, QtdJogadasParaBombaGrande, QtdJogadasFeitas), NovaTabelaBot, bot(NovaTabelaBot, QtdJogadasParaBombaMedia, QtdJogadasParaBombaGrande, QtdJogadasFeitas)).
setTabelaQtdJogadasParaBombaMedia(bot(Tabela, _, QtdJogadasParaBombaGrande, QtdJogadasFeitas), NovoQtdJogadasParaBombaMedia, bot(Tabela, NovoQtdJogadasParaBombaMedia, QtdJogadasParaBombaGrande, QtdJogadasFeitas)).
setTabelaQtdJogadasParaBombaGrande(bot(Tabela, QtdJogadasParaBombaMedia, _, QtdJogadasFeitas), NovoQtdJogadasParaBombaGrande, bot(Tabela, QtdJogadasParaBombaMedia, NovoQtdJogadasParaBombaGrande, QtdJogadasFeitas)).
setQtdJogadasFeitas(bot(Tabela, QtdJogadasParaBombaMedia, QtdJogadasParaBombaMedia, _), NovoQtdJogadasFeitas, bot(Tabela, QtdJogadasParaBombaMedia, QtdJogadasParaBombaGrande, NovoQtdJogadasFeitas)).

getDefaultBot(Tabela, Bot) :-
    Bot = (Tabela, 5, 10, 0).

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

atirouNaCoordenada(Tabela, X, Y, NovaTabela) :-
    nth0(Y, Tabela, Linha, RestoTabela),
    nth0(X, Linha, coordenada(X, Y, _), RestoLinha),
    nth0(X, NovaLinha, coordenada(X, Y, true), RestoLinha),
    nth0(Y, NovaTabela, NovaLinha, RestoTabela).

aplica_tiros(Tabela, [], Tabela).
aplica_tiros(Tabela, [(X, Y) | Resto], NovaTabela) :-
    atirouNaCoordenada(Tabela, X, Y, TabelaModificada),
    aplica_tiros(TabelaModificada, Resto, NovaTabela).

coordenadaEspecialAcertada(coordenada(_, Elem, true)) :-
    member(Elem, ['S', 'M', 'T']).

coordenadasVizinhas(X, Y, Vizinhos) :-
    findall((NX, NY), (
        member((DX, DY), [(0,1), (1,0), (0,-1), (-1,0)]), % Cima, Direita, Baixo, Esquerda
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
            member((DX, DY), [(0, -1), (0, 1), (-1, 0), (1, 0)]),  % Apenas vizinhos
            NX is X + DX, 
            NY is Y + DY,
            between(0, 11, NX), 
            between(0, 11, NY)
        ),
        Targets).

l((X, Y), Targets):-
    findall((NX, NY), 
        (
            member((DX, DY), [(0, -1), (-1,-1), (-1, 0), (0, 1), (1,1) ,(1, 0),(1,-1), (-1,1)]),  % Apenas vizinhos
            NX is X + DX, 
            NY is Y + DY,
            between(0, 11, NX), 
            between(0, 11, NY)
        ),
        Targets).

bot_joga :-
    getTabelaBot(Tabela),
    coordenadasNaoAcertadas(Tabela, NaoAcertados),
    espacosProximosEspeciais(Tabela, ProximosEspeciaisNaoAcertados),
    random_member(TipoGolpe,['S','S','S','S','S','M','M','L']),
    length(ProximosEspeciaisNaoAcertados,Size),
    (Size>0 -> random_member(Alvo,ProximosEspeciaisNaoAcertados) ; random_member(Alvo,NaoAcertados)), 
    ( TipoGolpe == 'S' -> s(Alvo,Alvos) 
    ; TipoGolpe == 'M' -> m(Alvo,Alvos) 
    ; TipoGolpe == 'L' -> l(Alvo,Alvos) ),
    aplica_tiros(Tabela, Alvos, NovaTabela),
    retract(bot(_)),
    assertz(bot(NovaTabela)).