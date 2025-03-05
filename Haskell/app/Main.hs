module Main where

import Jogo.MenuControlador as Jogo

import System.IO

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    Jogo.iniciarMenu