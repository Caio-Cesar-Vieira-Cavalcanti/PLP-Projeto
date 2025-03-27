:- module(jogador, [
    getNome/2, getMoedas/2, getTabelaJogador/2,
    getBombasPequenas/2, getBombasMedias/2, getBombasGrandes/2, getDroneVisualizador/2,
    setNome/3, setMoedas/3, setTabelaJogador/3,
    setBombasPequenas/3, setBombasMedias/3, setBombasGrandes/3, setDroneVisualizador/3
]).

:- dynamic jogador/7.

% jogador(Nome, Moedas, Tabela, BombasPequenas, BombasMedias, BombasGrandes, DroneVisualizador)

% Getters

getNome(jogador(Nome, _, _, _, _, _, _), Nome).
getMoedas(jogador(_, Moedas, _, _, _, _, _), Moedas).
getTabelaJogador(jogador(_, _, Tabela, _, _, _, _), Tabela).
getBombasPequenas(jogador(_, _, _, BombasPequenas, _, _, _), BombasPequenas).
getBombasMedias(jogador(_, _, _, _, BombasMedias, _, _), BombasMedias).
getBombasGrandes(jogador(_, _, _, _, _, BombasGrandes, _), BombasGrandes).
getDroneVisualizador(jogador(_, _, _, _, _, _, DroneVisualizador), DroneVisualizador).

% Setters

setNome(jogador(_, Moedas, Tabela, BP, BM, BG, DV), NovoNome, jogador(NovoNome, Moedas, Tabela, BP, BM, BG, DV)).
setMoedas(jogador(Nome, _, Tabela, BP, BM, BG, DV), NovasMoedas, jogador(Nome, NovasMoedas, Tabela, BP, BM, BG, DV)).
setTabelaJogador(jogador(Nome, Moedas, _, BP, BM, BG, DV), NovaTabela, jogador(Nome, Moedas, NovaTabela, BP, BM, BG, DV)).

setBombasPequenas(jogador(Nome, Moedas, Tabela, _, BM, BG, DV), NovasBP, jogador(Nome, Moedas, Tabela, NovasBP, BM, BG, DV)).
setBombasMedias(jogador(Nome, Moedas, Tabela, BP, _, BG, DV), NovasBM, jogador(Nome, Moedas, Tabela, BP, NovasBM, BG, DV)).
setBombasGrandes(jogador(Nome, Moedas, Tabela, BP, BM, _, DV), NovasBG, jogador(Nome, Moedas, Tabela, BP, BM, NovasBG, DV)).
setDroneVisualizador(jogador(Nome, Moedas, Tabela, BP, BM, BG, _), NovoDV, jogador(Nome, Moedas, Tabela, BP, BM, BG, NovoDV)).
