module Modelos.Jogo (Jogo (..), iniciarJogador, iniciarMercado, iniciarTabela) where

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

iniciarBot :: Tabela -> Bot
iniciarBot tabelaBot = Bot tabelaBot

iniciarMercado :: Mercado
iniciarMercado = Mercado 250 400 350

