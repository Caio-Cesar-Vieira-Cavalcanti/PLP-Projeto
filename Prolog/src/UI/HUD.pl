:- module(hud, [mainScreen/1, saveJogoScreen/0, mercadoScreen/1]).

:- use_module('./UtilsUI').

:- use_module('../Modelos/Jogo').
:- use_module('../Modelos/Tabuleiro').
:- use_module('../Modelos/Jogador').
:- use_module('../Modelos/Bot').

% Regra principal da HUD

mainScreen(Jogo) :-
    getJogador(Jogo, Jogador),
    getNome(Jogador, Nome),
    getTabelaJogador(Jogador, TabelaJogador),
    getBot(Jogo, Bot),
    getTabelaBot(Bot, TabelaBot),
    format('Jogador: ~w', [Nome]),
    write('                           '),
    write('Oponente: República de Haskelland'), nl, nl,
    mainTabela(TabelaJogador, TabelaBot), nl, nl,
    inimigosDestruidos(TabelaJogador, TabelaBot), nl,
    espacosAmigosAtingidos(TabelaJogador, TabelaBot), nl, nl,
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

% Nova regra para imprimir duas tabelas lado a lado

imprimiTabelasLadoALado([], []) :- !.
imprimiTabelasLadoALado([H1 | T1], [H2 | T2]) :-
    atomic_list_concat(H1, '', Str1),
    atomic_list_concat(H2, '', Str2),
    format('~w         ~w~n', [Str1, Str2]),
    imprimiTabelasLadoALado(T1, T2).

% Nova regra principal

mainTabela(TabelaJogador, TabelaBot) :-
    geraTabuleiroString(TabelaJogador, TabelaStrJogador),
    geraTabuleiroString(TabelaBot, TabelaStrBot),

    adicionaNumeros(12, 1, TabelaStrJogador, NumJogador),
    adicionaNumeros(12, 1, TabelaStrBot, NumBot),

    concatenaCabecalho(NumJogador, TabelaFinalJogador),
    concatenaCabecalho(NumBot, TabelaFinalBot),

    imprimiTabelasLadoALado(TabelaFinalJogador, TabelaFinalBot).


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

inimigosDestruidos(TabelaJogador, TabelaBot) :-
    contabilizarInimigos(TabelaJogador, InimigosJogador),
    contabilizarInimigos(TabelaBot, InimigosBot),
    format('Inimigos: ~w/6', [InimigosJogador]),
    write('                        '),
    format('Inimigos do Oponente: ~w/6', [InimigosBot]).

espacosAmigosAtingidos(TabelaJogador, TabelaBot) :-
    contabilizarAmigos(TabelaJogador, AmigosJogador),
    contabilizarAmigos(TabelaBot, AmigosBot),
    format('Espaços Amigos: ~w/3', [AmigosJogador]),
    write('                 '),
    format('Espaços Amigos do Oponente: ~w/3', [AmigosBot]).

logoMercado :-
    writeln('  __  __                             _        '),
    writeln(' |  \\/  |  ___  _ __  ___  __ _   __| |  ___  '), 
    writeln(' | |\\/| | / _ \\| \'__|/ __|/ _` | / _` | / _ \\ '),
    writeln(' | |  | ||  __/| |  | (__| (_| || (_| || (_) |'),
    writeln(' |_|  |_| \\___||_|   \\___|\\__,_| \\__,_| \\___/ '),
    writeln('').
