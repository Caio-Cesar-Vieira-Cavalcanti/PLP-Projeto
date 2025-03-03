module UI.Menu (logoMenu, opcoesMenu, novoJogo, carregarJogo, historiaJogo, regrasJogo, creditosJogo) where

import qualified UI.UtilsUI as UtilsUI

-- Funções Principais

logoMenu :: IO ()
logoMenu = do
  putStr
    ( asciiArt
        ++ unlines
          [ "             Pressione a tecla \"Enter\"",
            "",
            ""
          ]
    )

opcoesMenu :: IO ()
opcoesMenu = do
  putStr
    ( asciiArt
        ++ unlines
          [ "             [1]. Novo Jogo",
            "             [2]. Carregar Jogo",
            "             [3]. História",
            "             [4]. Regras",
            "             [5]. Créditos",
            "",
            "             [6]. Sair do Jogo",
            ""
          ]
        ++ "> Opção: "
    )

novoJogo :: IO ()
novoJogo = do
  putStr
    ( unlines
        [ "             CARREGANDO O NOVO JOGO...",
          "",
          ""
        ]
        ++ "> Digite o seu nome: "
    )

carregarJogo :: IO ()
carregarJogo = do
    estados <- UtilsUI.saveStates
    putStr $ unlines ["Escolha um slot para carregar o estado do jogo:", ""] ++ estados

historiaJogo :: IO ()
historiaJogo = do
  putStr
    ( unlines
        [ "  _   _ _     _             _       ",
          " | | | (_)___| |_ ___  _ __(_) __ _ ",
          " | |_| | / __| __/ _ \\| '__| |/ _` |",
          " |  _  | \\__ \\ || (_) | |  | | (_| |",
          " |_| |_|_|___/\\__\\___/|_|  |_|\\__,_|",
          "                                     ",
          ""
        ]
        ++ historia
        ++ UtilsUI.voltarMenu
    )

regrasJogo :: IO ()
regrasJogo = do
  putStr
    ( unlines
        [ "  ____                          ",
          " |  _ \\ ___  __ _ _ __ __ _ ___ ",
          " | |_) / _ \\/ _` | '__/ _` / __|",
          " |  _ <  __/ (_| | | | (_| \\__ \\",
          " |_| \\_\\___|\\__, |_|  \\__,_|___/",
          "            |___/               ",
          ""
        ]
        ++ regras
        ++ UtilsUI.voltarMenu
    )

creditosJogo :: IO ()
creditosJogo = do
  putStr
    ( unlines
        [ "   ____              _ _ _            ",
          "  / ___|_ __ ___  __| (_) |_ ___  ___ ",
          " | |   | '__/ _ \\/ _` | | __/ _ \\/ __|",
          " | |___| | |  __/ (_| | | || (_) \\__ \\",
          "  \\____|_|  \\___|\\__,_|_|\\__\\___/|___/",
          "                                      ",
          ""
        ]
        ++ creditos
        ++ UtilsUI.voltarMenu
    )

-- Funções Auxiliares

asciiArt :: String
asciiArt =
  unlines
    [ "  ____        _       _____                _   ",
      " | __ ) _   _| |_ ___|  ___| __ ___  _ __ | |_ ",
      " |  _ \\| | | | __/ _ \\ |_ | '__/ _ \\| '_ \\| __|",
      " | |_) | |_| | ||  __/  _|| | | (_) | | | | |_ ",
      " |____/ \\__, |\\__\\___|_|  |_|  \\___/|_| |_|\\__|",
      "        |___/                                  ",
      "",
      "             A Guerra dos Paradigmas            ",
      "",
      ""
    ]

historia :: String
historia =
  "-> No coração da pequena cidade da República de Haskelland, o equilíbrio entre tradição e progresso é abalado por uma invasão iminente."
    ++ "O Império de Prologia, nação vizinha e rival de longa data, por diferenças de paradigmas, inicia uma ofensiva estratégica para tomar "
    ++ "o controle da cidade rica em Silício, um recurso valioso para a construção de processadores na indústria de computadores voltados para o uso militar.\n\n"
    ++ "-> Você joga como um piloto renomado de aviões bombardeiros do exército de Haskelland, que serve como a última esperança para combater os inimigos do "
    ++ "Império de Prologia. Munido de poucos recursos, e sem ferir os direitos impostos pela Convenção de Genebra, em proteção dos civis de Haskelland, "
    ++ "o que poderá diminuir sua sanidade em caso de transgressão, como atingir espaços especiais.\n\n"
    ++ "-> Em meio a escolhas morais difíceis, você deve decidir entre proteger o máximo de cidadãos e construções civis, a qualquer custo, ou priorizar a "
    ++ "vitória estratégica. O destino da democracia do paradigma funcional de Haskelland está em suas mãos: será uma vitória lembrada por gerações, ou a "
    ++ "ruína total de uma cidade consumida pela guerra?\n\n"

regras :: String
regras =
  "-> O jogador precisará derrotar todos os inimigos, cada um com seu porte, de Pequeno, Médio e/ou Grande, sem esgotar os seus recursos "
    ++ "e muito menos, sem atingir todos os espaços especiais - representados por Civis/Hospitais/Escolas - que se concretizado, o jogador é derrotado por "
    ++ "Falta de Recursos ou Perda de Sanidade, respectivamente.\n\n"
    ++ "-> Além dessas duas formas de derrotas, o jogador contará com a derrota pela máquina, o seu oponente, que se finalizar a partida (derrotando "
    ++ "todos os inimigos) primeiro que o jogador, leva a vitória. Com o adicional, de que a máquina sofrerá do desafio dos espaços especiais, que se atingido todos, "
    ++ "o jogador é automaticamente o vitorioso da partida.\n\n"
    ++ "-> O jogo contará com sistema de salvamento dos estados da partida, com 3 slots disponíveis para escritura dos estados, e do sistema de Mercado "
    ++ "para comprar determinados itens, fomentando o seu arsenal, e ajudando-o a vencer a guerra, mas claro, respeitando a quantidade de moedas do jogador e o preço "
    ++ "dos itens, que variam de acordo com sua utilidade e impacto nas jogadas.\n\n"
    ++ "-> O jogador começará com uma quantidade de bombas pequenas limitadas, e poderá realizar compras de outros tipos de bombas pelo mercado.\n"
    ++ "Abaixo tem descrito o impacto de cada bomba no tabuleiro 12x12 do jogo:\n"
    ++ "\t--> Pequena => 1 quadrado | Média => 5 quadrados (formato de +) | Grande => 9 quadrados (formato de *)\n\n"
    ++ "-> Para cada espaço inimigo derrotado em sua completude (todas as partes que formam o mesmo sendo atingidas) o jogador ganha moedas na proporção do porte "
    ++ "do inimigo, e é contabilizado no mostrador na HUD do jogo (mesma lógica serve para o Bot/Oponente).\n\n"
    ++ "-> Para os inimigos, são divididos em Tanques (T - agrupados por 5 quadrados), Motorizados (M - agrupados por 3 quadrados) e Soldados inimigos (S - agrupados por 2 quadrados),"
    ++ " além dos espaços amigos que não podem ser atingidos, como Civis (C - 1 quadrado), Escolas (E - 1 quadrado) e Hospitais (H - 1 quadrado).\n\n"
    ++ "-> O jogador ainda contará com a sorte de acertar um Tesouro ($ - 1 quadrado), ganhando moedas pelo feito, ou o azar de acertar uma Mina Terrestre (# - 1 quadrado),"
    ++ " que explode a uma raio em formato de cruz `+` e que pode atingir qualquer espaço dentro desse raio, ajudando ou prejudicando o jogador.\n\n"


creditos :: String
creditos =
  "-> Disciplina: Paradigmas de Linguagens de Programação - Universidade Federal de Campina Grande (UFCG)\n"
    ++ "-> Professor: Everton L. G. Alves \n"
    ++ "-> Participantes: Caio Cesar Vieira Cavalcanti\n\t\t  João Pedro Azevedo do Nascimento\n\t\t  Valdemar Victor Leite Carvalho"
    ++ "\n\t\t  Wendel Silva Italiano de Araujo\n\n"
    ++ "-> Em nome de toda a equipe presente no projeto \"ByteFront: A Guerra dos Paradigmas\" para a disciplina Paradigmas de Linguagens de Programação, "
    ++ "desejamos uma ótima experiência de jogo, feito com esmero e carinho por todos.\n\n"