module UI.HUD (mainScreen, saveJogoScreen, mercadoScreen) where
    
import qualified UI.UtilsUI as Utils

import Modelos.Tabuleiro
import Modelos.Coordenada

{- Falta trocar os dummies  por valores reais passados como argumento -}

-- Tela Principal da HUD 

-- Receber os estado atual do jogo (Jogo)

mainScreen :: Tabela -> Tabela -> IO()
mainScreen tabJog tabBot = do
    let jogador = "Neymar"
    putStrLn ("Jogador: " ++ jogador)
    putStrLn ""
    putStrLn ""

    -- Imprimir as duas tabelas passando o contador 
    imprimiTabelas tabJog tabBot 0

    putStrLn ""
    putStrLn ""

    let inimigosDerrotados = 4
    let inimigosTotais = 10

    putStrLn ("Inimigos: " ++ show inimigosDerrotados ++ "/" ++ show inimigosTotais)


    let espacosAtingidos = 3
    let espacosTotais = 12

    putStrLn ("Espaços especiais: " ++ show espacosAtingidos ++ "/" ++ show espacosTotais)


    let minasOuroAtingidas = 2
    let minasOuroTotais = 5

    putStrLn ("Tesouro: " ++ show minasOuroAtingidas ++ "/" ++ show minasOuroTotais)
    
    putStrLn ""

    mostraInventario
    
    putStrLn ""

    putStrLn "Atalhos: "
    putStrLn "'1' -> Usar bombas pequenas"
    putStrLn "'2' -> Usar bombas médias"
    putStrLn "'3' -> Usar bombas grandes"
    putStrLn "'4' -> Usar o drone visualizador de áreas"
    putStrLn "{COLUNAS}{LINHA} -> Coordenada que deseja atacar; Exemplo: C3"
    putStrLn "'m' -> Acesso ao mercado"
    putStrLn "'s' -> Salvar o jogo no estado atual"
    putStrLn "'q' -> Sair do jogo sem salvar"
    
    putStrLn ""

    putStrLn "> Digite a opção ou coordenadas:"

-- Tela Salvar Jogo

saveJogoScreen :: IO ()
saveJogoScreen = do
    putStrLn "Escolha um slot para salvar:"
    putStrLn ""
    estados <- Utils.saveStates
    putStr estados

-- Tela Mercado 

mercadoScreen :: IO ()
mercadoScreen = do

    putStrLn "  __  __                             _        "
    putStrLn " |  \x5C/  |  ___  _ __  ___  __ _   __| |  ___  "
    putStrLn " | |\x5C/| | / _ \x5C| '__|/ __|/ _` | / _` | / _ \x5C "
    putStrLn " | |  | ||  __/| |  | (__| (_| || (_| || (_) |"
    putStrLn " |_|  |_| \x5C___||_|   \x5C___|\x5C__,_| \x5C__,_| \x5C___/ "

    putStrLn ""

    mostraInventario
    
    putStrLn ""

    putStrLn "Atalhos:"
    
    putStrLn ""

    putStrLn "'1' -> Comprar bombas médias               ($250)"
    putStrLn "'2' -> Comprar bombas grandes              ($400)"
    putStrLn "'3' -> Comprar drone visualizador de áreas ($350)"

    putStrLn ""

    putStr "> Digite o item ou 'v' para voltar:"

-- Funções utilitárias

mostraInventario :: IO ()
mostraInventario = do
    putStrLn "Inventário:"
    
    let bombasPequenas = 3
    let bombasMedias = 1
    let bombasGrandes = 0

    putStrLn ("Bombas pequenas: " ++ show bombasPequenas ++ " | Bombas médias: " ++ show bombasMedias ++ " | Bombas grandes: " ++ show bombasGrandes)

    let drones = 2

    putStrLn ("Drone visualizador de áreas: " ++ show drones)

    putStrLn ""
    
    let moedas = 25

    putStrLn ("Moedas: " ++ show moedas)

-- Refatorar (criar pequenas funções)
-- Evitar o uso de gerar a tabela em string para toda chamada recursiva
imprimiTabelas :: Tabela -> Tabela -> Int -> IO() 
imprimiTabelas tabJog tabBot x = if x >= 12
    then do
        let tabJogStr = geraTabelaStr tabJog
        let linhaTabelaJog = unwords (tabJogStr !! x)
        let tabBotStr = geraTabelaStr tabBot
        let linhaTabelaBot = unwords (tabBotStr !! x)
        putStrLn (linhaTabelaJog ++ "                             " ++ linhaTabelaBot)
    else do
        if x < 10 
            then do
                let tabJogStr = geraTabelaStr tabJog
                let linhaTabelaJog = " " ++ unwords (tabJogStr !! x)
                let tabBotStr = geraTabelaStr tabBot
                let linhaTabelaBot = " " ++ unwords (tabBotStr !! x)
                putStrLn (linhaTabelaJog ++ "                             " ++ linhaTabelaBot)
                imprimiTabelas tabJog tabBot (x + 1)
            else do
                let tabJogStr = geraTabelaStr tabJog
                let linhaTabelaJog = unwords (tabJogStr !! x)
                let tabBotStr = geraTabelaStr tabBot
                let linhaTabelaBot = unwords (tabBotStr !! x)
                putStrLn (linhaTabelaJog ++ "                             " ++ linhaTabelaBot)
                imprimiTabelas tabJog tabBot (x + 1)
