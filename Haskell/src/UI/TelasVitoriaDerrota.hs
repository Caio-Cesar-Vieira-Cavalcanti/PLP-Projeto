module UI.TelasVitoriaDerrota (winScreen,loseScreen) where

import qualified UI.UtilsUI as UtilsUI 

winScreen :: String -> IO ()
winScreen nomeJogador = do
    putStrLn $ unlines 
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
    putStrLn $ unlines 
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
