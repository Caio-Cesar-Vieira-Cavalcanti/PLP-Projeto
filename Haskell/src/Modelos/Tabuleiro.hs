module Modelos.Tabuleiro where
    
import Modelos.Coordenada

type Tabela = [[Coordenada]]

geraTabela :: Tabela
geraTabela = [[Coordenada 'X' ' ' False | _ <- [1..12]] | _ <- [1..12]]

geraTabelaStr :: Tabela -> [[String]]
geraTabelaStr tabela = colocaLetrasNumeros [[(getMascara c : " ") | c <- linha] | linha <- tabela]

-- Funções auxiliares
    
colocaLetrasNumeros :: [[String]] -> [[String]]
colocaLetrasNumeros listaSemNumeros = [["  ", "A ", "B ", "C ", "D ", "E ", "F ", "G ", "H ", "I ", "J ", "K ", "L "]] ++ [ (show i ++ " ") : x | (x, i) <- zip listaSemNumeros [1..12] ]


{-
atualizaCoordenada :: Tabela -> Int -> Int -> String -> Tabela
atualizaCoordenada tab coluna linha novoValor = 
    [ if i == linha
      then [ if j == coluna then novoValor else elemento
           | (j, elemento) <- zip [0..12] linhaAtual ]
      else linhaAtual
  | (i, linhaAtual) <- zip [0..12] tab ]


-- checaSeFoiAcertado :: Coordenada -> String
-- checaSeFoiAcertado coord =
--     if acertou coord
--         then representacao coord
--         else "X"

-}