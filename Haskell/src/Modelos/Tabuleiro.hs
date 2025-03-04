module Modelos.Tabuleiro (Tabela, geraTabela, geraTabelaStr, contabilizarInimigos, contabilizarAmigos,
                            atirouNaCoordenada, tiroBombaMedia, tiroBombaGrande, drone, desfazVisualizacaoDrone) where

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


-- Funções auxiliares do tabuleiro

colocaLetrasNumeros :: [[String]] -> [[String]]
colocaLetrasNumeros listaSemNumeros = ["  ", "A ", "B ", "C ", "D ", "E ", "F ", "G ", "H ", "I ", "J ", "K ", "L "] : [ (show i ++ " ") : x | (x, i) <- zip listaSemNumeros ([1..12] :: [Int])]

-- Moedas ganhas com base no acerto
pontuacaoElemento :: Char -> Int
pontuacaoElemento 'S' = 25
pontuacaoElemento 'M' = 34
pontuacaoElemento 'T' = 40
pontuacaoElemento '$' = 250
pontuacaoElemento _ = 0  

atirouNaCoordenada :: Tabela -> Int -> Int -> (Tabela, Int)
atirouNaCoordenada tabela c l =
    if c >= 0 && c <= 11 && l >= 0 && l <= 11
        then if checaSeAcertouMina (tabela !! l !! c)
            then do
                let tabelaAtualizada = [[if i == l && j == c then setAcertou x else x | (j, x) <- zip [0..] linha] | (i, linha) <- zip [0..] tabela]
                atirouNaMina tabelaAtualizada c l
            else
                let elemento = getElemEspecial (tabela !! l !! c)
                    tabelaAtualizada = [[if i == l && j == c then setAcertou x else x | (j, x) <- zip [0..] linha] | (i, linha) <- zip [0..] tabela]
                    moedas = pontuacaoElemento elemento
                in (tabelaAtualizada, moedas)
        else (tabela, 0)

setElemEspecial :: Tabela -> Int -> Int -> Char -> Tabela
setElemEspecial tabela c l novoElemEspecial = [[if i == l && j == c then setElem x novoElemEspecial else x | (j, x) <- zip [0..] linha] | (i, linha) <- zip [0..] tabela]

-- Verifica o espaço livre para a inserção de um grupo de elementos
verificarEspacoLivre :: Tabela -> Int -> Int -> Int -> Bool -> Char -> Bool
verificarEspacoLivre tabela linha coluna tamanho horizontal char =
    let espacosLivres = if horizontal
            then [(linha, coluna + i) | i <- [0..tamanho - 1], (coluna + i) <= 11]
            else [(linha + i, coluna) | i <- [0..tamanho - 1], (linha + i) <= 11]

        espacosValidos = all (\(l, c) -> getElemEspecial (tabela !! l !! c) == '-') espacosLivres

        semGrupoAdjacente = all (\(l, c) -> not (temGrupoAdjacente tabela l c char)) espacosLivres

    in length espacosLivres == tamanho && espacosValidos && semGrupoAdjacente

temGrupoAdjacente :: Tabela -> Int -> Int -> Char -> Bool
temGrupoAdjacente tabela linha coluna char =
    let direcoes = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        dentroDoTab (l, c) = l >= 0 && l < 12 && c >= 0 && c < 12
        posicoesAdjacentes = filter dentroDoTab [(linha + dl, coluna + dc) | (dl, dc) <- direcoes]
    in any (\(l, c) -> getElemEspecial (tabela !! l !! c) == char) posicoesAdjacentes

tiroBombaMedia :: Tabela -> Int -> Int -> (Tabela, Int)
tiroBombaMedia tabela c l =
    let (tabela1, novasMoedas1) = atirouNaCoordenada tabela c l
        (tabela2, novasMoedas2) = atirouNaCoordenada tabela1 (c - 1) l
        (tabela3, novasMoedas3) = atirouNaCoordenada tabela2 (c + 1) l
        (tabela4, novasMoedas4) = atirouNaCoordenada tabela3 c (l - 1)
        (tabelaFinal, novasMoedas5) = atirouNaCoordenada tabela4 c (l + 1)
    in (tabelaFinal, novasMoedas1 + novasMoedas2 + novasMoedas3 + novasMoedas4 + novasMoedas5)

tiroBombaGrande :: Tabela -> Int -> Int -> (Tabela, Int)
tiroBombaGrande tabela c l =
    let (tabela1, novasMoedas1) = tiroBombaMedia tabela c l
        (tabela2, novasMoedas2) = atirouNaCoordenada tabela1 (c - 1) (l - 1)
        (tabela3, novasMoedas3) = atirouNaCoordenada tabela2 (c - 1) (l + 1)
        (tabela4, novasMoedas4) = atirouNaCoordenada tabela3 (c + 1) (l - 1)
        (tabelaFinal, novasMoedas5) = atirouNaCoordenada tabela4 (c + 1) (l + 1)
    in (tabelaFinal, novasMoedas1 + novasMoedas2 + novasMoedas3 + novasMoedas4 + novasMoedas5)

-- Verifica se um grupo está completamente acertado
ehGrupoValido :: Tabela -> Char -> Int -> (Int, Int) -> Bool
ehGrupoValido tabela char tamanho (linha, coluna) =
    let horizontal = [(linha, coluna + i) | i <- [0..tamanho-1], coluna + i <= 11]
        vertical = [(linha + i, coluna) | i <- [0..tamanho-1], linha + i <= 11]

        grupoHorizontal = length horizontal == tamanho &&
            all (\(l, c) -> getElemEspecial (tabela !! l !! c) == char && getAcertou (tabela !! l !! c)) horizontal &&
            (coluna == 0 || getElemEspecial (tabela !! linha !! (coluna - 1)) /= char) &&
            ((coluna + tamanho > 11) || getElemEspecial (tabela !! linha !! (coluna + tamanho)) /= char)

        grupoVertical = length vertical == tamanho &&
            all (\(l, c) -> getElemEspecial (tabela !! l !! c) == char && getAcertou (tabela !! l !! c)) vertical &&
            (linha == 0 || getElemEspecial (tabela !! (linha - 1) !! coluna) /= char) &&
            ((linha + tamanho > 11) || getElemEspecial (tabela !! (linha + tamanho) !! coluna) /= char)

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

colocarElemento :: Char -> Int -> Tabela -> StdGen -> (Tabela, StdGen)
colocarElemento _ 0 tabela gen = (tabela, gen)
colocarElemento char n tabela gen =
    let (linha, gen1) = randomR (0, 11) gen
        (coluna, gen2) = randomR (0, 11) gen1
    in if getElemEspecial (tabela !! linha !! coluna) == '-'
        then colocarElemento char (n - 1) (setElemEspecial tabela coluna linha char) gen2
        else colocarElemento char n tabela gen2 

colocarGrupo :: Char -> Int -> Int -> Tabela -> StdGen -> (Tabela, StdGen)
colocarGrupo char tamanho quantidade tabela gen
    | quantidade == 0 = (tabela, gen)
    | otherwise =
        let (linha, gen1) = randomR (0, 11) gen
            (coluna, gen2) = randomR (0, 11) gen1
            (horizontal, gen3) = randomR (True, False) gen2

            podeColocar = verificarEspacoLivre tabela linha coluna tamanho horizontal char

        in  if podeColocar
                then let novaTabela = foldl (\tab i ->
                            if horizontal
                            then setElemEspecial tab (coluna + i) linha char
                            else setElemEspecial tab coluna (linha + i) char
                            ) tabela [0..tamanho - 1]
                    in colocarGrupo char tamanho (quantidade - 1) novaTabela gen3
            else colocarGrupo char tamanho quantidade tabela gen3

atirouNaMina :: Tabela -> Int -> Int -> (Tabela, Int)
atirouNaMina tabela c l = 
    let (tabela2, novasMoedas2) = atirouNaCoordenada tabela (c - 1) l
        (tabela3, novasMoedas3) = atirouNaCoordenada tabela2 (c + 1) l
        (tabela4, novasMoedas4) = atirouNaCoordenada tabela3 c (l - 1)
        (tabelaFinal, novasMoedas5) = atirouNaCoordenada tabela4 c (l + 1)
    in (tabelaFinal, novasMoedas2 + novasMoedas3 + novasMoedas4 + novasMoedas5)

checaSeAcertouMina :: Coordenada -> Bool
checaSeAcertouMina coord = elemEspecial coord == '#'

drone :: Tabela -> Int -> Int -> Tabela
drone tabela c l = do
    let tabela1 = visualizacaoDrone tabela c l
        tabela2 = visualizacaoDrone tabela1 (c - 1) l
        tabela3 = visualizacaoDrone tabela2 (c + 1) l
        tabela4 = visualizacaoDrone tabela3 c (l - 1)
        tabela5 = visualizacaoDrone tabela4 c (l + 1)
        tabela6 = visualizacaoDrone tabela5 (c - 1) (l - 1)
        tabela7 = visualizacaoDrone tabela6 (c - 1) (l + 1)
        tabela8 = visualizacaoDrone tabela7 (c + 1) (l - 1)
    visualizacaoDrone tabela8 (c + 1) (l + 1)

visualizacaoDrone :: Tabela -> Int -> Int -> Tabela
visualizacaoDrone tabela c l =
    if c >= 0 && c <= 11 && l >= 0 && l <= 11
        then
            [[if i == l && j == c then mascaraViraInterrogacao x else x | (j, x) <- zip [0..] linha] | (i, linha) <- zip [0..] tabela]
        else tabela

mascaraViraInterrogacao :: Coordenada -> Coordenada
mascaraViraInterrogacao coord = 
    if (elemEspecial coord) /= '-'
        then coord { mascara = '?' }
        else coord { mascara = '-' }

desfazVisualizacaoDrone :: Tabela -> Tabela
desfazVisualizacaoDrone tabela = [[if mascara c /= 'X' then c { mascara = 'X' } else c | c <- linha] | linha <- tabela]