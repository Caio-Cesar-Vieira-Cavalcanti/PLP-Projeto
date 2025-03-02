module Jogo.MenuControlador (iniciarMenu) where

import qualified UI.Menu as Menu
import qualified UI.UtilsUI as UtilsUI

import Jogo.Iniciar

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
  {- clearScreen
  Menu.carregarJogo
  slot <- getLine
  verificaSlot slot -- Função para verificar o slot inserido pelo jogador - opçõa inválida
  carregarJogo slot
  -}
  putStrLn "teste"
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
