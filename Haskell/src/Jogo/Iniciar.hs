module Jogo.Iniciar (iniciarJogo) where

import Modelos.Jogo

iniciarJogo :: String -> Jogo
iniciarJogo nomeJogador = loopJogo inicializarJogo nomeJogador

-- Lógica de loop do jogo com as funções de entrada e saída
loopJogo :: Jogo -> IO ()
loopJogo jogo = putStr "-"