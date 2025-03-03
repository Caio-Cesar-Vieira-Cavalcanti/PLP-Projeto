module UI.UtilsUI where

import System.Directory (doesDirectoryExist, listDirectory)
import Data.List (sort, find)
import Modelos.Jogo (carregarSave, Jogo(..)) 
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

-- Salva os estados do Jogo
saveStates :: IO String
saveStates = do
    let pastaBD = "src/BD"
    existe <- doesDirectoryExist pastaBD
    if not existe
        then return $ unlines (defaultSlots ++ ["", "> Digite 'v' para voltar: "])
        else do
            arquivos <- listDirectory pastaBD
            let arquivosOrdenados = sort arquivos
            saveSlots <- mapM formatarSave arquivosOrdenados
            let slotsFinal = corrigirOrdemSlots saveSlots
            return $ unlines (slotsFinal ++ ["", "> Digite o slot ou 'v' para voltar: "])

-- Lista padrão de slots vazios
defaultSlots :: [String]
defaultSlots =
    [ "[1]. Slot 1 - Vazio"
    , "[2]. Slot 2 - Vazio"
    , "[3]. Slot 3 - Vazio"
    ]

formatarSave :: FilePath -> IO (Int, String)
formatarSave arquivo = do
    jogoSalvo <- carregarSave $ "src/BD/" ++ arquivo
    let slotNumStr = filter isDigit arquivo
    let slotNum = if null slotNumStr then 0 else read slotNumStr :: Int 
    case jogoSalvo of
        Just jogo -> do
            let nomeJogador = getNome (jogador jogo)
            let dataJogoFormatada = formatTime defaultTimeLocale "%d/%m/%Y %H:%M" (dataJogo jogo)
            return (slotNum, "[" ++ show slotNum ++ "]. " ++ nomeJogador ++ " - Jogo salvo em " ++ dataJogoFormatada)
        Nothing -> return (slotNum, "[" ++ show slotNum ++ "]. Slot " ++ show slotNum ++ " - Vazio")

-- Corrige a ordem dos slots e preenche os vazios corretamente
corrigirOrdemSlots :: [(Int, String)] -> [String]
corrigirOrdemSlots saves =
    [ findOrDefault 1, findOrDefault 2, findOrDefault 3 ]
  where
    findOrDefault n = maybe (defaultSlots !! (n - 1)) snd (find ((== n) . fst) saves)