module Modelos.Coordenada (Coordenada (..), CoordenadaClass (..)) where

-- Coordenada

class CoordenadaClass c where
  getMascara :: c -> Char
  getElemEspecial :: c -> Char
  getAcertou :: c -> Bool


data Coordenada = Coordenada
  { mascara :: Char,
    elemEspecial :: Char,
    acertou :: Bool
  } deriving (Show)


instance CoordenadaClass Coordenada where
    getMascara (Coordenada mascara elemEspecial acertou) = mascara
    getElemEspecial (Coordenada mascara elemEspecial acertou) = elemEspecial
    getAcertou (Coordenada mascara elemEspecial acertou) = acertou
