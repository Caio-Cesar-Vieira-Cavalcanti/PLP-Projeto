{-# LANGUAGE DeriveGeneric #-}

module Modelos.Bot (Bot (..), BotClass (..)) where

import Modelos.Coordenada
import Modelos.Tabuleiro

import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON, encode, decode, eitherDecode)

import System.Random (randomRIO)

m, n :: Int
m = 5; -- Quantas jogadas para uma bomba média
n = 10; -- Quantas jogadas para uma bomba grande

class BotClass b where
  getTabelaBot :: Bot -> Tabela 
  getJogada :: Bot -> IO [(Int, Int)]


data Bot = Bot
  { 
    tabela :: Tabela,
    bombasPequenas :: Int,
    bombasMedias :: Int,
    bombasGrandes :: Int,
    jogadasFeitas :: Int -- Contador de jogadas
  }
  deriving (Show, Generic)

instance BotClass Bot where
  getTabelaBot = tabela
  getJogada bot = do
      let tabelaAtual = getTabelaBot bot
          jogadas = jogadasFeitas bot
          coordenadasNaoAcertadas = [(x, y) | y <- [0..11], x <- [0..11], not (getAcertou ((tabelaAtual !! y) !! x))]
      
      if null coordenadasNaoAcertadas
          then return [(15, 15)] -- Retorna (15, 15) se não houver coordenadas disponíveis
          else do
              i <- randomRIO (0, length coordenadasNaoAcertadas - 1)
              let jogadaAleatoria = coordenadasNaoAcertadas !! i

              -- Verifica a bombas especial a ser aplicada
              if jogadas `mod` n == 0
                  then return (bombaGrande jogadaAleatoria)
              else if jogadas `mod` m == 0
                  then return (bombaMedia jogadaAleatoria)
              else return [jogadaAleatoria]

-- Função privada para aplicar bomba no padrão "+"
bombaMedia :: (Int, Int) -> [(Int, Int)]
bombaMedia (x, y) = filter indiceValido [ (x-1, y), (x, y), (x+1, y), (x, y-1), (x, y+1)]

-- Função privada para aplicar bomba no padrão "*"
bombaGrande :: (Int, Int) -> [(Int, Int)]
bombaGrande (x, y) = filter indiceValido [(i, j) | i <- [(x-1)..(x+1)], j <- [(y-1)..(y+1)]]


indiceValido :: (Int,Int) -> Bool
indiceValido (x, y) = (x >= 0) && (x <= 11) && (y >= 0) && (y <= 11)


instance ToJSON Bot
instance FromJSON Bot