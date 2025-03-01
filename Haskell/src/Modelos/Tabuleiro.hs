module Modelos.Tabuleiro (Tabela, geraTabela, geraTabelaStr, atirouNaCoordenada, setElemEspecial) where

import Modelos.Coordenada

import System.Random (randomR, StdGen)

type Tabela = [[Coordenada]]

-- Gerar a tabela base e insere os espaços especiais (recebe um argumento da seed para a função de randomização)
geraTabela :: StdGen -> Tabela
geraTabela gen = disporEspacos gen tabelaBase
    where tabelaBase = [[Coordenada 'X' '-' False | _ <- [1..12]] | _ <- [1..12]]

geraTabelaStr :: Tabela -> [[String]]
geraTabelaStr tabela = colocaLetrasNumeros [[if getAcertou c then (getElemEspecial c) : " " else (getMascara c ) : " " | c <- linha] | linha <- tabela]

-- Funções de dispor os espaços (inimigos e amigos) na tabela 

-- Dispor todos os espaços especiais na tabela
-- A função `fst` pega o primeiro elemento de uma tupla
disporEspacos :: StdGen -> Tabela -> Tabela
disporEspacos gen tabela = 
    fst (foldl (\(tab, g) (char, qtd, tam) -> 
            if tam == 1 then colocarElemento char qtd tab g
                        else colocarGrupo char tam qtd tab g) 
            (tabela, gen) elementos)
    where
        elementos = [('C', 1, 1), ('E', 1, 1), ('H', 1, 1), ('$' , 2, 1),
                    ('#', 2, 1), ('S', 3, 2), ('M', 2, 3), ('T', 1, 5)]

-- Coloca elementos individuais aleatoriamente na tabela
colocarElemento :: Char -> Int -> Tabela -> StdGen -> (Tabela, StdGen)
colocarElemento _ 0 tabela gen = (tabela, gen)
colocarElemento char n tabela gen =
    let (linha, gen1) = randomR (0, 11) gen
        (coluna, gen2) = randomR (0, 11) gen1
    in if getElemEspecial (tabela !! linha !! coluna) == '-'
        then colocarElemento char (n - 1) (setElemEspecial tabela coluna linha char) gen2
        else colocarElemento char n tabela gen2 


-- Coloca grupos contíguos de elementos na tabela
colocarGrupo :: Char -> Int -> Int -> Tabela -> StdGen -> (Tabela, StdGen)
colocarGrupo _ _ 0 tabela gen = (tabela, gen)
colocarGrupo char tamanho quantidade tabela gen =
    let (linha, gen1) = randomR (0, 11) gen
        (coluna, gen2) = randomR (0, 11) gen1
        (horizontal, gen3) = randomR (True, False) gen2

        podeColocar = verificarEspacoLivre tabela linha coluna tamanho horizontal

        novaTabela = if podeColocar
                        then foldl (\tab i -> if horizontal
                                            then setElemEspecial tab (coluna + i) linha char
                                            else setElemEspecial tab coluna (linha + i) char)
                                tabela [0..tamanho - 1]
                        else tabela
    in colocarGrupo char tamanho (quantidade - 1) novaTabela gen3


-- Funções auxiliares

colocaLetrasNumeros :: [[String]] -> [[String]]
colocaLetrasNumeros listaSemNumeros = ["  ", "A ", "B ", "C ", "D ", "E ", "F ", "G ", "H ", "I ", "J ", "K ", "L "] : [ (show i ++ " ") : x | (x, i) <- zip listaSemNumeros [1..12] ]

atirouNaCoordenada :: Tabela -> Int -> Int -> Tabela
atirouNaCoordenada tabela c l = [[if i == l && j == c then Coordenada (getMascara x) (getElemEspecial x) True else x | (j, x) <- zip [0..] linha] | (i, linha) <- zip [0..] tabela]

setElemEspecial :: Tabela -> Int -> Int -> Char -> Tabela
setElemEspecial tabela c l novoElemEspecial = [[if i == l && j == c then Coordenada (getMascara x) novoElemEspecial False else x | (j, x) <- zip [0..] linha] | (i, linha) <- zip [0..] tabela]

-- Verifica o espaço livre para a inserção de um grupo de elementos
verificarEspacoLivre :: Tabela -> Int -> Int -> Int -> Bool -> Bool
verificarEspacoLivre tabela linha coluna tamanho horizontal =
    if horizontal
        then all (\i -> (coluna + i) <= 11 && getElemEspecial ((tabela !! linha) !! (coluna + i)) == '-') [0..tamanho - 1]
        else all (\i -> (linha + i) <= 11 && getElemEspecial ((tabela !! (linha + i)) !! coluna) == '-') [0..tamanho - 1]

