module Jogo.GameOver (verificaVitoriaDerrotaPlayer) where

import UI.TelasVitoriaDerrota as VitoriaDerrota

import Modelos.Jogo
import Modelos.Bot
import Modelos.Tabuleiro as Tabuleiro
import Modelos.Jogador as Jogador

import System.Console.ANSI (clearScreen)

-- Funções para checar as condições de fim do jogo

verificaVitoriaDerrotaPlayer :: Jogo -> IO Bool
verificaVitoriaDerrotaPlayer jogo = do
  if checaSePlayerMatouTodosAmigos jogo
    then do
      clearScreen
      VitoriaDerrota.loseScreen "Perda de Sanidade - Você atingiu todos os espaços amigos."
      return True  
  else if checaSePlayerMatouTodosInimigos jogo
    then do
      clearScreen
      VitoriaDerrota.winScreen nomeJogador
      return True  
  else if checaSeGastouTodasBombas jogo
    then do
      clearScreen
      VitoriaDerrota.loseScreen "Falta de Recursos - Você não tem bombas."
      return True 
  else if checaSeBotMatouTodosAmigos jogo
      then do
        clearScreen
        VitoriaDerrota.winScreen nomeJogador
        return True
  else if checaSeBotMatouTodosInimigos jogo
      then do
        clearScreen
        VitoriaDerrota.loseScreen "O Imperador de Prologia derrotou o seu exército."
        return True
  else return False  
    where nomeJogador = getNome (getJogador jogo)

-- Funções auxiliares

checaSePlayerMatouTodosAmigos :: Jogo -> Bool
checaSePlayerMatouTodosAmigos jogo = contabilizarAmigos tabelaJogador == 3
  where
    jogador = getJogador jogo
    tabelaJogador = tabela (jogador)  

checaSePlayerMatouTodosInimigos :: Jogo -> Bool
checaSePlayerMatouTodosInimigos jogo = contabilizarInimigos tabelaJogador == 6
  where
    jogador = getJogador jogo
    tabelaJogador = tabela (jogador)  

checaSeGastouTodasBombas :: Jogo -> Bool 
checaSeGastouTodasBombas jogo = getBombasPequenas (jogador) == 0 && getBombasMedias (jogador) == 0 && getBombasGrandes (jogador) == 0 
  where jogador = getJogador jogo

checaSeBotMatouTodosAmigos :: Jogo -> Bool
checaSeBotMatouTodosAmigos jogo = contabilizarAmigos tabelaBot == 3
  where
    bot = getBot jogo
    tabelaBot = getTabelaBot bot

checaSeBotMatouTodosInimigos :: Jogo -> Bool
checaSeBotMatouTodosInimigos jogo = contabilizarInimigos tabelaBot == 6
  where 
    bot = getBot jogo
    tabelaBot = getTabelaBot bot