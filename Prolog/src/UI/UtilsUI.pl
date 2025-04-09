:- module(utils_ui, [opcaoInvalida/0, opcaoInvalidaVoltar/0, confirmacao/0, voltarMenu/0, defaultSlots/1, saveStates/1]).

:- use_module(library(filesex)).
:- use_module(library(apply)).
:- use_module(library(lists)).
:- use_module(library(readutil)).

:- use_module('../Modelos/Jogo').
:- use_module('../Modelos/Jogador').

opcaoInvalida :- format('> Opcao invalida, digite novamente: ').

opcaoInvalidaVoltar :- format('> Opcao invalida, digite "v" para voltar: ').

confirmacao :- format('> Tem certeza? [S/N]: ').

voltarMenu :- format('> Digite "v" para voltar ao menu: ').

defaultSlots([
    '[1]. Slot 1 - Vazio',
    '[2]. Slot 2 - Vazio',
    '[3]. Slot 3 - Vazio'
]).

% Função principal: retorna lista formatada dos slots

saveStates(TextoFinal) :-
    Pasta = '../BD',
    Arquivo1 = '../BD/save1',
    Arquivo2 = '../BD/save2',
    Arquivo3 = '../BD/save3',
    ( (exists_file(Arquivo1) ; exists_file(Arquivo2) ; exists_file(Arquivo3)) ->
        directory_files(Pasta, ArquivosBrutos),
        include(arquivoSave, ArquivosBrutos, Arquivos),
        maplist(formatarSave(Pasta), Arquivos, Saves),
        corrigirOrdemSlots(Saves, SlotsCorrigidos),
        append(SlotsCorrigidos, ['', '> Digite o slot ou "v" para voltar ao menu: '], Todos),
        atomic_list_concat(Todos, '\n', TextoComQuebra),
        atom_string(TextoComQuebra, TextoFinal)
    ; defaultSlots(Slots),
      append(Slots, ['', '> Digite o slot ou "v" para voltar ao menu: '], Todos),
      atomic_list_concat(Todos, '\n', TextoComQuebra),
      atom_string(TextoComQuebra, TextoFinal)
    ).


% Verifica se o arquivo é um save válido

arquivoSave(Nome) :-
    sub_atom(Nome, _, _, _, 'save').

% Formata um save carregado
formatarSave(Pasta, Arquivo, (SlotNum, TextoFinal)) :-
    atomic_list_concat([Pasta, '/', Arquivo], Caminho),
    carregarSave(Caminho, jogo(Jogador, _, _, DataJogoAtom)),
    once((
        parse_time(DataJogoAtom, iso_8601, Timestamp) ->
            format_time(atom(DataAtom), '%d/%m/%Y %H:%M', Timestamp),
            atom_string(DataAtom, DataFormatada)
        ;
            DataFormatada = "Data inválida"
    )),
    getNome(Jogador, NomeJogador),
    extraiNumeroSlot(Arquivo, SlotNum),
    format(string(TextoFinal), "[~w]. ~w - Jogo salvo em ~w", [SlotNum, NomeJogador, DataFormatada]).

% Extrai o número do slot a partir do nome do arquivo

extraiNumeroSlot(NomeArq, Num) :-
    atom_chars(NomeArq, Chars),
    include(char_type_digit, Chars, Digits),
    atom_chars(DigitsAtom, Digits),
    atom_number(DigitsAtom, Num), !.
extraiNumeroSlot(_, 0).

char_type_digit(Char) :- char_type(Char, digit).

% Corrige a ordem dos slots e preenche os vazios

corrigirOrdemSlots(Saves, Corrigidos) :-
    defaultSlots(Default),
    find_slot(Saves, 1, S1, Default),
    find_slot(Saves, 2, S2, Default),
    find_slot(Saves, 3, S3, Default),
    Corrigidos = [S1, S2, S3].

find_slot(Saves, N, Texto, Default) :-
    ( member((N, Texto), Saves) -> true
    ; nth1(N, Default, Texto)
    ).