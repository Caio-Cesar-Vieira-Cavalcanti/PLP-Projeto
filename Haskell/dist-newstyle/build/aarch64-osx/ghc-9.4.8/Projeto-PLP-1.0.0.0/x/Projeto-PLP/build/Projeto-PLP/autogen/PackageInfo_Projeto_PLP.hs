{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module PackageInfo_Projeto_PLP (
    name,
    version,
    synopsis,
    copyright,
    homepage,
  ) where

import Data.Version (Version(..))
import Prelude

name :: String
name = "Projeto_PLP"
version :: Version
version = Version [1,0,0,0] []

synopsis :: String
synopsis = "Projeto da disciplina Paradigmas de Linguagens de Programa\231\227o"
copyright :: String
copyright = ""
homepage :: String
homepage = ""
