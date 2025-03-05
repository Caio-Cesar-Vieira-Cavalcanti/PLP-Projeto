module UI.TelasVitoriaDerrota (winScreen,loseScreen) where

import qualified UI.UtilsUI as UtilsUI 

-- Tela de Vitória e Derrota

winScreen :: String -> IO ()
winScreen nomeJogador = do
    putStr $ init $ unlines 
        [ "                                                            "
        , "                                                            "
        , "   Parabéns " ++ nomeJogador ++ ", Você venceu a Guerra dos Paradigmas!   "
        , "                                                            "
        , "               HaskellLand agradece seu heroísmo!           "
        , "                                                            "
        , ""
        , ""
        , UtilsUI.voltarMenu
        ]

loseScreen :: String -> IO ()
loseScreen motivoDerrota = do
    putStr $ init $ unlines 
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