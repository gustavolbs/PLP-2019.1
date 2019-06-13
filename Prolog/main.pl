/* FUNCIONALIDADES

--- Feito ---
Menu Inicial
Instrucoes
Cria Partida

--- Em Andamento ---
SinglePlayer
MultiPlayer
Ler Perguntas


--- A Fazer ---
Todo o resto kkkkkk

*/

:- initialization main.

/* Main */
main:-
    menu,
    le_inteiro(Escolha),
    verifica_escolha(Escolha).

/* Predicados auxiliares */
menu:-
    writeln("===== PerguntUP ====="),
    writeln("by GERIGE"),
    writeln("(1) Ver as instrucoes"),
    writeln("(2) Seguir para o jogo"),
    writeln("(3) Exibir o ranking"),
    writeln("(4) Sair"),
    writeln("Escolha:").

le_inteiro(Entrada):-
    read_line_to_codes(user_input, Codes),
    string_to_atom(Codes, Atom),
    atom_number(Atom, Entrada).

/*#################################*/
/* INICIALIZACAO -- INICIALIZACAO -- INICIALIZACAO */

/* Direciona a execucao do programa */
verifica_escolha(Escolha):-
    Escolha == 1 -> (instrucoes) ;
    Escolha == 2 -> (inicializa_partida_menu) ;
    Escolha == 3 -> (ranking(Resultado), writeln(Resultado)) ;
    Escolha == 4 -> (writeln("Obrigado por jogar! :)")) ;
    main.


/* Exibe Instrucoes */
instrucoes:-
    writeln("\n===== Instrucoes =====\nO PerguntUP eh um jogo de perguntas que pode ser jogado de duas maneiras:\n-> Singleplayer ou Multiplayer\nCada partida possui 12 perguntas, divididas em 4 areas de conhecimento:\n- Ciencias da Natureza\n- Linguagens\n- Ciencias Exatas\n- Ciencias Humanas\nAlem disso, havera dicas limitadas disponiveis:\n- Eliminar alternativas: elimina duas alternativas\n- Opiniao dos internautas: mostra a porcentagem de concordancia com cada alternativa\n- Pular pergunta: pula para a proxima pergunta\nA cada inicio de partida, voce tera 1 dica de cada\nAlem disso, o sistema conta com um ranking com as 10 melhores pontuacoes. Ele e exibido no inicio e no final de cada partida\n"),
    main.

/* Inicializa partida */
inicializa_partida_menu:-
    writeln("\nDeseja iniciar uma nova partida?\n(1) Sim\n(2) Nao\nEscolha:"),
    le_inteiro(Escolha),
    (Escolha == 1 -> (modo_de_jogo) ;
    Escolha == 2 -> (writeln("Valeu, ate mais!\n"), main) ;
    (writeln("Opcao Invalida"), inicializa_partida_menu)).

/* Constroi Ranking */
/* A fazer */
ranking(Resultado):-
    Resultado is "".

/*#################################*/
/* PARTIDA -- PARTIDA -- PARTIDA -- PARTIDA */
/* Inacabadoo */

modo_de_jogo:-
    writeln("\nQual a forma de jogar?\n(1) SinglePlayer\n(2) MultiPlayer\nEscolha:"),
    le_inteiro(Escolha),
    (Escolha == 1 -> (single_player) ;
    Escolha == 2 -> (multi_player) ;
    (writeln("Opcao Invalida"), modo_de_jogo)).

single_player:-
    writeln("Nome do Jogador:"),
    read(Nome),
    ler_txt('perguntas.txt', Saida).

multi_player:-
    writeln("===== Jogador 1 ====="),
    single_player,
    writeln("===== Jogador 1 ====="),
    single_player.

/*#################################*/
/* LEITURA DE ARQUIVOS -- LEITURA DE ARQUIVOS*/
/* Em fase de testes */

ler_txt(Filename, Saida):-
    open(Filename, read, OS),
    get_char(OS, C),
    txt_to_list(C, L, OS),
    close(OS),
    print(L),
    Saida is L.

txt_to_list(_, [], OS):- at_end_of_stream(OS).
txt_to_list(' ', L, OS):- get_char(OS, Q), txt_to_list(Q, L, OS).
txt_to_list('\n', L, OS):- get_char(OS, Q), txt_to_list(Q, L, OS).
txt_to_list(C, [C|L], OS):- get_char(OS, Q), txt_to_list(Q, L, OS).