module Modelos.Bot (Bot (..), BotClass (..)) where

import System.Random (randomRIO)
import Modelos.Coordenada
import Modelos.Tabuleiro

class BotClass b where
  getTabela :: b -> Tabela
  -- getJogada :: b -> (Int, Int) -- Comentado para evitar erros na execução do projeto (remover depois de criar a função na instancia)

data Bot = Bot
  { 
    tabela :: Tabela,
    bombasPequenas :: Int,
    bombasMedias :: Int,
    bombasGrandes :: Int
  }
  deriving (Show)

instance BotClass Bot where
  getTabela = tabela

-- getJogada = {
-- Transforma coordenada randômica (dentre as ainda não acertadas) em acertada e retorna a tupla (x,y)
-- }