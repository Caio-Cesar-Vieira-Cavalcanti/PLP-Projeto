module Jogo.Iniciar (iniciarJogo) where

import Modelos.Jogo

iniciarJogo :: String
iniciarJogo nomeJogador = loopJogo $ inicializarJogo nomeJogador

-- Carregamento de um jogo, recebendo o índice do estado que o jogador deseja jogar
{-
carregarJogo :: Int
carregarJogo slot = loopJogo $ pegaEstado slot
-}

-- Lógica de loop do jogo com as funções de entrada e saída
loopJogo :: Jogo -> IO ()
loopJogo jogo = putStr "-"