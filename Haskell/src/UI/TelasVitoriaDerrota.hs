module TelasVitoriaDerrota (winScreen,loseScreen) where

import qualified UtilsUI 


--Tela de Vitória

winScreen:: IO()
winScreen = do
    putStrLn "*                                                        *"
    putStrLn "                                            "
    putStrLn ("              Parabéns "++ nome ++", Você venceu a                                 ")
    putStrLn "                  Guerra dos Paradigmas                             "
    putStrLn "            HaskellLand agradece seu heroísmo!                     "
    putStrLn "                                            "
    putStrLn "*                                                        *"
    putStrLn UtilsUI.voltarMenu
        where nome = "Wendel" 
        --Falta otimizar para nomes de tamanhos diferentes.

loseScreen:: IO()
loseScreen = do
    putStrLn "*                                                        *"
    putStrLn "                                            "
    putStrLn "                        GAME OVER!"
    putStrLn "                                              "
    putStrLn ("          - Motivo da derrota: " ++ motivo)                    
    putStrLn "                                            "
    putStrLn "*                                                        *"
    putStrLn UtilsUI.voltarMenu
        where motivo = "Vitória do Oponente" 
        --Falta otimizar para motivos de tamanhos diferentes.

    