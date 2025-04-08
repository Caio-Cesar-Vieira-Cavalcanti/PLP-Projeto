:- module(menu_controlador, [iniciarMenu/0]).

:- use_module('../UI/HUD').
:- use_module('../UI/Menu').
:- use_module('../UI/UtilsUI').

:- use_module('../Modelos/Jogo').
:- use_module('../Modelos/Jogador').
:- use_module('../Modelos/Mercado').
:- use_module('../Modelos/Tabuleiro').
:- use_module('./GameOver').

:- use_module(library(lists)).
:- use_module(library(charsio)).
:- use_module(library(random)).

% Limpar a tela
clear_screen :- 
    write('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n').

% =========================================================================MENU================================================================================

iniciarMenu :-
    clear_screen,
    logoMenu,
    read_line_to_string(user_input, _),
    clear_screen,
    opcoesMenu,
    read_line_to_string(user_input, Opcao),
    processarOpcao(Opcao).

processarOpcao("1") :-
    clear_screen,
    novoJogo,
    read_line_to_string(user_input, NomeJogador),
    iniciarJogo(NomeJogador). 

processarOpcao("2") :-
    clear_screen,
    carregarJogo,
    read_line_to_string(user_input, Slot),
    (   member(Slot, ["1", "2","3"]) -> carregarJogo(Slot)
    ;   member(Slot, ["V", "v"]) -> subMenu
    ;   processarOpcao("2")).

processarOpcao("3") :-
    clear_screen,
    historiaJogo,
    processarSubOpcao.

processarOpcao("4") :-
    clear_screen,
    regrasJogo,
    processarSubOpcao.

processarOpcao("5") :-
    clear_screen,
    creditosJogo,
    processarSubOpcao.

processarOpcao("6") :-
    confirmacao,
    read_line_to_string(user_input, Opcao),
    (   member(Opcao, ["S", "s"]) -> clear_screen, writeln('Saindo do jogo...'), halt
    ;   subMenu).

processarOpcao(_) :-
    opcaoInvalida,
    read_line_to_string(user_input, Opcao),
    processarOpcao(Opcao).

% Regras auxiliares para voltar ao menu principal ou subopções dentro do menu
subMenu :-
    clear_screen,
    opcoesMenu,
    read_line_to_string(user_input, Opcao),
    processarOpcao(Opcao).

processarSubOpcao :-
    read_line_to_string(user_input, Opcao),
    (   member(Opcao, ["V", "v"]) -> clear_screen, subMenu
    ;   voltarMenu, processarSubOpcao).

% =========================================================================JOGO================================================================================

iniciarJogo(NomeJogador) :-
    inicializarJogo(NomeJogador, Jogo),
    loopJogo(Jogo).

carregarJogo(Numero) :-
    string_concat('../BD/save', Numero, Caminho),
    carregarSave(Caminho, Resultado),
    loopJogo(Resultado).
carregarJogo(_) :-
    writeln('Erro: Não foi possível carregar o jogo.'),
    iniciarMenu.

loopJogo(Jogo) :- 
    clear_screen,
    mainScreen(Jogo),
    verificaVitoriaDerrotaPlayer(Jogo, GameOver),
    (
        GameOver == true ->
            processarSubOpcao
        ;
            read_line_to_string(user_input, Opcao),
            processarOpcaoLoop(Opcao, Jogo)
    ).

processarOpcaoLoop("1", Jogo) :-
    getJogador(Jogo, Jogador),
    getTabelaJogador(Jogador, TabelaAtual),
    desfazVisualizacaoDrone(TabelaAtual, TabelaSemDrone),
    (
        TabelaSemDrone \= TabelaAtual ->
            setTabelaJogador(Jogador, TabelaSemDrone, NovoJogador),
            setJogador(Jogo, NovoJogador, NovoJogo),
            processarOpcaoLoop("1", NovoJogo)
    ;
        getBombasPequenas(Jogador, BP),
        BP =< 0 ->
            loopJogo(Jogo)
    ;
        inputCoordenada(ColunaStr, Linha),
        getIndexColuna(['A','B','C','D','E','F','G','H','I','J','K','L'], ColunaStr, 0, ColunaIndex),
        LinhaIndex is Linha - 1,
        mainAtirouNaCoordenada(TabelaAtual, LinhaIndex, ColunaIndex, NovaTabelaJog, NovasMoedas),

        random_between(0, 143, R),
        getMoedas(Jogador, MoedasAtuais),
        NovoTotalMoedas is MoedasAtuais + NovasMoedas,
        getBombasPequenas(Jogador, BP),
        NovoNumBombas is BP - 1,

        setTabelaJogador(Jogador, NovaTabelaJog, JogadorTemp1),
        setBombasPequenas(JogadorTemp1, NovoNumBombas, JogadorTemp2),
        setMoedas(JogadorTemp2, NovoTotalMoedas, NovoJogador),

        % Aqui o bot deveria jogar
        getBot(Jogo, Bot),
        % jogarBot(Bot, R, NovoBot),

        getMercado(Jogo, Mercado),
        getDataJogo(Jogo, DataJogo),
        JogoAtualizado = jogo(NovoJogador, Bot, Mercado, DataJogo),
        loopJogo(JogoAtualizado)
    ).

processarOpcaoLoop("2", Jogo) :-
    getJogador(Jogo, Jogador),
    getTabelaJogador(Jogador, TabelaAtual),
    desfazVisualizacaoDrone(TabelaAtual, TabelaSemDrone),
    (
        TabelaSemDrone \= TabelaAtual ->
            setTabelaJogador(Jogador, TabelaSemDrone, NovoJogador),
            setJogador(Jogo, NovoJogador, NovoJogo),
            processarOpcaoLoop("2", NovoJogo)
    ;
        getBombasMedias(Jogador, BM),
        BM =< 0 ->
            loopJogo(Jogo)
    ;
        inputCoordenada(ColunaStr, Linha),
        getIndexColuna(['A','B','C','D','E','F','G','H','I','J','K','L'], ColunaStr, 0, ColunaIndex),
        LinhaIndex is Linha - 1,
        tiroBombaMedia(TabelaAtual, LinhaIndex, ColunaIndex, NovaTabelaJog, NovasMoedas),

        random_between(0, 143, R),
        getMoedas(Jogador, MoedasAtuais),
        NovoTotalMoedas is MoedasAtuais + NovasMoedas,
        getBombasMedias(Jogador, BM),
        NovoNumBombas is BM - 1,

        setTabelaJogador(Jogador, NovaTabelaJog, JogadorTemp1),
        setBombasMedias(JogadorTemp1, NovoNumBombas, JogadorTemp2),
        setMoedas(JogadorTemp2, NovoTotalMoedas, NovoJogador),

        % Aqui o bot deveria jogar
        getBot(Jogo, Bot),
        % jogarBot(Bot, R, NovoBot),

        getMercado(Jogo, Mercado),
        getDataJogo(Jogo, DataJogo),
        JogoAtualizado = jogo(NovoJogador, Bot, Mercado, DataJogo),
        loopJogo(JogoAtualizado)
    ).

processarOpcaoLoop("3", Jogo) :-
    getJogador(Jogo, Jogador),
    getTabelaJogador(Jogador, TabelaAtual),
    desfazVisualizacaoDrone(TabelaAtual, TabelaSemDrone),
    (
        TabelaSemDrone \= TabelaAtual ->
            setTabelaJogador(Jogador, TabelaSemDrone, NovoJogador),
            setJogador(Jogo, NovoJogador, NovoJogo),
            processarOpcaoLoop("3", NovoJogo)
    ;
        getBombasGrandes(Jogador, BG),
        BG =< 0 ->
            loopJogo(Jogo)
    ;
        inputCoordenada(ColunaStr, Linha),
        getIndexColuna(['A','B','C','D','E','F','G','H','I','J','K','L'], ColunaStr, 0, ColunaIndex),
        LinhaIndex is Linha - 1,
        tiroBombaGrande(TabelaAtual, LinhaIndex, ColunaIndex, NovaTabelaJog, NovasMoedas),

        random_between(0, 143, R),
        getMoedas(Jogador, MoedasAtuais),
        NovoTotalMoedas is MoedasAtuais + NovasMoedas,
        getBombasGrandes(Jogador, BG),
        NovoNumBombas is BG - 1,

        setTabelaJogador(Jogador, NovaTabelaJog, JogadorTemp1),
        setBombasGrandes(JogadorTemp1, NovoNumBombas, JogadorTemp2),
        setMoedas(JogadorTemp2, NovoTotalMoedas, NovoJogador),

        % Aqui o bot deveria jogar
        getBot(Jogo, Bot),
        % jogarBot(Bot, R, NovoBot),

        getMercado(Jogo, Mercado),
        getDataJogo(Jogo, DataJogo),
        JogoAtualizado = jogo(NovoJogador, NovoBot, Mercado, DataJogo),
        loopJogo(JogoAtualizado)
    ).

processarOpcaoLoop("4", Jogo) :-
    getJogador(Jogo, Jogador),
    getDroneVisualizador(Jogador, NumDrones),
    (
        NumDrones =< 0 ->
            loopJogo(Jogo)
    ;
        inputCoordenada(ColunaStr, Linha),
        getTabelaJogador(Jogador, TabelaAtual),
        getIndexColuna(['A','B','C','D','E','F','G','H','I','J','K','L'], ColunaStr, 0, ColunaIndex),
        LinhaIndex is Linha - 1,

        drone(TabelaAtual, ColunaIndex, LinhaIndex, NovaTabelaJog),

        NovoNumDrones is NumDrones - 1,
        setTabelaJogador(Jogador, NovaTabelaJog, JogadorTemp),
        setDroneVisualizador(JogadorTemp, NovoNumDrones, NovoJogador),

        getBot(Jogo, Bot),
        getMercado(Jogo, Mercado),
        getDataJogo(Jogo, DataJogo),
        JogoAtualizado = jogo(NovoJogador, Bot, Mercado, DataJogo),
        loopJogo(JogoAtualizado)
    ).  

processarOpcaoLoop("m", Jogo) :- 
    clear_screen,
    mercadoScreen(Jogo),
    read_line_to_string(user_input, Item),
    ( member(Item, ["1", "2", "3"]) ->
        getJogador(Jogo, Jogador),
        getMercado(Jogo, Mercado),
        comprarItem(Jogador, Mercado, Item, NovoJogador),
        setJogador(Jogo, NovoJogador, NovoJogo),
        loopJogo(NovoJogo)
    ; processarSubOpcaoLoop(Jogo, Item)
    ).

processarOpcaoLoop("s", Jogo) :-
    clear_screen,
    saveJogoScreen,
    read_line_to_string(user_input, Slot),
    atom_concat("../BD/save", Slot, Caminho),
    ( member(Slot, ["1", "2", "3"]) ->
        confirmacao,
        confirmacaoSalvamento(Caminho, Jogo, Slot)
    ; processarSubOpcaoLoop(Jogo, Slot)
    ).

processarOpcaoLoop("q", Jogo) :- 
    confirmacao,
    read_line_to_string(user_input, Opcao),
    ( member(Opcao, ["S", "s"]) ->
        subMenu
    ; write("> Digite a opção: "),
      read_line_to_string(user_input, NovaOpcao),
      processarOpcaoLoop(NovaOpcao, Jogo)
    ).

processarOpcaoLoop(_, Jogo) :-
    opcaoInvalida,
    read_line_to_string(user_input, Opcao),
    processarOpcaoLoop(Opcao, Jogo).

% Funções auxiliares JOGO

processarSubOpcaoLoop(Jogo, Opcao) :-
    member(Opcao, ["V", "v"]),
    loopJogo(Jogo).

processarSubOpcaoLoop(Jogo, _) :-
    opcaoInvalidaVoltar,
    read_line_to_string(user_input, NovaOpcao),
    processarSubOpcaoLoop(Jogo, NovaOpcao).

confirmacaoSalvamento(Caminho, Jogo, Slot) :-
    read_line_to_string(user_input, Opcao),
    ( member(Opcao, ["S", "s"]) ->
        clear_screen,
        salvarJogo(Caminho, Jogo),
        carregarJogo(Slot)
    ; loopJogo(Jogo)
    ).

getIndexColuna([H|_], H, Index, Index).
getIndexColuna([_|T], Elem, CurrIndex, Index) :-
    NextIndex is CurrIndex + 1,
    getIndexColuna(T, Elem, NextIndex, Index).

inputCoordenada(ColunaChar, Numero) :-
    write('> Digite a coordenada (ex: A5): '),
    read_line_to_string(user_input, Input),
    (
        validarCoordenada(Input) ->
            string_chars(Input, [LetraChar | Digitos]),
            ColunaChar = LetraChar, 
            atom_chars(AtomNumero, Digitos),
            atom_number(AtomNumero, Numero)
        ;
            opcaoInvalida, nl,
            inputCoordenada(ColunaChar, Numero)
    ).

validarCoordenada(Coordenada) :-
    string_chars(Coordenada, [LetraChar | Digitos]),
    char_type(LetraChar, upper),
    member(LetraChar, ['A','B','C','D','E','F','G','H','I','J','K','L']),
    Digitos \= [],
    maplist(char_type_digit, Digitos),
    atom_chars(AtomNumero, Digitos),
    atom_number(AtomNumero, NumLinha),
    NumLinha >= 1,
    NumLinha =< 12.

char_type_digit(C) :- char_type(C, digit).