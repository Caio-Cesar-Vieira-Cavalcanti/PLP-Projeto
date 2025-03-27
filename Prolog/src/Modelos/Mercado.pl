:- module(mercado, [
    getPrecoBM/2, getPrecoBG/2, getPrecoDV/2,
    comprarItem/3
]).

:- use_module('./Jogador.pl').

:- dynamic mercado/3.

% mercado(PrecoBM, PrecoBG, PrecoDV)

% Getters

getPrecoBM(mercado(PrecoBM, _, _), PrecoBM).
getPrecoBG(mercado(_, PrecoBG, _), PrecoBG).
getPrecoDV(mercado(_, _, PrecoDV), PrecoDV).

% Compra de itens

comprarItem(Jogador, Mercado, "1", NovoJogador) :-
    getMoedas(Jogador, Moedas),
    getPrecoBM(Mercado, PrecoBM),
    Moedas >= PrecoBM,
    getBombasMedias(Jogador, BM),
    NovoBM is BM + 1,
    NovoMoedas is Moedas - PrecoBM,
    setBombasMedias(Jogador, NovoBM, TempJogador),
    setMoedas(TempJogador, NovoMoedas, NovoJogador).

comprarItem(Jogador, Mercado, "2", NovoJogador) :-
    getMoedas(Jogador, Moedas),
    getPrecoBG(Mercado, PrecoBG),
    Moedas >= PrecoBG,
    getBombasGrandes(Jogador, BG),
    NovoBG is BG + 1,
    NovoMoedas is Moedas - PrecoBG,
    setBombasGrandes(Jogador, NovoBG, TempJogador),
    setMoedas(TempJogador, NovoMoedas, NovoJogador).

comprarItem(Jogador, Mercado, "3", NovoJogador) :-
    getMoedas(Jogador, Moedas),
    getPrecoDV(Mercado, PrecoDV),
    Moedas >= PrecoDV,
    getDroneVisualizador(Jogador, DV),
    NovoDV is DV + 1,
    NovoMoedas is Moedas - PrecoDV,
    setDroneVisualizador(Jogador, NovoDV, TempJogador),
    setMoedas(TempJogador, NovoMoedas, NovoJogador).

comprarItem(Jogador, _, _, Jogador).