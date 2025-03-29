:- module(menu_controlador, [iniciarMenu/0]).

:- use_module('../UI/HUD.pl').
:- use_module('../UI/Menu.pl').
:- use_module('../UI/UtilsUI.pl').

% AUSENTE A IMPORTAÇÃO DOS MODELOS E DEMAIS ARQUIVOS NECESSÁRIOS!

% Limpar a tela
clear_screen :- 
    write('\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n').

% =========================================================================MENU================================================================================

iniciarMenu :-
    clear_screen,
    logoMenu,
    read_line_to_string(user_input, _),
    clear_screen,
    opcoesMenu,
    read_line_to_string(user_input, Opcao),
    processarOpcao(Opcao).

/* 
Criar lógica de iniciar um jogo 
processarOpcao("1") :-
    clear_screen,
    novoJogo,
    read_line_to_string(user_input, NomeJogador),
    iniciarJogo(NomeJogador).

Criar lógica de carregar um jogo (BD)
processarOpcao("2") :-
    clear_screen,
    carregarJogo,
    read_line_to_string(user_input, Slot),
    (   member(Slot, ["1", "2","3"]) -> carregarJogo(Slot)
    ;   member(Slot, ["V", "v"]) -> subMenu
    ;   processarOpcao("2")).
*/

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


    





