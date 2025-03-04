{-# LANGUAGE DeriveGeneric #-}

module Modelos.Jogo (Jogo (..), JogoClass (..), inicializarJogo, carregarSave, salvarJogo, setJogador, setBot) where

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

import System.Random(newStdGen, split)

class JogoClass jogo where
    getJogador :: jogo -> Jogador
    getBot :: jogo -> Bot
    getMercado :: jogo -> Mercado
    getDataJogo :: jogo -> LocalTime

data Jogo = Jogo {
    jogador :: Jogador,
    bot :: Bot,
    mercado :: Mercado,
    dataJogo :: LocalTime
} deriving (Show, Generic)

instance JogoClass Jogo where
    getJogador = jogador
    getBot = bot
    getMercado = mercado
    getDataJogo = dataJogo

-- Permite Conversão para JSON

instance ToJSON Jogo
instance FromJSON Jogo

-- Função para mudar o Jogo quando houver alteração no Jogador

setJogador :: Jogador -> Jogo -> Jogo
setJogador novoJogador jogo = jogo { jogador = novoJogador }

setBot :: Bot -> Jogo -> Jogo
setBot novoBot jogo = jogo { bot = novoBot }

-- Função para salvar e carregar o jogo com um JSON
-- O FilePath tem o formato "src/BD/save{numero}.json"

salvarJogo :: FilePath -> Jogo -> IO ()
salvarJogo caminho jogo = do
    let diretorio = takeDirectory caminho
    createDirectoryIfMissing True diretorio  
    utcTime <- getCurrentTime
    let zonaBrasilia = hoursToTimeZone (-3)
    let agora = utcToLocalTime zonaBrasilia utcTime
    let jogoAtualizado = jogo { dataJogo = agora }
    B.writeFile caminho (encode jogoAtualizado)

carregarSave :: FilePath -> IO (Maybe Jogo)
carregarSave caminho = do
    conteudo <- B.readFile caminho
    return (decode conteudo)

-- Função de inicialização

inicializarJogo :: String -> IO Jogo
inicializarJogo nomeJogador = do
    utcTime <- getCurrentTime
    let zonaBrasilia = hoursToTimeZone (-3)  
    let agora = utcToLocalTime zonaBrasilia utcTime

    gen <- newStdGen
    let (genJogador, genBot) = split gen

    let tabelaJogador = geraTabela genJogador
    let tabelaBot = geraTabela genBot

    return $ Jogo (iniciarJogador nomeJogador tabelaJogador) (iniciarBot tabelaBot) iniciarMercado agora

-- Funções auxiliares de inicialização

iniciarJogador :: String -> Tabela -> Jogador
iniciarJogador nomeJogador tabelaJogador = Jogador nomeJogador 0 tabelaJogador 30 0 0 0

iniciarBot :: Tabela -> Bot
iniciarBot tabelaBot = Bot tabelaBot 30 3 1 0

iniciarMercado :: Mercado
iniciarMercado = Mercado 250 400 350