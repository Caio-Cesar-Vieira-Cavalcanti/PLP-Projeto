module Modelos.Tabuleiro (Tabela, geraTabela, geraTabelaStr, atirouNaCoordenada, setElemEspecial) where

import Modelos.Coordenada

type Tabela = [[Coordenada]]

geraTabela :: Tabela
geraTabela = [[Coordenada 'X' ' ' False | _ <- [1..12]] | _ <- [1..12]]

geraTabelaStr :: Tabela -> [[String]]
geraTabelaStr tabela = colocaLetrasNumeros [[if getAcertou c then (getElemEspecial c) : " " else (getMascara c ) : " " | c <- linha] | linha <- tabela]

-- Funções auxiliares

colocaLetrasNumeros :: [[String]] -> [[String]]
colocaLetrasNumeros listaSemNumeros = ["  ", "A ", "B ", "C ", "D ", "E ", "F ", "G ", "H ", "I ", "J ", "K ", "L "] : [ (show i ++ " ") : x | (x, i) <- zip listaSemNumeros [1..12] ]


atirouNaCoordenada :: Tabela -> Int -> Int -> Tabela
atirouNaCoordenada tabela c l = [[if i == l && j == c then Coordenada (getMascara x) (getElemEspecial x) True else x | (j, x) <- zip [0..] linha] | (i, linha) <- zip [0..] tabela]

setElemEspecial :: Tabela -> Int -> Int -> Char -> Tabela
setElemEspecial tabela c l novoElemEspecial = [[if i == l && j == c then Coordenada (getMascara x) novoElemEspecial False else x | (j, x) <- zip [0..] linha] | (i, linha) <- zip [0..] tabela]