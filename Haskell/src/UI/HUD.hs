module UI.HUD (mainScreen, saveJogoScreen, mercadoScreen) where
    
import qualified UI.UtilsUI as Utils

import Modelos.Jogo
import Modelos.Jogador
import Modelos.Bot
import Modelos.Mercado
import Modelos.Tabuleiro

-- Tela Principal da HUD 

mainScreen :: Jogo -> IO()
mainScreen jogoAtual = do
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

    -- Imprimir as duas tabelas (Jogador e do Bot)
    imprimiTabelas tabelaJogador tabelaBot

    putStrLn ""
    putStrLn ""

    let inimigosDerrotadosJogador = contabilizarInimigos tabelaJogador
    let inimigosDerrotadosBot = contabilizarInimigos tabelaBot

    putStr ("Inimigos: " ++ show inimigosDerrotadosJogador ++ "/6")
    putStr ("                                                       ")
    putStr ("Inimigos do Oponente: " ++ show inimigosDerrotadosBot ++ "/6")

    putStrLn ""

    let espacosAmigosAtingidosJogador = contabilizarAmigos tabelaJogador
    let espacosAmigosAtingidosBot = contabilizarAmigos tabelaBot

    putStr ("Espaços Amigos: " ++ show espacosAmigosAtingidosJogador ++ "/3")
    putStr ("                                                 ")
    putStr ("Espaços Amigos do Oponente: " ++ show espacosAmigosAtingidosBot ++ "/3")

    putStrLn ""
    putStrLn ""
    putStrLn ""

    -- Imprimir o inventário do Jogador
    mostraInventario jogadorAtual
    
    putStrLn ""

    putStrLn "Atalhos: "
    putStrLn "'1' -> Usar bomba pequena"
    putStrLn "'2' -> Usar bomba média"
    putStrLn "'3' -> Usar bomba grande"
    putStrLn "'4' -> Usar o drone visualizador de áreas"
    putStrLn "{COLUNA}{LINHA} -> Coordenada que deseja atacar; Exemplo: C3"
    putStrLn ""
    putStrLn "'m' -> Acesso ao mercado"
    putStrLn "'s' -> Salvar o jogo no estado atual"
    putStrLn "'q' -> Sair do jogo sem salvar"
    
    putStrLn ""

    putStr "> Digite a opção: "


-- Tela Salvar Jogo

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

-- Funções auxiliares do HUD

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

imprimiTabelas :: Tabela -> Tabela -> IO() 
imprimiTabelas tabJog tabBot = 
    let tabJogStr = geraTabelaStr tabJog
        tabBotStr = geraTabelaStr tabBot
    in imprimirLinhas tabJogStr tabBotStr 0

imprimirLinhas :: [[String]] -> [[String]] -> Int -> IO()
imprimirLinhas tabJogStr tabBotStr x = do
    let linhaJog = formatarLinhas (tabJogStr !! x) x
    let linhaBot = formatarLinhas (tabBotStr !! x) x
    putStrLn (linhaJog ++ "                             " ++ linhaBot)
    if x < 12 then imprimirLinhas tabJogStr tabBotStr (x + 1)
    else return ()

formatarLinhas :: [String] -> Int -> String
formatarLinhas linha x
    | x < 10    = " " ++ unwords linha
    | otherwise = unwords linha