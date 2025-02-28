{-# LANGUAGE DeriveGeneric #-}

module Modelos.Coordenada (Coordenada (..), CoordenadaClass (..)) where

import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON, encode, decode, eitherDecode)

-- Coordenada

class CoordenadaClass c where
  getMascara :: c -> Char
  getElemEspecial :: c -> Char
  getAcertou :: c -> Bool


data Coordenada = Coordenada
  { mascara :: Char
  , elemEspecial :: Char
  , acertou :: Bool
  } deriving (Show, Generic)


instance CoordenadaClass Coordenada where
    getMascara (Coordenada mascara elemEspecial acertou) = mascara
    getElemEspecial (Coordenada mascara elemEspecial acertou) = elemEspecial
    getAcertou (Coordenada mascara elemEspecial acertou) = acertou

instance ToJSON Coordenada
instance FromJSON Coordenada