module Jogo.Iniciar (iniciarJogo) where

import Modelos.Jogo

import UI.HUD

-- Importações testes (vão ser removidas em breve)
import Modelos.Tabuleiro
import Modelos.Jogador
import Modelos.Bot

import System.Console.ANSI (clearScreen)

iniciarJogo :: String -> IO ()
iniciarJogo nomeJogador = do
    jogo <- inicializarJogo nomeJogador  
    loopJogo jogo  

-- Carregamento de um jogo, recebendo o índice do estado que o jogador deseja jogar
carregarJogo :: FilePath -> IO ()
carregarJogo caminho = do
    jogoCarregado <- carregarSave caminho
    case jogoCarregado of
        Just jogo -> loopJogo jogo
        Nothing   -> putStrLn "Erro: Não foi possível carregar o jogo." 

-- Lógica de loop do jogo com as funções de entrada e saída
loopJogo :: Jogo -> IO ()
loopJogo jogo = do
    -- Limpando a tela a cada troca de turno
    clearScreen

    -- TESTES
    let tabelaJog = getTabelaJog $ getJogador jogo
    let tabelaBot = getTabelaBot $ getBot jogo
    mainScreen tabelaJog tabelaBot
