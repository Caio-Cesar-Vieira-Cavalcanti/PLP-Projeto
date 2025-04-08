:- module(telas_vitoria_derrota, [
    winScreen/1,
    loseScreen/1
]).

:- use_module('./UtilsUI').

% REVISAR O USO DO HALT

winScreen(NomeJogador) :-
    format('                                                            ~n', []),
    format('                                                            ~n', []),
    format('   Parabens ~w, Voce venceu a Guerra dos Paradigmas!   ~n', [NomeJogador]),
    format('                                                            ~n', []),
    format('               Prologia agradece seu heroismo!           ~n', []),
    format('                                                            ~n', []),
    format('~n', []),
    voltarMenu,
    halt.

loseScreen(MotivoDerrota) :-
    format('                                                            ~n', []),
    format('                                                            ~n', []),
    format('                       GAME OVER!                           ~n', []),
    format('                                                            ~n', []),
    format('    - Motivo da derrota: ~w            ~n', [MotivoDerrota]),
    format('                                                            ~n', []),
    format('                                                            ~n', []),
    format('~n', []),
    voltarMenu,
    halt.
