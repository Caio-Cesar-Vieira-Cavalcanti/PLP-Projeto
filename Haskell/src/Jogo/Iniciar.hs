module Jogo.Iniciar (iniciarJogo) where

import Modelos.Jogo


iniciarJogo :: String -> Jogo
iniciarJogo nomeJogador = Jogo (iniciarJogador nomeJogador) iniciarMercado iniciarTabela
