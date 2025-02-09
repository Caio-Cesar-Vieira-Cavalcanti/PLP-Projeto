--Tela Principal da HUD abaixo

main_screen :: IO()
main_screen = do
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


--Tela salvar jogo abaixo


--Tela mercado abaixo