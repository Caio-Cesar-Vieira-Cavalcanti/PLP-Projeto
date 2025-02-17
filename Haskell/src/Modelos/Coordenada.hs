module Modelos.Coordenada (Coordenada(..)) where

data Coordenada = Coordenada {
    valorVerdadeiro :: String, -- String que será revelada quando jogador atacar tal coordenada
    acertou :: Bool
}