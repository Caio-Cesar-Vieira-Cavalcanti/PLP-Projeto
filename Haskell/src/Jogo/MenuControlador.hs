module Jogo.MenuControlador (iniciarMenu) where

import qualified UI.Menu as Menu
import qualified UI.UtilsUI as UtilsUI
import Modelos.Jogo
import UI.HUD
import UI.UtilsUI
import Modelos.Mercado (comprarItem)
import System.Console.ANSI (clearScreen)

iniciarMenu :: IO ()
iniciarMenu = do
  clearScreen 
  Menu.logoMenu
  opcaoEnter <- getLine
  clearScreen

  Menu.opcoesMenu
  opcao <- getLine
  processarOpcao opcao

processarOpcao :: String -> IO ()
processarOpcao "1" = do
  -- Executar a lógica de inicialização do jogo
  clearScreen
  Menu.novoJogo
  nomeJogador <- getLine
  iniciarJogo nomeJogador
processarOpcao "2" = do
  -- Executar a lógica de carregamento do jogo, num determinado estado
  clearScreen
  Menu.carregarJogo
  slot <- getLine
  case slot of 
    _ | slot `elem` ["1", "2", "3"] -> do
      clearScreen 
      carregarJogo slot
    _ | slot `elem` ["V", "v"] -> do
      iniciarMenu
    _ -> do
      clearScreen
      processarOpcao "2"
processarOpcao "3" = do
  clearScreen
  Menu.historiaJogo
  processarSubOpcao
processarOpcao "4" = do
  clearScreen
  Menu.regrasJogo
  processarSubOpcao
processarOpcao "5" = do
  clearScreen
  Menu.creditosJogo
  processarSubOpcao
processarOpcao "6" = do
    putStrLn UtilsUI.confirmacao
    opcao <- getLine
    case opcao of 
        op | op `elem` ["S", "s"] -> do
            clearScreen
            putStrLn "Saindo do jogo..."
        _ -> do
            clearScreen
            subMenu
processarOpcao _ = do
  putStrLn UtilsUI.opcaoInvalida
  opcao <- getLine
  processarOpcao opcao
  
-- Funções auxiliares

subMenu :: IO ()
subMenu = do
    Menu.opcoesMenu
    opcao <- getLine
    processarOpcao opcao

processarSubOpcao :: IO ()
processarSubOpcao = do
    opcao <- getLine
    case opcao of
        op | op `elem` ["V", "v"] -> iniciarMenu
        _ -> do
            putStr UtilsUI.voltarMenu
            processarSubOpcao

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
    opcao <- getLine
    processarOpcaoLoop opcao jogo

processarOpcaoLoop :: String -> Jogo -> IO ()
processarOpcaoLoop "1" jogo = do
  -- To Do
  loopJogo jogo
processarOpcaoLoop "2" jogo = do
  -- To Do
  loopJogo jogo
processarOpcaoLoop "3" jogo = do
  -- To Do
  loopJogo jogo
processarOpcaoLoop "4" jogo = do
  -- To Do
  loopJogo jogo
processarOpcaoLoop "m" jogo = do
  clearScreen
  UI.HUD.mercadoScreen jogo
  item <- getLine
  let jogador = getJogador jogo
  let mercado = getMercado jogo
  let novoJogador = Modelos.Mercado.comprarItem jogador mercado item
  let novoJogo = setJogador novoJogador jogo  
  clearScreen
  loopJogo novoJogo
processarOpcaoLoop "s" jogo = do
  clearScreen
  UI.HUD.saveJogoScreen
  slot <- getLine
  let caminho = "src/BD/save" ++ slot ++ ".json"
  if slot `elem` ["1", "2", "3"]
    then do
      clearScreen
      putStrLn UtilsUI.confirmacao
      confirmacaoSalvamento caminho jogo slot
    else do
      clearScreen
      putStrLn UI.UtilsUI.opcaoInvalida
      loopJogo jogo
processarOpcaoLoop "q" _ = do
  clearScreen
  iniciarMenu  
processarOpcaoLoop _ jogo = do
  putStrLn UI.UtilsUI.opcaoInvalida
  opcao <- getLine
  processarOpcaoLoop opcao jogo

confirmacaoSalvamento :: FilePath -> Jogo -> String -> IO ()
confirmacaoSalvamento caminho jogo slot = do
  opcao <- getLine
  case opcao of  
    op | op `elem` ["S", "s"] -> do
      clearScreen
      Modelos.Jogo.salvarJogo caminho jogo
      carregarJogo slot  
    _ -> do
      clearScreen
      loopJogo jogo
