module Modelos.Tabuleiro where
import Modelos.Coordenada as Coordenada

type Tabela = [[String]]

geraTabelaInicial :: Tabela
geraTabela = geraTabelaAux [["  ", "A ", "B ", "C ", "D ", "E ", "F ", "G ", "H ", "I ", "J ", "K ", "L "]]


geraTabelaInicialAux :: [[String]] -> [[String]]
geraTabelaAux tabela =
    if length tabela >= 13
        then head tabela : adicionaNumeroCadaLinha (tail tabela)
        else geraTabelaAux (tabela ++ [geraLinhasComuns [1..12]])


geraLinhasIniciaisComuns :: [Int] -> [String]
geraLinhasComuns [] = []
geraLinhasComuns (a : as) = do
    let coord = Coordenada 'X' ' ' False
    (getMascara coord : " ") : geraLinhasComuns as


adicionaNumeroCadaLinha :: [[String]] -> [[String]]
adicionaNumeroCadaLinha listaSemNumeros = [ (show i ++ " ") : x | (x, i) <- zip listaSemNumeros [1..] ]


-- checaSeFoiAcertado :: Coordenada -> String
-- checaSeFoiAcertado coord =
--     if acertou coord
--         then representacao coord
--         else "X"


atualizaCoordenada :: Tabela -> Int -> Int -> String -> Tabela
atualizaCoordenada tab coluna linha novoValor = 
    [ if i == linha
      then [ if j == coluna then novoValor else elemento
           | (j, elemento) <- zip [0..12] linhaAtual ]
      else linhaAtual
  | (i, linhaAtual) <- zip [0..12] tab ]
