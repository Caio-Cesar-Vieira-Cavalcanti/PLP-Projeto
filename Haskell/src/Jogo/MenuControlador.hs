module Jogo.MenuControlador (iniciarMenu) where

import qualified UI.Menu as Menu
import qualified UI.UtilsUI as UtilsUI
import qualified UI.HUD as HUD
 
import Modelos.Jogo
import Modelos.Bot
import Modelos.Mercado (comprarItem)
import Modelos.Tabuleiro as Tabuleiro
import Modelos.Jogador as Jogador

import Jogo.GameOver as GameOver

import System.Random(randomRIO)
import System.Console.ANSI (clearScreen)
import Data.Char(isDigit, toUpper)

-- =========================================================================MENU================================================================================

iniciarMenu :: IO ()
iniciarMenu = do
  clearScreen 
  Menu.logoMenu
  opcaoEnter <- getLine
  clearScreen
  Menu.opcoesMenu
  opcao <- getLine
  processarOpcao opcao

processarOpcao :: String -> IO ()
processarOpcao "1" = do
  clearScreen
  Menu.novoJogo
  nomeJogador <- getLine
  iniciarJogo nomeJogador
processarOpcao "2" = do
  clearScreen
  Menu.carregarJogo
  slot <- getLine
  case slot of 
    _ | slot `elem` ["1", "2", "3"] -> carregarJogo slot
    _ | slot `elem` ["V", "v"] -> subMenu
    _ -> processarOpcao "2"
processarOpcao "3" = do
  clearScreen
  Menu.historiaJogo
  processarSubOpcao
processarOpcao "4" = do
  clearScreen
  Menu.regrasJogo
  processarSubOpcao
processarOpcao "5" = do
  clearScreen
  Menu.creditosJogo
  processarSubOpcao
processarOpcao "6" = do
    putStr UtilsUI.confirmacao
    opcao <- getLine
    case opcao of 
        op | op `elem` ["S", "s"] -> do
            clearScreen
            putStrLn "Saindo do jogo..."
        _ -> subMenu
processarOpcao _ = do
  putStr UtilsUI.opcaoInvalida
  opcao <- getLine
  processarOpcao opcao
  
-- Funções auxiliares MENU

subMenu :: IO ()
subMenu = do
    clearScreen
    Menu.opcoesMenu
    opcao <- getLine
    processarOpcao opcao

processarSubOpcao :: IO ()
processarSubOpcao = do
    opcao <- getLine
    case opcao of
        op | op `elem` ["V", "v"] -> do
            clearScreen
            subMenu
        _ -> do
            putStr UtilsUI.voltarMenu
            processarSubOpcao

-- =========================================================================JOGO================================================================================

iniciarJogo :: String -> IO ()
iniciarJogo nomeJogador = do
    jogo <- inicializarJogo nomeJogador  
    loopJogo jogo  

carregarJogo :: FilePath -> IO ()
carregarJogo numero = do
    let caminho = "src/BD/save" ++ numero ++ ".json"
    jogoCarregado <- carregarSave caminho
    case jogoCarregado of
        Just jogo -> loopJogo jogo
        Nothing   -> putStrLn "Erro: Não foi possível carregar o jogo." 

loopJogo :: Jogo -> IO ()
loopJogo jogo = do
    clearScreen
    HUD.mainScreen jogo
    gameOver <- GameOver.verificaVitoriaDerrotaPlayer jogo
    if gameOver
      then do 
        processarSubOpcao
      else do
        opcao <- getLine
        processarOpcaoLoop opcao jogo

processarOpcaoLoop :: String -> Jogo -> IO ()
processarOpcaoLoop "1" jogo = do
    let tabelaPosDrone = desfazVisualizacaoDrone (tabela (jogador jogo))
    if tabelaPosDrone /= tabela (jogador jogo)
      then 
        processarOpcaoLoop "1" (jogo { jogador = (jogador jogo) { tabela = tabelaPosDrone } })
      else
        if getBombasPequenas (getJogador jogo) <= 0
          then 
            loopJogo jogo
          else do
              (coluna, linha) <- inputCoordenada
              let (novaTabelaJog, novasMoedas) = 
                      atirouNaCoordenada (tabela (jogador jogo)) 
                          (getIndexColuna ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"] coluna 0) 
                          (linha - 1)
              r <- randomRIO(0,143)
              let jogoAtualizado = jogo { jogador = (jogador jogo) 
                  { tabela = novaTabelaJog
                  , bombasPequenas = bombasPequenas (jogador jogo) - 1  
                  , moedas = getMoedas (jogador jogo) + novasMoedas  
                  }, bot = (jogar (bot jogo) r)
              }
              loopJogo jogoAtualizado

processarOpcaoLoop "2" jogo = do
  let tabelaPosDrone = desfazVisualizacaoDrone (tabela (jogador jogo))
  if tabelaPosDrone /= tabela (jogador jogo)
    then 
      processarOpcaoLoop "2" (jogo { jogador = (jogador jogo) { tabela = tabelaPosDrone } })
    else
      if getBombasMedias (getJogador jogo) <= 0
        then 
          loopJogo jogo
        else do
            (coluna, linha) <- inputCoordenada
            let (novaTabelaJog, novasMoedas) = 
                    tiroBombaMedia (tabela (jogador jogo)) 
                        (getIndexColuna ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"] coluna 0) 
                        (linha - 1)
            r <- randomRIO(0,143)
            let jogoAtualizado = jogo { jogador = (jogador jogo) 
                { tabela = novaTabelaJog
                , bombasMedias = bombasMedias (jogador jogo) - 1  
                , moedas = getMoedas (jogador jogo) + novasMoedas  
                }, bot = (jogar (bot jogo) r)
            }
            loopJogo jogoAtualizado

processarOpcaoLoop "3" jogo = do
    let tabelaPosDrone = desfazVisualizacaoDrone (tabela (jogador jogo))
    if tabelaPosDrone /= tabela (jogador jogo)
      then 
        processarOpcaoLoop "3" (jogo { jogador = (jogador jogo) { tabela = tabelaPosDrone } })
      else
        if getBombasGrandes (getJogador jogo) <= 0
          then 
            loopJogo jogo
          else do
              (coluna, linha) <- inputCoordenada
              let (novaTabelaJog, novasMoedas) = 
                      tiroBombaGrande (tabela (jogador jogo)) 
                          (getIndexColuna ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"] coluna 0) 
                          (linha - 1)
              r <- randomRIO(0,143)
              let jogoAtualizado = jogo { jogador = (jogador jogo) 
                  { tabela = novaTabelaJog
                  , bombasGrandes = bombasGrandes (jogador jogo) - 1  
                  , moedas = getMoedas (jogador jogo) + novasMoedas  
                  }, bot = (jogar (bot jogo) r)
              }
              loopJogo jogoAtualizado

processarOpcaoLoop "4" jogo = do
  if getDroneVisualizador (getJogador jogo) <= 0 then loopJogo jogo
  else do
    (coluna, linha) <- inputCoordenada
    let novaTabelaJog = 
          drone (tabela (jogador jogo)) 
            (getIndexColuna ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"] coluna 0) 
            (linha - 1)
    let jogoAtualizado = jogo { jogador = (jogador jogo) { tabela = novaTabelaJog, droneVisualizador = droneVisualizador (jogador jogo) - 1 } }
    loopJogo jogoAtualizado

processarOpcaoLoop "m" jogo = do
  clearScreen
  HUD.mercadoScreen jogo
  item <- getLine
  if item `elem` ["1", "2", "3"]
    then do
      let jogador = getJogador jogo
      let mercado = getMercado jogo
      let novoJogador = Modelos.Mercado.comprarItem jogador mercado item
      let novoJogo = setJogador novoJogador jogo  
      loopJogo novoJogo
    else processarSubOpcaoLoop jogo item

processarOpcaoLoop "s" jogo = do
  clearScreen
  HUD.saveJogoScreen
  slot <- getLine
  let caminho = "src/BD/save" ++ slot ++ ".json"
  if slot `elem` ["1", "2", "3"]
    then do
      putStr UtilsUI.confirmacao
      confirmacaoSalvamento caminho jogo slot
    else processarSubOpcaoLoop jogo slot
processarOpcaoLoop "q" jogo = do
  putStr UtilsUI.confirmacao
  opcao <- getLine
  case opcao of 
      op | op `elem` ["S", "s"] -> subMenu
      _ -> do
        putStr "> Digite a opção: "
        opcao <- getLine
        processarOpcaoLoop opcao jogo

processarOpcaoLoop _ jogo = do
  putStr UtilsUI.opcaoInvalida
  opcao <- getLine
  processarOpcaoLoop opcao jogo

-- Funções auxiliares JOGO

processarSubOpcaoLoop :: Jogo -> String -> IO ()
processarSubOpcaoLoop jogo opcao
  | opcao `elem` ["V", "v"] = loopJogo jogo
  | otherwise = do
                putStr UtilsUI.opcaoInvalidaVoltar
                opcaoNovamente <- getLine
                processarSubOpcaoLoop jogo opcaoNovamente 

confirmacaoSalvamento :: FilePath -> Jogo -> String -> IO ()
confirmacaoSalvamento caminho jogo slot = do
  opcao <- getLine
  case opcao of  
    op | op `elem` ["S", "s"] -> do
      clearScreen
      Modelos.Jogo.salvarJogo caminho jogo
      carregarJogo slot  
    _ -> do
      loopJogo jogo

getIndexColuna :: [String] -> String -> Int -> Int 
getIndexColuna listaLetras str i =
  if listaLetras !! i == str 
    then i
    else getIndexColuna listaLetras str (i + 1)

inputCoordenada :: IO (String, Int)
inputCoordenada = do
    putStr "> Digite a coordenada: "
    coord <- getLine
    if validarCoordenada coord
        then let (coluna:linha) = coord
             in return ([toUpper coluna], read linha)
        else do
            putStrLn UtilsUI.opcaoInvalida
            inputCoordenada

validarCoordenada :: String -> Bool
validarCoordenada (c:ls) =
    c `elem` ['A'..'L'] && all isDigit ls && let l = read ls in l `elem` [1..12]
validarCoordenada _ = False  