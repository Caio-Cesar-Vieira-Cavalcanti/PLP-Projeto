module Modelos.Tabuleiro (Tabela, geraTabela, geraTabelaStr, atirouNaCoordenada) where

import Modelos.Coordenada

type Tabela = [[Coordenada]]

geraTabela :: Tabela
geraTabela = [[Coordenada 'X' ' ' False | _ <- [1..12]] | _ <- [1..12]]

geraTabelaStr :: Tabela -> [[String]]
geraTabelaStr tabela = colocaLetrasNumeros [[if getAcertou c then (getElemEspecial c) : " " else (getMascara c ) : " " | c <- linha] | linha <- tabela]

-- Funções auxiliares

colocaLetrasNumeros :: [[String]] -> [[String]]
colocaLetrasNumeros listaSemNumeros = ["  ", "A ", "B ", "C ", "D ", "E ", "F ", "G ", "H ", "I ", "J ", "K ", "L "] : [ (show i ++ " ") : x | (x, i) <- zip listaSemNumeros [1..12] ]


atirouNaCoordenada :: Tabela -> Int -> Int -> Coordenada -> Tabela
atirouNaCoordenada tabela c l coord = [[if i == l && j == c then Coordenada (getMascara coord) (getElemEspecial coord) True else x | (j, x) <- zip [0..] linha] | (i, linha) <- zip [0..] tabela]


-- checaSeFoiAcertado :: Coordenada -> String
-- checaSeFoiAcertado coord =
--     if acertou coord
--         then representacao coord
--         else "X"
