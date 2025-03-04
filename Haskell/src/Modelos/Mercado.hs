{-# LANGUAGE DeriveGeneric #-}

module Modelos.Mercado (Mercado(..), MercadoClass(..)) where

import Modelos.Jogador (Jogador(..), JogadorClass(..))

import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON, encode, decode, eitherDecode)

class MercadoClass m where 
    getPrecoBM :: m -> Int
    getPrecoBG :: m -> Int
    getPrecoDV :: m -> Int

    comprarItem :: Jogador -> m -> String -> Jogador  

data Mercado = Mercado 
    { precoBombasMedias :: Int
    , precoBombasGrandes :: Int
    , precoDroneVisualizador :: Int
    } deriving (Show, Generic)

instance MercadoClass Mercado where
    getPrecoBM = precoBombasMedias
    getPrecoBG = precoBombasGrandes
    getPrecoDV = precoDroneVisualizador

    comprarItem jogador mercado item = case item of
        "1" -> 
            if getMoedas jogador >= getPrecoBM mercado
                then setMoedas (setBombasMedias jogador (getBombasMedias jogador + 1)) (getMoedas jogador - getPrecoBM mercado)
                else jogador
        "2" -> 
            if getMoedas jogador >= getPrecoBG mercado
                then setMoedas (setBombasGrandes jogador (getBombasGrandes jogador + 1)) (getMoedas jogador - getPrecoBG mercado)
                else jogador
        "3" -> 
            if getMoedas jogador >= getPrecoDV mercado
                then setMoedas (setDroneVisualizador jogador (getDroneVisualizador jogador + 1)) (getMoedas jogador - getPrecoDV mercado)
                else jogador
        naoExiste -> jogador  

instance ToJSON Mercado
instance FromJSON Mercado