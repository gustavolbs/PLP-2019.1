/* FUNCIONALIDADES

--- Feito ---
Menu Inicial
Instrucoes
Cria Partida
Leitura de arquivo

--- Em Andamento ---
SinglePlayer
MultiPlayer
Montar perguntas
Inserção no ranking
contagem de pontos
avaliaçao da resposta do usuário


--- A Fazer ---
Todo o resto kkkkkk

*/

/*:- initialization main.*/

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
    Escolha == 3 -> (ranking) ;
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
/* Em Andamento */
ranking:-
    ler_ranking('ranking.txt', Resultado),
    print_lista(Resultado, 1).

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
    ler_txt('perguntas.txt', Perguntas),
    monta_pergunta(Nome, Perguntas, 0, 0, 12).

multi_player:-
    writeln("===== Jogador 1 ====="),
    single_player,
    writeln("===== Jogador 1 ====="),
    single_player.

/*#################################*/
/* LEITURA E ESCRITA DE ARQUIVOS -- LEITURA E ESCRITA DE ARQUIVOS*/

ler_txt(Filename, Pergunta):-
    open(Filename, read, OS),
    read_string(OS, "\r", "\r", End, String),
    split_string(String, "*", "*", Pergunta),
    close(OS).

insere_pergunta(Filename, Entrada):-
    open(Filename, write, OS),
    write(OS,Entrada),
    write(OS, "***"),
    close(OS).

escrever_ranking('ranking.txt', []).
escrever_ranking(Filename, [X|Y]):-
    open(Filename, write, OS),
    write(OS, X),
    nl(OS),
    escrever_ranking(Filename, Y),
    close(OS).

ler_ranking(Filename, Pergunta):-
    open(Filename, read, OS),
    read_string(OS, "\r", "\r", End, String),
    split_string(String, "\n", "", Pergunta),
    close(OS).


/*#################################*/
/* MONTAGEM DE PERGUNTA -- MONTAGEM DE PERGUNTA */

monta_pergunta(Nome, Perguntas, Acertos, Erros, TotalPerguntas):-
    TotalPerguntas == 0 -> (writeln("Sua Pontuação final foi:"),
    calculaPontuacao(Acertos, Erros, Pontuacao),
    writeln(Pontuacao),
    add_ranking(Nome, Pontuacao)).

monta_pergunta(Nome, Perguntas, Acertos, Erros, TotalPerguntas):-
    pega_pergunta(Perguntas, Escolhida),
    split_string(Escolhida, "\n", "", Saida),
    printa_pergunta(Saida, Resposta),
    avaliando_resposta(Saida, Resposta, Acertos, Erros),
    PerguntasFaltantes is TotalPerguntas - 1,
    monta_pergunta(Nome, Perguntas, Acertos, Erros, PerguntasFaltantes).

pega_pergunta(ListaPerguntas, Pergunta):-
    random(0, 100, R),
    length(ListaPerguntas, Tamanho),
    Index is (R mod Tamanho),
    get_elemento(ListaPerguntas, 0, Index, PerguntaEscolhida),
    ler_txt('perguntasUsadas.txt', Usadas),
    pertence(Usadas, PerguntaEscolhida, Result),
    (Result == true -> pega_pergunta(ListaPerguntas, Pergunta) ;
    (Pergunta = PerguntaEscolhida, insere_pergunta('perguntasUsadas.txt', PerguntaEscolhida))).

/* Em Andamento, dando probleminhas */
avaliando_resposta(Saida, Resposta, Acertos, Erros):-
    read(RespUsuario),
    split_string(Resposta, ":", " ", Saida), get_elemento(Saida, 0, 0, Elemento),
    pertence(["a", "b", "c", "d", "e", "p"], Elemento, Result), 
    (Result == true -> 
    (RespUsuario == Resposta -> 
    (writeln("Resposta certa!"), writeln("\n=== Marcando pergunta como respondida..."),
    AcertosAtual is Acertos + 1) ;
    writeln("Resposta errada!"), writeln("\n=== Marcando pergunta como respondida..."),
    ErrosAtual is Erros + 1)).

avaliando_resposta(Saida, Resposta, Acertos, Erros):-
    writeln("Resposta invalida!"), 
    printa_pergunta(Saida, Resp),
    avaliando_resposta(Saida, Resp, Acertos, Erros).


/*#################################*/
/* EXIBIÇÃO E ARMAZENAMENTO DE RANKING -- EXIBIÇÃO E ARMAZENAMENTO DE RANKING */

/* Em andamento */
add_ranking(Nome, Pontuacao):-
    ler_ranking('ranking.txt', Top10),
    Pessoa is Nome + ":" + Pontuacao,
    insere_lista(Top10, Pessoa, Top10Atual),
    sort(0, @<, Top10Atual, Result),
    escrever_ranking('ranking.txt', Result).


/*#################################*/
/* PREDICADOS PARA LISTAS -- PREDICADOS PARA LISTAS */

pertence([], _, false).
pertence([Elemento|Y], Elemento, true).
pertence([X|Y], Elemento, Result):-
    pertence(Y, Elemento, Result).

get_elemento([X|Y], IndexAtual, Index, Elemento):-
    IndexAtual == Index -> Elemento = X.
get_elemento([X|Y], IndexAtual, Index, Elemento):-
    IndexFuturo is IndexAtual + 1,
    get_elemento(Y, IndexFuturo, Index, Elemento).

printa_pergunta(Pergunta, Resposta):-
    write("\n"),
    get_elemento(Pergunta, 0, 6, Tipo),
    writeln(Tipo),
    get_elemento(Pergunta, 0, 0, Enunciado),
    writeln(Enunciado),
    get_elemento(Pergunta, 0, 1, AlternativaA),
    writeln(AlternativaA),
    get_elemento(Pergunta, 0, 2, AlternativaB),
    writeln(AlternativaB),
    get_elemento(Pergunta, 0, 3, AlternativaC),
    writeln(AlternativaC),
    get_elemento(Pergunta, 0, 4, AlternativaD),
    writeln(AlternativaD),
    get_elemento(Pergunta, 0, 5, AlternativaE),
    writeln(AlternativaE),
    get_elemento(Pergunta, 0, 7, Resposta).

print_lista([],_).
print_lista([X|Y], Posicao):-
    write(Posicao), write("."), writeln(X),
    ProximaPosicao is Posicao + 1, print_lista(Y, ProximaPosicao).