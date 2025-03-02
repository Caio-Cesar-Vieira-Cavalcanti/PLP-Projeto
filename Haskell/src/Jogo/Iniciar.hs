module Jogo.Iniciar (iniciarJogo, carregarJogo) where

import Modelos.Jogo

import UI.HUD

import System.Console.ANSI (clearScreen)

iniciarJogo :: String -> IO ()
iniciarJogo nomeJogador = do
    jogo <- inicializarJogo nomeJogador  
    loopJogo jogo  

-- Carregamento de um jogo, recebendo o índice do estado que o jogador deseja jogar
carregarJogo :: FilePath -> IO ()
carregarJogo numero = do
    let caminho = "src/BD/save" ++ numero ++ ".json"
    jogoCarregado <- carregarSave caminho
    case jogoCarregado of
        Just jogo -> loopJogo jogo
        Nothing   -> putStrLn "Erro: Não foi possível carregar o jogo." 

-- Lógica de loop do jogo com as funções de entrada e saída
loopJogo :: Jogo -> IO ()
loopJogo jogo = do
    clearScreen
    mainScreen jogo