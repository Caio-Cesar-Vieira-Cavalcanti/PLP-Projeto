module Modelos.Tabuleiro (Tabela, geraTabela, geraTabelaStr, contabilizarInimigos, contabilizarAmigos) where

import Modelos.Coordenada

import System.Random (randomR, StdGen)

type Tabela = [[Coordenada]]

-- Gerar a tabela base e insere os espaços especiais (recebe um argumento da seed para a função de randomização)
geraTabela :: StdGen -> Tabela
geraTabela gen = disporEspacos gen tabelaBase
    where tabelaBase = [[Coordenada 'X' '-' False | _ <- ([1..12] :: [Int])] | _ <- ([1..12] :: [Int])]

-- Gerar a tabela no formato String, dado uma tabela base passada como argumento
geraTabelaStr :: Tabela -> [[String]]
geraTabelaStr tabela = colocaLetrasNumeros [[if getAcertou c then (getElemEspecial c) : " " else (getMascara c ) : " " | c <- linha] | linha <- tabela]



-- Funções de verificar as jogadas (sendo a Tabela um argumento)




-- Funções de contagem dos espaços amigos e inimigos (Respeitando as partes nos inimigos - só contabiliza quando toda a parte/agrupamento dele for acertado por completo)
contabilizarInimigos :: Tabela -> Int
contabilizarInimigos tabela =
    let gruposInimigos = [('S', 2), ('M', 3), ('T', 5)]
        contarGrupo (char, tamanho) = length [1 | linha <- [0..11], coluna <- [0..11], ehGrupoValido tabela char tamanho (linha, coluna)]
    in sum (map contarGrupo gruposInimigos)


contabilizarAmigos :: Tabela -> Int
contabilizarAmigos tabela = 
    let amigos = ['C', 'E', 'H']
        verificarAmigo char = 
            length [(linha, coluna) | linha <- [0..11], coluna <- [0..11], getElemEspecial (tabela !! linha !! coluna) == char && getAcertou (tabela !! linha !! coluna)]
    in sum (map verificarAmigo amigos)



-- Funções auxiliares

colocaLetrasNumeros :: [[String]] -> [[String]]
colocaLetrasNumeros listaSemNumeros = ["  ", "A ", "B ", "C ", "D ", "E ", "F ", "G ", "H ", "I ", "J ", "K ", "L "] : [ (show i ++ " ") : x | (x, i) <- zip listaSemNumeros ([1..12] :: [Int])]

atirouNaCoordenada :: Tabela -> Int -> Int -> Tabela
atirouNaCoordenada tabela c l = [[if i == l && j == c then setAcertou x else x | (j, x) <- zip [0..] linha] | (i, linha) <- zip [0..] tabela]

setElemEspecial :: Tabela -> Int -> Int -> Char -> Tabela
setElemEspecial tabela c l novoElemEspecial = [[if i == l && j == c then setElem x novoElemEspecial else x | (j, x) <- zip [0..] linha] | (i, linha) <- zip [0..] tabela]

-- Verifica o espaço livre para a inserção de um grupo de elementos (todo o espaço necessário para inserir um grupo)
verificarEspacoLivre :: Tabela -> Int -> Int -> Int -> Bool -> Bool
verificarEspacoLivre tabela linha coluna tamanho horizontal =
    let espacosLivres = if horizontal
            then [(linha, coluna + i) | i <- [0..tamanho - 1], (coluna + i) <= 11]
            else [(linha + i, coluna) | i <- [0..tamanho - 1], (linha + i) <= 11]
        espacosValidos = all (\(l, c) -> getElemEspecial (tabela !! l !! c) == '-') espacosLivres

    in  if length espacosLivres < tamanho
        then False
        else espacosValidos

-- Verifica se um grupo está completamente acertado
ehGrupoValido :: Tabela -> Char -> Int -> (Int, Int) -> Bool
ehGrupoValido tabela char tamanho (linha, coluna) =
    let horizontal = [(linha, coluna + i) | i <- [0..tamanho-1], coluna + i <= 11]
        vertical = [(linha + i, coluna) | i <- [0..tamanho-1], linha + i <= 11]
        grupoHorizontal = all (\(l, c) -> getElemEspecial (tabela !! l !! c) == char && getAcertou (tabela !! l !! c)) horizontal
        grupoVertical = all (\(l, c) -> getElemEspecial (tabela !! l !! c) == char && getAcertou (tabela !! l !! c)) vertical
    in grupoHorizontal || grupoVertical


-- Funções de dispor os espaços (inimigos e amigos) na tabela 

-- Dispor todos os espaços especiais na tabela
-- A função `fst` pega o primeiro elemento de uma tupla
-- A função `foldl` é uma função de acumulação ou de redução, que processa os elementos da *esquerda* para a *direita*
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
colocarGrupo char tamanho quantidade tabela gen
    | quantidade == 0 = (tabela, gen)
    | otherwise =
        let (linha, gen1) = randomR (0, 11) gen
            (coluna, gen2) = randomR (0, 11) gen1
            (horizontal, gen3) = randomR (True, False) gen2

            podeColocar = verificarEspacoLivre tabela linha coluna tamanho horizontal

        in  if podeColocar
                then let novaTabela = foldl (\tab i ->
                            if horizontal
                            then setElemEspecial tab (coluna + i) linha char
                            else setElemEspecial tab coluna (linha + i) char
                            ) tabela [0..tamanho - 1]
                    in colocarGrupo char tamanho (quantidade - 1) novaTabela gen3
            -- Garante que se não estiver com espaço disponível, realiza outra chamada da função
            else colocarGrupo char tamanho quantidade tabela gen3