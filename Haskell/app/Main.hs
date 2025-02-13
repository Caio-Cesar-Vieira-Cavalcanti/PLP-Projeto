module Main where

import System.Console.ANSI

main :: IO ()
main = do
	putStrLn $ "\ESC[35mmagenta"
