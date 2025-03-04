module UI.TelasVitoriaDerrota (winScreen,loseScreen) where

import qualified UI.UtilsUI as UtilsUI 

winScreen:: String -> IO()
winScreen nomeJogador = do
    putStrLn "*                                                               *"
    putStrLn ""
    putStrLn ("        Parabéns "++ nomeJogador ++", Você venceu a            ")
    putStrLn "                  Guerra dos Paradigmas                          "
    putStrLn "            HaskellLand agradece seu heroísmo!                   "
    putStrLn ""
    putStrLn "*                                                                *"
    putStrLn UtilsUI.voltarMenu

loseScreen:: String -> IO()
loseScreen motivoDerrota = do
    putStrLn "*                                                        *"
    putStrLn ""
    putStrLn "                        GAME OVER!                        "
    putStrLn ""
    putStrLn ("          - Motivo da derrota: " ++ motivoDerrota)                    
    putStrLn ""
    putStrLn "*                                                        *"
    putStrLn UtilsUI.voltarMenu