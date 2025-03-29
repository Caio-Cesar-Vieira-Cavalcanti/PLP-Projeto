:- module(utils_ui, [opcaoInvalida/0, opcaoInvalidaVoltar/0, confirmacao/0, voltarMenu/0, defaultSlots/1]).

opcaoInvalida :- format('> Opcao invalida, digite novamente: ').

opcaoInvalidaVoltar :- format('> Opcao invalida, digite "v" para voltar: ').

confirmacao :- format('> Tem certeza? [S/N]: ').

voltarMenu :- format('> Digite "v" para voltar ao menu: ').

defaultSlots([
    '[1]. Slot 1 - Vazio',
    '[2]. Slot 2 - Vazio',
    '[3]. Slot 3 - Vazio'
]).

% Revisar ao fazer salvamento

/*
save_states(SlotsFormatados) :-
    pasta_bd("src/BD"),
    (   exists_directory(pasta_bd) ->
        directory_files(pasta_bd, Arquivos),
        sort(Arquivos, ArquivosOrdenados),
        maplist(formatar_save, ArquivosOrdenados, SaveSlots),
        corrigir_ordem_slots(SaveSlots, SlotsFormatados)
    ;   default_slots(DefaultSlots),
        append(DefaultSlots, ["", "> Digite o slot ou 'v' para voltar ao menu: "], SlotsFormatados)
    ).

formatar_save(Arquivo, (SlotNum, SlotFormatado)) :-
    atom_concat("src/BD/", Arquivo, CaminhoArquivo),
    carregar_save(CaminhoArquivo, JogoSalvo),
    atom_chars(Arquivo, Chars),
    include(is_digit, Chars, SlotNumChars),
    atom_chars(SlotNumAtom, SlotNumChars),
    atom_number(SlotNumAtom, SlotNum),
    (   JogoSalvo = jogo(Jogador, DataJogo) ->
        get_nome(Jogador, NomeJogador),
        format_time("%d/%m/%Y %H:%M", DataJogo, DataFormatada),
        format(atom(SlotFormatado), "[~w]. ~w - Jogo salvo em ~w", [SlotNum, NomeJogador, DataFormatada])
    ;   format(atom(SlotFormatado), "[~w]. Slot ~w - Vazio", [SlotNum, SlotNum])
    ).

corrigir_ordem_slots(Saves, SlotsCorrigidos) :-
    default_slots(DefaultSlots),
    maplist(find_or_default(Saves, DefaultSlots), [1,2,3], SlotsCorrigidos).

find_or_default(Saves, DefaultSlots, N, Slot) :-
    (   member((N, SlotEncontrado), Saves) -> Slot = SlotEncontrado
    ;   nth1(N, DefaultSlots, Slot)
    ).
*/