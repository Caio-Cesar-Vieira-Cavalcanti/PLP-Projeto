module UI.UtilsUI where

import System.Directory (doesDirectoryExist, listDirectory)
import Data.List (sort)
import Modelos.Jogo (carregarJogo, Jogo(..)) 
import Modelos.Jogador(getNome, Jogador(..))
import Data.Time.Format (defaultTimeLocale, formatTime)
import Data.Maybe (fromMaybe)
import Data.Char (isDigit)

-- Funções utilitárias para as interfaces

opcaoInvalida :: String
opcaoInvalida = "> Opção inválida, digite novamente: "

confirmacao :: String
confirmacao = "> Tem certeza? [S/N]: "

voltarMenu :: String
voltarMenu = "> Digite 'v' para voltar ao menu: "

saveStates :: IO String
saveStates = do
    let pastaBD = "src/BD"
    existe <- doesDirectoryExist pastaBD
    if not existe
        then return $ unlines (defaultSlots ++ ["", "> Digite 'v' para voltar: "])
        else do
            arquivos <- listDirectory pastaBD
            let arquivosOrdenados = take 3 $ sort arquivos  
            saveSlots <- mapM formatarSave arquivosOrdenados
            let slotsCompletos = completarSlots saveSlots
            return $ unlines (slotsCompletos ++ ["", "> Digite o slot ou 'v' para voltar: "])

-- Funções auxiliares para a construção da exibição dos slots de salvamento

defaultSlots :: [String]
defaultSlots =
    [ "[1]. Slot 1 - Vazio"
    , "[2]. Slot 2 - Vazio"
    , "[3]. Slot 3 - Vazio"
    ]

formatarSave :: FilePath -> IO String
formatarSave arquivo = do
    jogoSalvo <- carregarJogo $ "src/BD/" ++ arquivo
    let slotNum = filter isDigit arquivo  
    case jogoSalvo of
        Just jogo -> do
            let nomeJogador = getNome (jogador jogo)
            let dataJogoFormatada = formatTime defaultTimeLocale "%d/%m/%Y %H:%M" (dataJogo jogo)
            return $ "[" ++ slotNum ++ "]. " ++ nomeJogador ++ " - Jogo salvo em " ++ dataJogoFormatada
        Nothing -> return $ "[" ++ slotNum ++ "]. Slot " ++ slotNum ++ " - Vazio"

completarSlots :: [String] -> [String]
completarSlots saves = 
    let preenchidos = length saves
        faltantes = drop preenchidos defaultSlots
    in saves ++ faltantes
