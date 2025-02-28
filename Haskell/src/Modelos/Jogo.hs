{-# LANGUAGE DeriveGeneric #-}

module Modelos.Jogo (Jogo (..), inicializarJogo) where

import Modelos.Jogador
import Modelos.Mercado
import Modelos.Tabuleiro
import Modelos.Bot
import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON, encode, decode, eitherDecode)
import qualified Data.ByteString.Lazy as B
import System.Directory (createDirectoryIfMissing)
import System.FilePath(takeDirectory)
import Data.Time (getCurrentTime, UTCTime, utcToLocalTime, LocalTime)
import Data.Time.LocalTime(hoursToTimeZone)

data Jogo = Jogo {
    jogador :: Jogador,
    bot :: Bot,
    mercado :: Mercado,
    dataJogo :: LocalTime
} deriving (Show, Generic)

-- Permite Conversão para JSON

instance ToJSON Jogo
instance FromJSON Jogo

-- Função para salvar e carregar o jogo com um JSON
-- O FilePath tem o formato "src/BD/save{numero}.json"

salvarJogo :: FilePath -> Jogo -> IO ()
salvarJogo caminho jogo = do
    let diretorio = takeDirectory caminho
    createDirectoryIfMissing True diretorio  
    B.writeFile caminho (encode jogo)

carregarJogo :: FilePath -> IO (Maybe Jogo)
carregarJogo caminho = do
    conteudo <- B.readFile caminho
    return (decode conteudo)

-- Função de inicialização

inicializarJogo :: String -> IO Jogo
inicializarJogo nomeJogador = do
    utcTime <- getCurrentTime
    let zonaBrasilia = hoursToTimeZone (-3)  
    let agora = utcToLocalTime zonaBrasilia utcTime
    return $ Jogo (iniciarJogador nomeJogador geraTabela) (iniciarBot geraTabela) iniciarMercado agora

-- Funções auxiliares de inicialização

iniciarJogador :: String -> Tabela -> Jogador
iniciarJogador nome tabelaJogador = Jogador nome 0 tabelaJogador 30 0 0 0

-- Revisar as quantidades de cada bomba
iniciarBot :: Tabela -> Bot
iniciarBot tabelaBot = Bot tabelaBot 30 3 1

iniciarMercado :: Mercado
iniciarMercado = Mercado 250 400 350