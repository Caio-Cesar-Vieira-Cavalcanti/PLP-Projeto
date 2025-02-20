module Mercado (Mercado(..), MercadoClass(..)) where

import Jogador (Jogador(..), JogadorClass(..))

-- Mercado

class MercadoClass m where 
    getPrecoBP :: m -> Int
    getPrecoBM :: m -> Int
    getPrecoBG :: m -> Int
    getPrecoDV :: m -> Int

    comprarItem :: Jogador -> m -> String -> Jogador  

data Mercado = Mercado 
    { precoBombasMedias :: Int
    , precoBombasGrandes :: Int
    , precoDroneVisualizador :: Int
    } deriving Show

instance MercadoClass Mercado where
    getPrecoBP = precoBombasPequenas
    getPrecoBM = precoBombasMedias
    getPrecoBG = precoBombasGrandes
    getPrecoDV = precoDroneVisualizador

    comprarItem jogador mercado item = case item of
        "bombaPequena" -> 
            if getMoedas jogador >= getPrecoBP mercado
                then setMoedas (setBombasPequenas jogador (getBombasPequenas jogador + 1)) (getMoedas jogador - getPrecoBP mercado)
                else jogador  
        "bombaMedia" -> 
            if getMoedas jogador >= getPrecoBM mercado
                then setMoedas (setBombasMedias jogador (getBombasMedias jogador + 1)) (getMoedas jogador - getPrecoBM mercado)
                else jogador
        "bombaGrande" -> 
            if getMoedas jogador >= getPrecoBG mercado
                then setMoedas (setBombasGrandes jogador (getBombasGrandes jogador + 1)) (getMoedas jogador - getPrecoBG mercado)
                else jogador
        "drone" -> 
            if getMoedas jogador >= getPrecoDV mercado
                then setMoedas (setDroneVisualizador jogador (getDroneVisualizador jogador + 1)) (getMoedas jogador - getPrecoDV mercado)
                else jogador
        naoExiste -> jogador  