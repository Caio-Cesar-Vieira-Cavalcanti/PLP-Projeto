module Jogador (Jogador(..), JogadorClass(..)) where

-- Jogador

class JogadorClass j where
    getNome :: j -> String
    getMoedas :: j -> Int
    setNome :: j -> String -> j
    setMoedas :: j -> Int -> j

    getBombasPequenas :: j -> Int
    getBombasMedias :: j -> Int
    getBombasGrandes :: j -> Int
    getDroneVisualizador :: j -> Int

    setBombasPequenas :: j -> Int -> j
    setBombasMedias :: j -> Int -> j
    setBombasGrandes :: j -> Int -> j
    setDroneVisualizador :: j -> Int -> j

data Jogador = Jogador
    { nome :: String
    , moedas :: Int
    , bombasPequenas :: Int
    , bombasMedias :: Int
    , bombasGrandes :: Int
    , droneVisualizador :: Int
    } deriving Show

instance JogadorClass Jogador where
    getNome = nome
    getMoedas = moedas
    setNome jogador novoNome = jogador { nome = novoNome }
    setMoedas jogador novasMoedas = jogador { moedas = novasMoedas }

    getBombasPequenas = bombasPequenas
    getBombasMedias = bombasMedias
    getBombasGrandes = bombasGrandes
    getDroneVisualizador = droneVisualizador

    setBombasPequenas jogador novasBombasPequenas = jogador { bombasPequenas = novasBombasPequenas }
    setBombasMedias jogador novasBombasMedias =
        jogador { bombasMedias = novasBombasMedias }
    setBombasGrandes jogador novasBombasGrandes =
        jogador { bombasGrandes = novasBombasGrandes }
    setDroneVisualizador jogador novoDrone =
        jogador { droneVisualizador = novoDrone }
