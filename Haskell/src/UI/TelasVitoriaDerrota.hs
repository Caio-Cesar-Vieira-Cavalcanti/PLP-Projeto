module UI.TelasVitoriaDerrota (winScreen,loseScreen) where

import qualified UI.UtilsUI as UtilsUI 

winScreen:: String -> IO()
winScreen nome = do
    putStrLn "*                                                        *"
    putStrLn ""
    putStrLn ("              Parabéns "++ nome ++", Você venceu a       ")
    putStrLn "                  Guerra dos Paradigmas                   "
    putStrLn "            HaskellLand agradece seu heroísmo!            "
    putStrLn ""
    putStrLn "*                                                        *"
    putStrLn UtilsUI.voltarMenu

loseScreen:: String -> IO()
loseScreen motivo = do
    putStrLn "*                                                        *"
    putStrLn ""
    putStrLn "                        GAME OVER!                        "
    putStrLn ""
    putStrLn ("          - Motivo da derrota: " ++ motivo)                    
    putStrLn ""
    putStrLn "*                                                        *"
    putStr UtilsUI.voltarMenu