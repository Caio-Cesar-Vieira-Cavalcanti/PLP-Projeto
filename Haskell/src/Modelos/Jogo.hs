{-# LANGUAGE DeriveGeneric #-}

module Modelos.Jogo (Jogo (..), JogoClass (..), inicializarJogo, carregarSave) where

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

-- Função para salvar e carregar o jogo com um JSON
-- O FilePath tem o formato "src/BD/save{numero}.json"

salvarJogo :: FilePath -> Jogo -> IO ()
salvarJogo caminho jogo = do
    let diretorio = takeDirectory caminho
    createDirectoryIfMissing True diretorio  
    B.writeFile caminho (encode jogo)

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
iniciarJogador nome tabelaJogador = Jogador nome 0 tabelaJogador 30 0 0 0

-- Revisar as quantidades de cada bomba
iniciarBot :: Tabela -> Bot
iniciarBot tabelaBot = Bot tabelaBot 30 3 1

iniciarMercado :: Mercado
iniciarMercado = Mercado 250 400 350

main :: IO ()
main = do 
    let caminho = "src/BD/save1.json"

    -- Salvar o jogo
    jogo <- inicializarJogo "Arrascaeta"
    salvarJogo caminho jogo
    putStrLn "Jogo salvo com sucesso!"

    -- Carregar o jogo
    jogoCarregado <- carregarSave caminho
    case jogoCarregado of
        Just j  -> print j
        Nothing -> putStrLn "Erro ao carregar o jogo!"