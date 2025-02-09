-- Tela Principal da HUD 

mainScreen :: IO()
mainScreen = do
    -- let jogador = "Neymar"
    -- let primeira_linha = "          Jogador: " ++ jogador ++ "          Oponente: Bot"
    -- putStrLn primeira_linha
    let inimigosDerrotados = 4
    let inimigosTotais = 10
    putStrLn ("Inimigos: " ++ show inimigosDerrotados ++ "/" ++ show inimigosTotais)


    let espacosAtingidos = 3
    let espacosTotais = 12
    putStrLn ("Espaços especiais: " ++ show espacosAtingidos ++ "/" ++ show espacosTotais)


    let minasOuroAtingidas = 2
    let minasOuroTotais = 5
    putStrLn ("Minas de ouro: " ++ show minasOuroAtingidas ++ "/" ++ show minasOuroTotais)
    
    putStrLn ""

    mostraInventario
    
    putStrLn ""

    putStrLn "Atalhos: "
    putStrLn "'1' -> Usar bombas pequenas"
    putStrLn "'2' -> Usar bombas médias"
    putStrLn "'3' -> Usar bombas grandes"
    putStrLn "{COLUNAS}{LINHA} -> Coordenada que deseja atacar; Exemplo: C3"
    putStrLn "'4' -> Usar o drone visualizador de áreas"
    putStrLn "'m' -> Acesso ao mercado"
    putStrLn "'s' -> Salvar o jogo no estado atual"
    putStrLn "'quit' -> Sair do jogo sem salvar"
    
    putStrLn ""

    putStr "> Digite a opção ou coordenadas:"

-- Tela Salvar Jogo

saveJogoScreen :: IO ()
saveJogoScreen = do
    putStrLn "Escolha um slot para salvar:"
    
    putStrLn ""

    putStrLn "[1] Slot 1 - Vazio"
    putStrLn "{nome jog.} - Jogo Salvo em {data}"
    putStrLn "{nome jog.} - Jogo Salvo em {data}"
    
    putStrLn ""

    putStr "> Digite o slot ou 'v' para voltar: "

-- Tela Mercado 

mercadoScreen :: IO ()
mercadoScreen = do

    putStrLn "  __  __                             _        "
    putStrLn " |  \x5C/  |  ___  _ __  ___  __ _   __| |  ___  "
    putStrLn " | |\x5C/| | / _ \x5C| '__|/ __|/ _` | / _` | / _ \x5C "
    putStrLn " | |  | ||  __/| |  | (__| (_| || (_| || (_) |"
    putStrLn " |_|  |_| \x5C___||_|   \x5C___|\x5C__,_| \x5C__,_| \x5C___/ "

    putStrLn ""

    mostraInventario
    
    putStrLn ""

    putStrLn "Atalhos:"
    
    putStrLn ""

    putStrLn "'1' -> Comprar bombas pequenas             ({preço})"
    putStrLn "'2' -> Comprar bombas médias               ({preço})"
    putStrLn "'3' -> Comprar bombas grandes              ({preço})"
    putStrLn "'4' -> Comprar drone visualizador de áreas ({preço})"

    putStrLn ""

    putStr "> Digite o item ou 'v' para voltar:"

-- Funções utilitárias

mostraInventario :: IO ()
mostraInventario = do
    putStrLn "Inventário:"
    
    let bombasPequenas = 3
    let bombasMedias = 1
    let bombasGrandes = 0
    putStrLn ("Bombas pequenas: " ++ show bombasPequenas ++ " | Bombas médias: " ++ show bombasMedias ++ " | Bombas grandes: " ++ show bombasGrandes)

    let drones = 2
    putStrLn ("Drone visualizador de áreas: " ++ show drones)

    putStrLn ""
    
    let moedas = 25
    putStrLn ("Moedas: " ++ show moedas)