module UtilsUI where

-- Funções utilitárias para as interfaces

confirmacao :: String
confirmacao = "> Tem certeza? [S/N]: "

voltarMenu :: String
voltarMenu = "> Digite 'v' para voltar ao menu: "

saveStates :: String
saveStates = unlines
    ["[1]. Slot 1 - Vazio"
    ,"[2]. {nome jogador} - Jogo salvo em {data}"
    ,"[3]. Slot 3 - Vazio"
    ,""
    ,""
    ,"> Digite o slot ou 'v' para voltar: "
    ]