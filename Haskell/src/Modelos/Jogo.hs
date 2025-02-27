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

data Jogo = Jogo {
    jogador :: Jogador,
    bot :: Bot,
    mercado :: Mercado
} deriving (Show, Generic)

-- Permite Conversão para JSON

instance ToJSON Jogo
instance FromJSON Jogo

-- Função para salvar e carregar o jogo com um JSON
-- O FilePath tem o formato "src/BD/save{numero}.json"

salvarJogo :: FilePath -> Jogo -> IO ()
salvarJogo caminho jogo = do
    let diretorio = takeDirectory caminho
    createDirectoryIfMissing True diretorio  -- Garante que o diretório exista
    B.writeFile caminho (encode jogo)

carregarJogo :: FilePath -> IO (Maybe Jogo)
carregarJogo caminho = do
    conteudo <- B.readFile caminho
    return (decode conteudo)

-- Função de inicialização

inicializarJogo :: String -> Jogo
inicializarJogo nomeJogador = Jogo (iniciarJogador nomeJogador geraTabela) (iniciarBot geraTabela) iniciarMercado 

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
    let caminho = "src/BD/save2.json"

    -- Salvar o jogo
    let jogo = inicializarJogo "Tiquinho"
    salvarJogo caminho jogo
    putStrLn "Jogo salvo com sucesso!"

    -- Carregar o jogo
    jogoCarregado <- carregarJogo caminho
    case jogoCarregado of
        Just j  -> print j
        Nothing -> putStrLn "Erro ao carregar o jogo!"
