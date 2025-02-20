import Modelos.Tabuleiro
import Modelos.Jogador
import Modelos.Mercado

iniciarJogador :: String -> Jogador
iniciarJogador nome = Jogador nome 0 30 0 0 0

iniciarMercado :: Mercado
iniciarMercado = Mercado 250 400 350

iniciarTabela :: Tabela
iniciarTabela = geraTabelaInicial 

iniciarJogo :: String -> Jogo
iniciarJogo nomeJogador = Jogo (iniciarJogador nomeJogador) iniciarMercado iniciarTabela