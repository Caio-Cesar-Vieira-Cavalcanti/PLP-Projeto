module Modelos.Jogo (Jogo (..), inicializarJogo) where

import Modelos.Jogador
import Modelos.Mercado
import Modelos.Tabuleiro
import Modelos.Bot

data Jogo = Jogo {
    jogador :: Jogador,
    bot :: Bot,
    mercado :: Mercado
} deriving Show

inicializarJogo :: String -> Jogo
inicializarJogo nomeJogador = Jogo (iniciarJogador nomeJogador geraTabela) (iniciarBot geraTabela) iniciarMercado 

-- Funções auxiliares de inicialização

iniciarJogador :: String -> Tabela -> Jogador
iniciarJogador nome tabelaJogador = Jogador nome 0 tabelaJogador 30 0 0 0

-- Revisar as quantidades de cada bomba
iniciarBot :: Tabela -> Bot
iniciarBot tabelaBot = Bot tabelaBot 30 3 1

iniciarMercado :: Mercado
iniciarMercado = Mercado 250 400 350

