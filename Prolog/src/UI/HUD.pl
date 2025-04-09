:- module(hud, [mainScreen/1, saveJogoScreen/0, mercadoScreen/1]).

:- use_module('./UtilsUI').
:- use_module('../Modelos/Jogo').
:- use_module('../Modelos/Tabuleiro').
:- use_module('../Modelos/Jogador').

% REVISAR (falta imprimir a tabela do bot) - inserir as futuras importações e dados do jogo!
% Inserir cortes

% Regra principal da HUD

mainScreen(Jogo) :-
    getJogador(Jogo, Jogador),
    % getBot(Jogo, Bot),
    getNome(Jogador, Nome),
    getTabelaJogador(Jogador, TabelaJogador),
    % getTabelaBot(Bot, TabelaBot),
    format('Jogador: ~w', [Nome]), nl, nl,
    mainTabela(Jogador), nl, nl,
    inimigosDestruidos(TabelaJogador, _), nl,
    espacosAmigosAtingidos(TabelaJogador, _), nl, nl,
    inventario(Jogador), nl, nl,
    moedas(Jogador), nl, nl,
    writeln('Atalhos:'),
    writeln('\'1\' -> Usar bomba pequena'),
    writeln('\'2\' -> Usar bomba média'),
    writeln('\'3\' -> Usar bomba grande'),
    writeln('\'4\' -> Usar o drone visualizador de áreas'),
    writeln('{COLUNA}{LINHA} -> Coordenada que deseja atacar; Exemplo: C3'),
    nl,
    writeln('\'m\' -> Acesso ao mercado'),
    writeln('\'s\' -> Salvar o jogo no estado atual'),
    writeln('\'q\' -> Sair do jogo sem salvar'),
    nl,
    write('> Digite a opção: ').

% Regras auxiliares para a tabela
inteiroParaString(N, S3) :-
    atom_number(A, N), 
    atom_string(A, S),
    string_concat(S, ' ', S2),
    (N < 10 -> string_concat(' ', S2, S3) ; S3 = S2).

adicionaNumeros(X, Y, _, []) :- Y is X + 1, !.
adicionaNumeros(NumLinhas, I, [H | T], [R | C]) :-
    I =< NumLinhas,
    I2 is I + 1,
    inteiroParaString(I, S),
    append([S], H, R),
    adicionaNumeros(NumLinhas, I2, T, C).

concatenaCabecalho(T, NewT) :-
    append([["   ", "A ", "B ", "C ", "D ", "E ", "F ", "G ", "H ", "I ", "J ", "K ", "L "]], T, NewT).

imprimiTabela([]) :- write("").
imprimiTabela([H | T]) :-
    atomic_list_concat(H, '', Str),
    writeln(Str),
    imprimiTabela(T).

% Regra principal da tabela 
mainTabela(Jogador) :-
    getTabelaJogador(Jogador, TabelaJogador),
    geraTabuleiroString(TabelaJogador, TabelaStr),
    adicionaNumeros(12, 1, TabelaStr, NewT),
    concatenaCabecalho(NewT, TabelaPronta),
    imprimiTabela(TabelaPronta).

% Tela salvar jogo
saveJogoScreen :-
    writeln('Escolha um slot para salvar:'), nl,
    saveStates(Estados),
    write(Estados). 

% Inventário
inventario(Jogador) :-
    getBombasPequenas(Jogador, BP),
    getBombasMedias(Jogador, BM),
    getBombasGrandes(Jogador, BG),
    getDroneVisualizador(Jogador, DV),
    writeln('Inventário:'),
    format('Bombas pequenas: ~w | Bombas médias: ~w | Bombas grandes: ~w', [BP, BM, BG]), nl,
    format('Drone visualizador de áreas: ~w', [DV]).

moedas(Jogador) :-
    getMoedas(Jogador, Moedas),
    format('Moedas: ~w', [Moedas]).

% Mercado
mercadoScreen(Jogo) :-
    logoMercado,
    getJogador(Jogo, Jogador),
    inventario(Jogador),
    nl, write('Atalhos:'), nl,
    format('\'1\' -> Comprar bombas médias               ($~d)~n', [250]),
    format('\'2\' -> Comprar bombas grandes              ($~d)~n', [400]),
    format('\'3\' -> Comprar drone visualizador de áreas ($~d)~n', [350]),
    nl, write('> Digite o item ou \'v\' para voltar: ').

% Regras auxiliares da HUD
inimigosDestruidos(TabelaJogador, _) :-
    contabilizarInimigos(TabelaJogador, InimigosJogador),
    % contabilizarInimigos(TabelaBot, InimigosBot),
    format('Inimigos: ~w/6', [InimigosJogador]),
    write('                                                       '),
    format('Inimigos do Oponente: ~w/6', [0]).

espacosAmigosAtingidos(TabelaJogador, _) :-
    contabilizarAmigos(TabelaJogador, AmigosJogador),
    % contabilizarAmigos(TabelaBot, AmigosBot),
    format('Espaços Amigos: ~w/3', [AmigosJogador]),
    write('                                                 '),
    format('Espaços Amigos do Oponente: ~w/3', [0]).

logoMercado :-
    writeln('  __  __                             _        '),
    writeln(' |  \\/  |  ___  _ __  ___  __ _   __| |  ___  '), 
    writeln(' | |\\/| | / _ \\| \'__|/ __|/ _` | / _` | / _ \\ '),
    writeln(' | |  | ||  __/| |  | (__| (_| || (_| || (_) |'),
    writeln(' |_|  |_| \\___||_|   \\___|\\__,_| \\__,_| \\___/ '),
    writeln('').
