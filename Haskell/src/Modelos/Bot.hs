module Modelos.Bot (Bot(..), BotClass(..)) where

import Modelos.Tabuleiro ( Tabela )
import Modelos.Coordenada (Coordenada)
import System.Random (randomRIO)
--Necessário adicionar random

class BotClass b where
    getTabela :: b -> Tabela
    getJogada :: b -> (Int,Int)

data Bot = Bot
    { 
     tabela :: Tabela
    } deriving Show

instance BotClass Bot where

    getTabela = tabela
    --getJogada = {
        -- Transforma coordenada randômica (dentre as ainda não acertadas) em acertada e retorna a tupla (x,y)
    --}