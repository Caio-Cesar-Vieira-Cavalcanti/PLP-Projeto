:- module(game_over, [
    verificaVitoriaDerrotaPlayer/2,
    checaSePlayerMatouTodosAmigos/2,
    checaSeBotMatouTodosAmigos/2,
    checaSePlayerMatouTodosInimigos/2,
    checaSeBotMatouTodosInimigos/2,
    checaSeGastouTodasBombas/2
]).

:- use_module('../Modelos/Bot').
:- use_module('../Modelos/Jogador').
:- use_module('../Modelos/Jogo').
:- use_module('../Modelos/Tabuleiro').
:- use_module('../UI/TelasVitoriaDerrota').

verificaVitoriaDerrotaPlayer(Jogo, true) :-
    checaSePlayerMatouTodosAmigos(Jogo, true),
    loseScreen('Perda de Sanidade - Você atingiu todos os espaços amigos.'), !.

verificaVitoriaDerrotaPlayer(Jogo, true) :-
    getJogador(Jogo, Jogador),
    getNome(Jogador, NomeJogador),
    checaSePlayerMatouTodosInimigos(Jogo, true),
    winScreen(NomeJogador), !.

verificaVitoriaDerrotaPlayer(Jogo, true) :-
    checaSeGastouTodasBombas(Jogo, true),
    loseScreen('Falta de Recursos - Você não tem bombas.'), !.

verificaVitoriaDerrotaPlayer(Jogo, true) :-
    getJogador(Jogo, Jogador),
    getNome(Jogador, NomeJogador),
    checaSeBotMatouTodosAmigos(Jogo, true),
    winScreen(NomeJogador), !.

verificaVitoriaDerrotaPlayer(Jogo, true) :-
    checaSeBotMatouTodosInimigos(Jogo, true),
    loseScreen('O Imperador de Prologia derrotou o seu exército.'), !.

verificaVitoriaDerrotaPlayer(_, false).

checaSePlayerMatouTodosAmigos(Jogo, MatouTodosAmigos) :-
    getJogador(Jogo, Jogador),
    getTabelaJogador(Jogador, TabelaJogador),
    contabilizarAmigos(TabelaJogador, AmigosAtingidos),
    (
        AmigosAtingidos =:= 3 ->
        MatouTodosAmigos = true ;
        MatouTodosAmigos = false
    ).

checaSeBotMatouTodosAmigos(Jogo, MatouTodosAmigos) :-
    getBot(Jogo, Bot),
    getTabelaBot(Bot, TabelaBot),
    contabilizarAmigos(TabelaBot, AmigosAtingidos),
    (
        AmigosAtingidos =:= 3 ->
        MatouTodosAmigos = true ;
        MatouTodosAmigos = false
    ).

checaSePlayerMatouTodosInimigos(Jogo, MatouTodosInimigos) :-
    getJogador(Jogo, Jogador),
    getTabelaJogador(Jogador, TabelaJogador),
    contabilizarInimigos(TabelaJogador, InimigosAtingidos),
    (
        InimigosAtingidos =:= 6 ->
        MatouTodosInimigos = true ;
        MatouTodosInimigos = false
    ).

checaSeBotMatouTodosInimigos(Jogo, MatouTodosInimigos) :-
    getBot(Jogo, Bot),
    getTabelaBot(Bot, TabelaBot),
    contabilizarInimigos(TabelaBot, InimigosAtingidos),
    (
        InimigosAtingidos =:= 6 ->
        MatouTodosInimigos = true ;
        MatouTodosInimigos = false
    ).

checaSeGastouTodasBombas(Jogo, GastouTodasBombas) :-
    getJogador(Jogo, Jogador),
    getBombasPequenas(Jogador, BombasPequenas),
    getBombasMedias(Jogador, BombasMedias),
    getBombasGrandes(Jogador, BombasGrandes),
    (
        BombasPequenas =:= 0,
        BombasMedias =:= 0,
        BombasGrandes =:= 0 -> 
        GastouTodasBombas = true ; 
        GastouTodasBombas = false
    ).