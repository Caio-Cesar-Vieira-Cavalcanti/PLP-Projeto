:- module(jogo, [
    inicializarJogo/2, carregarSave/2, salvarJogo/2, 
    setJogador/3, setBot/3, 
    getJogador/2, getBot/2, 
    getMercado/2, getDataJogo/2
]).

:- use_module('./Jogador').
:- use_module('./Mercado').
:- use_module('./Tabuleiro').
:- use_module('./Bot.pl').
:- use_module(library(time)).  
:- use_module(library(filesex)).

:- dynamic jogo/4.

% jogo(Jogador, Bot, Mercado, DataJogo) // Em teoria, falta o Bot.

% Getters

getJogador(jogo(Jogador, _, _, _), Jogador).
getBot(jogo(_, Bot, _, _), Bot).
getMercado(jogo(_, _, Mercado, _), Mercado).
getDataJogo(jogo(_, _, _, DataJogo), DataJogo).

% Setters

setJogador(jogo(_, Bot, Mercado, DataJogo), NovoJogador, jogo(NovoJogador, Bot, Mercado, DataJogo)).
setBot(jogo(Jogador, _, Mercado, DataJogo), NovoBot, jogo(Jogador, NovoBot, Mercado, DataJogo)).

% Salvar jogo em arquivo (../BD/save{num})

salvarJogo(Caminho, Jogo) :-
    open(Caminho, write, Stream),
    write_canonical(Stream, Jogo), 
    write(Stream, '.\n'),  
    close(Stream).

% Carregar jogo de arquivo

carregarSave(Caminho, Jogo) :-
    ( exists_file(Caminho) ->
        open(Caminho, read, Stream),
        read(Stream, Jogo),  
        close(Stream)
    ;   fail 
    ).

% Inicialização do jogo
% Tirar o _ ao fazer o Bot e substituir por ele

inicializarJogo(NomeJogador, jogo(Jogador, Bot, Mercado, DataJogo)) :-
    get_time(TempoAtual),
    format_time(atom(DataJogo), '%Y-%m-%dT%H:%M:%S', TempoAtual),
    geraTabuleiroDispor(TabelaJogador),
    geraTabuleiroDispor(TabelaBot),
    iniciarJogador(NomeJogador, TabelaJogador, Jogador),
    iniciarBot(TabelaBot, Bot),
    Mercado = mercado(250, 400, 350).

% Inicializar Jogador

iniciarJogador(Nome, Tabela, jogador(Nome, 0, Tabela, 55, 2, 1, 0)).

% Inicializar Bot

iniciarBot(Tabela, Bot) :- getDefaultBot(Tabela, Bot).