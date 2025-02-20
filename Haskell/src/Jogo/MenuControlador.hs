module Jogo.MenuControlador (iniciarMenu) where

import qualified UI.Menu as Menu
import qualified UI.UtilsUI as UtilsUI
import System.Console.ANSI (clearScreen)
import Jogo.Iniciar

iniciarMenu :: IO ()
iniciarMenu = do
  clearScreen 
  Menu.logoMenu
  opcao <- getLine
  clearScreen

  Menu.opcoesMenu
  opcao <- getLine
  processarOpcao opcao

processarOpcao :: String -> IO ()
processarOpcao "1" = do
  clearScreen
  Menu.novoJogo
  nomeJogador <- getLine
  iniciarJogo (read nomeJogador)
  -- Executar a lógica de inicialização do jogo
processarOpcao "2" = do
  clearScreen
  Menu.carregarJogo
  -- Executar a lógica de carregamento do jogo, num determinado estado
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