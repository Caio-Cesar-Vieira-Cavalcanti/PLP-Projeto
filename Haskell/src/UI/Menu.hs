-- module Menu (logoMenu, opcoesMenu, novoJogo, carregarJogo, historiaJogo) where
import qualified UtilsUI

asciiArt :: String
asciiArt = unlines
    [ "  ____        _       _____                _   "
    , " | __ ) _   _| |_ ___|  ___| __ ___  _ __ | |_ "
    , " |  _ \\| | | | __/ _ \\ |_ | '__/ _ \\| '_ \\| __|"
    , " | |_) | |_| | ||  __/  _|| | | (_) | | | | |_ "
    , " |____/ \\__, |\\__\\___|_|  |_|  \\___/|_| |_|\\__|"
    , "        |___/                                  "
    , ""
    , "             A Guerra dos Paradigmas            "
    , ""
    , ""
    ]


logoMenu :: String
logoMenu = asciiArt ++ unlines 
    ["             Pressione a tecla \"Enter\""
    , ""
    , ""
    ]


opcoesMenu :: String
opcoesMenu = asciiArt ++ unlines
    ["             [1]. Novo Jogo"
    ,"             [2]. Carregar Jogo"
    ,"             [3]. História"
    ,"             [4]. Regras"
    ,"             [5]. Créditos"
    ,""
    ,"             [6]. Sair do Jogo"
    ,""
    ,"> Opção: "
    ]


novoJogo :: String
novoJogo = unlines
    ["             CARREGANDO O NOVO JOGO..."
    ,""
    ,""
    ,"> Digite o seu nome (ou 'v' para voltar ao menu) "
    ]


carregarJogo :: String
carregarJogo = unlines 
    ["Escolha um slot para carregar o estado do jogo:"
    ,""
    ] ++ UtilsUI.saveStates


historiaJogo :: String
historiaJogo = ""










-- Main provisório
main :: IO ()
main = putStr carregarJogo