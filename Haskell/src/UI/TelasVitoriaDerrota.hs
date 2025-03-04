module UI.TelasVitoriaDerrota (winScreen,loseScreen) where

import qualified UI.UtilsUI as UtilsUI 

winScreen :: String -> IO ()
winScreen nomeJogador = do
    putStr $ unlines 
        [ "                                                            "
        , "                                                            "
        , "   Parabéns " ++ nomeJogador ++ ", Você venceu a Guerra dos Paradigmas!   "
        , "                                                            "
        , "       HaskellLand agradece seu heroísmo!                   "
        , "                                                            "
        , ""
        , ""
        , UtilsUI.voltarMenu
        ]

loseScreen :: String -> IO ()
loseScreen motivoDerrota = do
    putStr $ unlines 
        [ "                                                            "
        , "                                                            "
        , "                       GAME OVER!                           "
        , "                                                            "
        , "    - Motivo da derrota: " ++ motivoDerrota ++ "            "
        , "                                                            "
        , "                                                            "
        , ""
        , UtilsUI.voltarMenu
        ]
