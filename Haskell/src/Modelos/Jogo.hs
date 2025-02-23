module Modelos.Jogo (Jogo (..), iniciarJogador, iniciarMercado, iniciarTabela) where

import Modelos.Jogador
import Modelos.Mercado
import Modelos.Tabuleiro

data Jogo = Jogo {
    jogador :: Jogador,
    mercado :: Mercado,
    tabela :: Tabela
}

-- Funções auxiliares de inicialização

iniciarJogador :: String -> Jogador
iniciarJogador nome = Jogador nome 0 30 0 0 0

iniciarMercado :: Mercado
iniciarMercado = Mercado 250 400 350

iniciarTabela :: Tabela
iniciarTabela = geraTabela 