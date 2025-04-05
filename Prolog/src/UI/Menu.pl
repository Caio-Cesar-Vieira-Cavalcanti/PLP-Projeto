:- module(menu, [logoMenu/0, opcoesMenu/0, novoJogo/0, carregarJogo/0,
                    historiaJogo/0, regrasJogo/0, creditosJogo/0]).

:- use_module('./UtilsUI').

% Tela do Menu

logoMenu :-
    asciiArt,
    format('             Pressione a tecla "Enter"~n~n~n').

opcoesMenu :-
    asciiArt,
    format('             [1]. Novo Jogo~n'),
    format('             [2]. Carregar Jogo~n'),
    format('             [3]. História~n'),
    format('             [4]. Regras~n'),
    format('             [5]. Créditos~n'),
    format('~n'),
    format('             [6]. Sair do Jogo~n~n'),
    format('> Opção: ').

novoJogo :-
    format('~n             CARREGANDO O NOVO JOGO...~n~n~n'),
    format('> Digite o seu nome: ').

carregarJogo :-
    format('Escolha um slot para carregar o estado do jogo:~n~n'), nl,
    saveStates(Estados),
    write(Estados). 

historiaJogo :-
    historiaArt,
    historia,
    voltarMenu.

regrasJogo :-
    regrasArt,
    regras,
    voltarMenu.

creditosJogo :-
    creditosArt,
    creditos,
    voltarMenu.

% Funções auxiliares

asciiArt :-
    writeln('  ____        _       _____                _   '),
    writeln(' | __ ) _   _| |_ ___|  ___| __ ___  _ __ | |_ '),
    writeln(' |  _ \\| | | | __/ _ \\ |_ | |__/ _ \\| |_ \\| __|'),
    writeln(' | |_) | |_| | ||  __/  _|| | | (_) | | | | |_ '),
    writeln(' |____/ \\__, |\\__\\___|_|  |_|  \\___/|_| |_|\\__|'),
    writeln('        |___/                                  '),
    writeln(''),
    writeln('             A Guerra dos Paradigmas            '),
    writeln(''),
    writeln('').

historiaArt :-
    writeln('  _   _ _     _             _       '),
    writeln(' | | | (_)___| |_ ___  _ __(_) __ _ '),
    writeln(' | |_| | / __| __/ _ \\|| __| |/ _` |'),
    writeln(' |  _  | \\__ \\ || (_) | |  | | (_| |'),
    writeln(' |_| |_|_|___/\\__\\___/|_|  |_|\\__,_|'),
    writeln('                                     '),
    writeln('').

regrasArt :-
    writeln('  ____                          '),
    writeln(' |  _ \\ ___  __ _ _ __ __ _ ___ '),
    writeln(' | |_) / _ \\/ _` |  |__/ _` / __|'),
    writeln(' |  _ <  __/ (_| | | | (_| \\__ \\'),
    writeln(' |_| \\_\\___|\\__, |_|  \\__,_|___/'),
    writeln('            |___/               '),
    writeln('').

creditosArt :-
    writeln('   ____              _ _ _            '),
    writeln('  / ___|_ __ ___  __| (_) |_ ___  ___ '),
    writeln(' | |   | |__/ _ \\/ _` | | __/ _ \\/ __|'),
    writeln(' | |___| | |  __/ (_| | | || (_) \\__ \\'),
    writeln('  \\____|_|  \\___|\\__,_|_|\\__\\___/|___/'),
    writeln('                                      '),
    writeln('').

historia :-
    writeln('-> No coração da pequena cidade do Império de Prologia, o equilíbrio entre tradição e progresso é abalado por uma invasão iminente.'),
    writeln('A república de Haskelland, nação vizinha e rival de longa data, por diferenças de paradigmas, inicia uma ofensiva estratégica para tomar'),
    writeln('o controle da cidade rica em Silício, um recurso valioso para a construção de processadores na indústria de computadores voltados para o uso militar.\n'),
    writeln('-> Você joga como um piloto renomado de aviões bombardeiros do exército de Prologia, que serve como a última esperança para combater os inimigos da'),
    writeln('República de Haskelland. Munido de poucos recursos, e sem ferir os direitos impostos pela Convenção de Genebra, em proteção dos civis de Prologia,'),
    writeln('o que poderá diminuir sua sanidade em caso de transgressão, como atingir espaços especiais.\n'),
    writeln('-> Em meio a escolhas morais difíceis, você deve decidir entre proteger o máximo de cidadãos e construções civis, a qualquer custo, ou priorizar a'),
    writeln('vitória estratégica. O destino da realeza do paradigma lógico de Prologia está em suas mãos: será uma vitória lembrada por gerações, ou a'),
    writeln('ruína total de uma cidade consumida pela guerra.\n').

regras :-
    writeln('-> O jogador precisará derrotar todos os inimigos, cada um com seu porte, de Pequeno, Médio e/ou Grande, sem esgotar os seus recursos'),
    writeln('e muito menos, sem atingir todos os espaços amigos - representados por Civis/Hospitais/Escolas - que se concretizado, o jogador é derrotado por'),
    writeln('Falta de Recursos ou Perda de Sanidade, respectivamente.\n'),
    writeln('-> Além dessas duas formas de derrotas, o jogador contará com a derrota pela máquina, o seu oponente, que se finalizar a partida (derrotando'),
    writeln('todos os inimigos) primeiro que o jogador, leva a vitória. Com o adicional, de que a máquina sofrerá do desafio dos espaços amigos (Perda de Sanidade),'),
    writeln('que se atingido todos, o jogador é automaticamente o vitorioso da partida.\n'),
    writeln('-> O jogo contará com sistema de salvamento dos estados da partida, com 3 slots disponíveis para escritura dos estados, e do sistema de Mercado'),
    writeln('para comprar determinados itens, fomentando o seu arsenal, e ajudando-o a vencer a guerra, mas claro, respeitando a quantidade de moedas do jogador e o preço'),
    writeln('dos itens, que variam de acordo com sua utilidade e impacto nas jogadas.\n'),
    writeln('-> O jogador começará com uma quantidade de bombas pequenas limitadas, e poderá realizar compras de outros tipos de bombas pelo mercado.\n'),
    writeln('Abaixo tem descrito o impacto de cada bomba no tabuleiro 12x12 do jogo:\n'),
    writeln('\t--> Pequena => 1 quadrado | Média => 5 quadrados (formato de +) | Grande => 9 quadrados (formato de *)\n'),
    writeln('-> Para cada espaço inimigo derrotado (as partes que o formam por completo) o jogador ganha moedas na proporção do porte'),
    writeln('do inimigo, e é contabilizado no mostrador de "Moedas" na HUD do jogo.\n'),
    writeln('-> Para os inimigos, são divididos em Tanques (T - agrupados por 5 quadrados), Motorizados (M - agrupados por 3 quadrados) e Soldados inimigos (S - agrupados por 2 quadrados),'),
    writeln('além dos espaços amigos, como Civis (C - 1 quadrado), Escolas (E - 1 quadrado) e Hospitais (H - 1 quadrado), que devem ser evitados como alvo de cada jogada.\n'),
    writeln('-> O jogador ainda contará com a sorte de acertar um Tesouro ($ - 1 quadrado), ganhando moedas pelo feito, ou o azar de acertar uma Mina Terrestre (# - 1 quadrado),'),
    writeln('que explode a uma raio em formato de "+" (semelhante a bomba média) e que pode atingir qualquer espaço dentro desse raio, ajudando ou prejudicando o jogador.\n'),
    writeln('-> Como extra, o jogo implementa um item que pode ajudar o jogador, se o mesmo o usar com sabedoria: Drone Visualizador - Quer saber como funciona? Então vamos'),
    writeln('entrar nesta batalha AGORA!\n').

creditos :-
    writeln('-> Disciplina: Paradigmas de Linguagens de Programação - Universidade Federal de Campina Grande (UFCG)'),
    writeln('-> Professor: Everton L. G. Alves'),
    writeln('-> Participantes: Caio Cesar Vieira Cavalcanti\n\t\t  João Pedro Azevedo do Nascimento\n\t\t  Valdemar Victor Leite Carvalho'),
    writeln('\t\t  Wendel Silva Italiano de Araujo\n\n'),
    writeln('-> Em nome de toda a equipe presente no projeto "ByteFront: A Guerra dos Paradigmas" para a disciplina "Paradigmas de Linguagens de Programação",'),
    writeln('desejamos uma ótima experiência de jogo, feito com esmero e carinho por todos.\n\n').