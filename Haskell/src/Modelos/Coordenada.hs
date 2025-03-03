{-# LANGUAGE DeriveGeneric #-}

module Modelos.Coordenada (Coordenada (..), CoordenadaClass (..)) where

import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON, encode, decode, eitherDecode)

class CoordenadaClass c where
  getMascara :: c -> Char
  getElemEspecial :: c -> Char
  getAcertou :: c -> Bool

  setElem :: c -> Char -> c
  setAcertou :: c -> c


data Coordenada = Coordenada
  { mascara :: Char
  , elemEspecial :: Char
  , acertou :: Bool
  } deriving (Show, Generic)


instance CoordenadaClass Coordenada where
    getMascara = mascara
    getElemEspecial = elemEspecial
    getAcertou = acertou

    setElem coordenada elemento = coordenada { elemEspecial = elemento }
    setAcertou coordenada = coordenada { acertou = True }

instance ToJSON Coordenada
instance FromJSON Coordenada