{-# LANGUAGE DeriveGeneric #-}

module Modelos.Bot (Bot (..), BotClass (..)) where

import Modelos.Coordenada
import Modelos.Tabuleiro

import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON)

class BotClass b where
  getDefaultBot :: Tabela -> b
  getTabelaBot :: b -> Tabela
  getJogada :: b -> Int -> [(Int, Int)]
  jogar :: b -> Int -> b

data Bot = Bot
  {
    getTabela :: Tabela,
    m, n :: Int, -- Quantas jogadas para bombas média e grande
    jogadasFeitas :: Int
  }
  deriving (Show, Generic)

instance BotClass Bot where
  getDefaultBot t = Bot t 5 10 0 -- m = 5, n = 10, jogadasFeitas = 0
  getTabelaBot = getTabela
  jogar bot r = bot { getTabela = novaTabela, jogadasFeitas = jogadasFeitas bot + 1 }
    where
      jogadas = getJogada bot r
      novaTabela = foldl (\t (x,y) -> fst (atirouNaCoordenada t x y)) (getTabela bot) jogadas

  getJogada bot i =
    let tabelaAtual = getTabelaBot bot
        jogadas = jogadasFeitas bot
        coordenadasNaoAcertadas = [(x, y) | y <- [0..11], x <- [0..11], not (getAcertou ((tabelaAtual !! y) !! x))]
    in if null coordenadasNaoAcertadas
        then []
        else let jogadaAleatoria = coordenadasNaoAcertadas !! (i `mod` length coordenadasNaoAcertadas)
             in if jogadas `mod` (n bot) == 0
                then bombaGrande jogadaAleatoria
                else if jogadas `mod` (m bot) == 0
                    then bombaMedia jogadaAleatoria
                    else [jogadaAleatoria]

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
