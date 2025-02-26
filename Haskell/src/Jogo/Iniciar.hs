module Jogo.Iniciar (iniciarJogo) where

import Modelos.Jogo

iniciarJogo :: String -> IO ()
iniciarJogo nomeJogador = loopJogo $ inicializarJogo nomeJogador

-- Carregamento de um jogo, recebendo o índice do estado que o jogador deseja jogar
{-
carregarJogo :: String -> IO ()
carregarJogo slot = loopJogo $ pegaEstado slot -- Funçõa que retorna o estado de jogo do DB a partir de um slot
-}

-- Lógica de loop do jogo com as funções de entrada e saída
loopJogo :: Jogo -> IO ()
loopJogo jogo = putStr "-"