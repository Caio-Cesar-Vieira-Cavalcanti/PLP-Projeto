module UI.HUD (mainScreen, saveJogoScreen, mercadoScreen) where
    
import qualified UI.UtilsUI as Utils

import Modelos.Jogo

import Modelos.Jogador
import Modelos.Bot
import Modelos.Mercado
import Modelos.Tabuleiro


{- Falta trocar os dummies  por valores reais passados como argumento -}

-- Tela Principal da HUD 
-- Recebe o estado atual do jogo (Jogo)

mainScreen :: Jogo -> IO()
mainScreen jogoAtual = do
    -- Extraindo Jogador e Bot do estado de Jogo
    let jogadorAtual = getJogador jogoAtual
    let botAtual = getBot jogoAtual

    let tabelaJogador = getTabelaJogador jogadorAtual
    let tabelaBot = getTabelaBot botAtual

    let nomeJogador = getNome jogadorAtual

    putStr ("Jogador: " ++ nomeJogador)
    putStr ("                                                      ")
    putStr ("Oponente: Imperador de Prologia")

    putStrLn ""
    putStrLn ""

    imprimiTabelas tabelaJogador tabelaBot 0

    putStrLn ""
    putStrLn ""

    -- Criar uma função para contabilizar os derrotados em Tabuleiro.hs
    let inimigosDerrotadosJogador = 1
    let inimigosDerrotadosBot = 1

    putStr ("Inimigos: " ++ show inimigosDerrotadosJogador ++ "/6")
    putStr ("                                                       ")
    putStr ("Inimigos do Oponente: " ++ show inimigosDerrotadosBot ++ "/6")

    putStrLn ""


    -- Criar uma função para contabilizar os derrotados em Tabuleiro.hs
    let espacosAmigosAtingidosJogador = 1
    let espacosAmigosAtingidosBot = 1

    putStr ("Espaços Amigos: " ++ show espacosAmigosAtingidosJogador ++ "/3")
    putStr ("                                                 ")
    putStr ("Espaços Amigos do Oponente: " ++ show espacosAmigosAtingidosBot ++ "/3")

    putStrLn ""
    putStrLn ""
    putStrLn ""

    mostraInventario jogadorAtual
    
    putStrLn ""

    putStrLn "Atalhos: "
    putStrLn "'1' -> Usar bombas pequenas"
    putStrLn "'2' -> Usar bombas médias"
    putStrLn "'3' -> Usar bombas grandes"
    putStrLn "'4' -> Usar o drone visualizador de áreas"
    putStrLn "{COLUNAS}{LINHA} -> Coordenada que deseja atacar; Exemplo: C3"
    putStrLn ""
    putStrLn "'m' -> Acesso ao mercado"
    putStrLn "'s' -> Salvar o jogo no estado atual"
    putStrLn "'q' -> Sair do jogo sem salvar"
    
    putStrLn ""

    putStr "> Digite a opção: "

-- Tela Salvar Jogo

-- Deve receber o estado Jogo, para guardar
saveJogoScreen :: IO ()
saveJogoScreen = do
    putStrLn "Escolha um slot para salvar:"
    putStrLn ""
    estados <- Utils.saveStates
    putStr estados

-- Tela Mercado 

mercadoScreen :: Jogo -> IO ()
mercadoScreen jogoAtual = do

    putStrLn "  __  __                             _        "
    putStrLn " |  \x5C/  |  ___  _ __  ___  __ _   __| |  ___  "
    putStrLn " | |\x5C/| | / _ \x5C| '__|/ __|/ _` | / _` | / _ \x5C "
    putStrLn " | |  | ||  __/| |  | (__| (_| || (_| || (_) |"
    putStrLn " |_|  |_| \x5C___||_|   \x5C___|\x5C__,_| \x5C__,_| \x5C___/ "

    putStrLn ""

    let jogadorAtual = getJogador jogoAtual

    mostraInventario jogadorAtual
    
    putStrLn ""

    putStrLn "Atalhos:"
    
    putStrLn ""

    let mercadoAtual = getMercado jogoAtual
    let precoBM = getPrecoBM mercadoAtual
    let precoBG = getPrecoBG mercadoAtual
    let precoDV = getPrecoDV mercadoAtual

    putStrLn ("'1' -> Comprar bombas médias               ($" ++ show precoBM ++ ")")
    putStrLn ("'2' -> Comprar bombas grandes              ($" ++ show precoBG ++ ")")
    putStrLn ("'3' -> Comprar drone visualizador de áreas ($" ++ show precoDV ++ ")")

    putStrLn ""

    putStr "> Digite o item ou 'v' para voltar: "

-- Funções utilitárias

mostraInventario :: Jogador -> IO ()
mostraInventario jogadorAtual = do
    putStrLn "Inventário:"
    
    let bombasP = getBombasPequenas jogadorAtual
    let bombasM = getBombasMedias jogadorAtual
    let bombasG = getBombasGrandes jogadorAtual

    putStrLn ("Bombas pequenas: " ++ show bombasP ++ " | Bombas médias: " ++ show bombasM ++ " | Bombas grandes: " ++ show bombasG)

    let dronesVisualizador = getDroneVisualizador jogadorAtual

    putStrLn ("Drone visualizador de áreas: " ++ show dronesVisualizador)

    putStrLn ""
    
    let moedasJogador = getMoedas jogadorAtual

    putStrLn ("Moedas: " ++ show moedasJogador)








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
