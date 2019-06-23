/* FUNCIONALIDADES

--- Feito ---
Menu Inicial
Instrucoes
Cria Partida
Leitura de arquivo
Montar pergunta
Avaliaçao da resposta do usuário

--- Em Andamento ---
SinglePlayer
MultiPlayer
Inserção no ranking
Contagem de pontos
Dicas

--- A Fazer ---
Inserir o tempo no cálculo de pontuação

*/

:- initialization main.

/* Main */
main:-
    menu,
    read(Escolha), atom_string(Escolha, EscolhaS),
    verifica_escolha(EscolhaS).

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
    Escolha == "1" -> (instrucoes) ;
    Escolha == "2" -> (inicializa_partida_menu) ;
    Escolha == "3" -> (ranking) ;
    Escolha == "4" -> (writeln("Obrigado por jogar! :)"), limpa_arquivo('perguntasUsadas.txt')) ;
    main.


/* Exibe Instrucoes */
instrucoes:-
    writeln("\n===== Instrucoes =====\n"),
    writeln("O PerguntUP eh um jogo de perguntas que pode ser jogado de duas maneiras:"),
    writeln("-> Singleplayer ou Multiplayer"),
    writeln("Cada partida possui 12 perguntas, divididas em 4 areas de conhecimento:"),
    writeln("- Ciencias da Natureza\n- Linguagens\n- Ciencias Exatas\n- Ciencias Humanas"),
    writeln("Voce tera 15 segundos para responder cada pergunta (caso ultrapasse esse tempo, a pontuacao final sera penalizada)"),
    writeln("Alehm disso, haverao dicas limitadas disponiveis:"),
    writeln("- Eliminar alternativas: elimina duas alternativas"),
    writeln("- Opiniao dos internautas: mostra a porcentagem de concordancia com cada alternativa"),
    writeln("- Pular pergunta: pula para a proxima pergunta"),
    writeln("A cada inicio de partida, voce tera 1 dica de cada"),
    writeln("Para obter mais dicas, voce devera responder a pergunta em menos de 5 segundos"),
	writeln("Se ja tiver sido usado alguma dica, ela sera reposta. Caso contrario, a dica recebida sera aleatoria"),
    writeln("Alem disso, o sistema conta com um ranking com as 10 melhores pontuacoes. Ele e exibido no inicio e no final de cada partida\n"),
    main.

/* Inicializa partida */
inicializa_partida_menu:-
    writeln("\nDeseja iniciar uma nova partida?\n(1) Sim\n(2) Nao\nEscolha:"),
    read(E), atom_string(E, Escolha),
    (Escolha == "1" -> (modo_de_jogo, play_again) ;
    Escolha == "2" -> (writeln("Valeu, ate mais!\n"), main) ;
    (writeln("Opcao Invalida"), inicializa_partida_menu)).

play_again:-
    writeln("\nObrigado por jogar!"), inicializa_partida_menu.

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
    read(E), atom_string(E, Escolha),
    (Escolha == "1" -> (single_player) ;
    Escolha == "2" -> (multi_player) ;
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

/* Leitura de Perguntas */
ler_txt(Filename, Pergunta):-
    open(Filename, read, OS),
    read_string(OS, "\r", "\r", End, String),
    split_string(String, "*", "*", Pergunta),
    close(OS).

/* Escrita de Perguntas Usadas */
insere_pergunta(Filename, Entrada):-
    open(Filename, append, OS),
    write(OS,Entrada),
    write(OS, "***"),
    close(OS).

/* Escrita de Ranking */
escrever_ranking('ranking.txt', []).
escrever_ranking(Filename, [X|Y]):-
    open(Filename, write, OS),
    write(OS, X),
    nl(OS),
    escrever_ranking(Filename, Y),
    close(OS).

/* Leitura de Ranking */
ler_ranking(Filename, Pergunta):-
    open(Filename, read, OS),
    read_string(OS, "\r", "\r", End, String),
    split_string(String, "\n", "", Pergunta),
    close(OS).

/* Leitura de Dicas usadas */
ler_dicas_usadas(Filename, DicasUsadas):-
    open(Filename, read, OS),
    read_string(OS, "\r", "\r", End, String),
    split_string(String, ",", "", Pergunta),
    close(OS).

/* Escrita de Dicas usadas */
marca_dica_usada(Filename, Dica):-
    open(Filename, append, OS),
    write(OS, X),
    write(OS, ","),
    close(OS).

/* Apaga qualquer informacao no arquivo */
limpa_arquivo(Filename):-
    open(Filename, write, OS),
    write(OS, ""),
    close(OS).

/*#################################*/
/* MONTAGEM DE PERGUNTA -- MONTAGEM DE PERGUNTA */

monta_pergunta(Nome, Perguntas, Acertos, Erros, TotalPerguntas):-
    TotalPerguntas == 0 -> (writeln("\nSua Pontuacao final foi:"),
    calculaPontuacao(Acertos, 0, Pontuacao),
    writeln(Pontuacao),
    add_ranking(Nome, Pontuacao)).

monta_pergunta(Nome, Perguntas, Acertos, Erros, TotalPerguntas):-
    pega_pergunta(Perguntas, Escolhida),
    split_string(Escolhida, "\n", "", Saida),
    printa_pergunta(Saida, Resposta),
    avaliando_resposta(Saida, Resposta, Acertos, Erros, false),
    writeln("\n==== Placar Parcial ===="),
    write("Acertos: "), writeln(Acertos),
    write("Erros: "), writeln(Erros),
    PerguntasFaltantes is TotalPerguntas - 1,
    monta_pergunta(Nome, Perguntas, Acertos, Erros, PerguntasFaltantes).

pega_pergunta(ListaPerguntas, Pergunta):-
    random(0, 100, R),
    length(ListaPerguntas, Tamanho),
    Index is (R mod Tamanho),
    get_elemento(ListaPerguntas, 0, Index, PerguntaEscolhida),
    ler_txt('perguntasUsadas.txt', Usadas),
    (pertence(Usadas, PerguntaEscolhida) -> pega_pergunta(ListaPerguntas, Pergunta) ;
    (Pergunta = PerguntaEscolhida, insere_pergunta('perguntasUsadas.txt', PerguntaEscolhida))).

/* Problema na contagem de acertos */
avaliando_resposta(Saida, Resposta, Acertos, Erros, true).
avaliando_resposta(Saida, Resposta, Acertos, Erros, Flag):-
    get_time(Inicio),
    read(RespUsuario), get_time(Fim), atom_string(RespUsuario, RespostaUs),
    split_string(Resposta, ":", " ", Resp), get_elemento(Resp, 0, 1, RespostaCorreta),
    (pertence(["a", "b", "c", "d", "e", "p"], RespostaCorreta) -> 
    (RespostaUs == "p" -> dicas ;
    RespostaUs == RespostaCorreta -> 
    (writeln("Resposta certa!"), writeln("\n=== Marcando pergunta como respondida..."),
    AcertosAtual is Acertos + 1, ErrosAtual is Erros) ;
    writeln("Resposta errada!"), writeln("\n=== Marcando pergunta como respondida..."),
    ErrosAtual is Erros + 1, AcertosAtual is Acertos)),
    avaliando_resposta(Saida, Resposta, AcertosAtual, ErrosAtual, true).


avaliando_resposta(Saida, Resposta, Acertos, Erros, false):-
    writeln("Resposta invalida!"), 
    printa_pergunta(Saida, Resp),
    avaliando_resposta(Saida, Resp, Acertos, Erros, false).


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

pertence([Elemento|Y], Elemento).
pertence([X|Y], Elemento):-
    pertence(Y, Elemento).

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
    get_elemento(Pergunta, 0, 7, Resposta),
    writeln("p: Pedir Ajuda").

print_lista([],_).
print_lista([X|Y], Posicao):-
    write(Posicao), write("."), writeln(X),
    ProximaPosicao is Posicao + 1, print_lista(Y, ProximaPosicao).


/*#################################*/
/* DICAS -- DICAS -- DICAS -- DICAS -- DICAS -- DICAS */

dicas:-
    ler_dicas_usadas('dicas.txt', DicasUsadas),
    length(DicasUsadas, Tamanho),
    Tamanho =\= 3 ->
    writeln("\n(1) Eliminar alternativas\n(2) Opiniao dos internautas\n(3) Pular pergunta\n"),
    read(X), atom_string(X, EscolhaUsuario),
    (EscolhaUsuario == "1" -> exibe_dica(1), writeln("\n=== Marcando ajuda 1 como usada..."), marca_dica_usada('dicas.txt', "1") ;
    EscolhaUsuario == "2" -> exibe_dica(2), writeln("\n=== Marcando ajuda 2 como usada..."), marca_dica_usada('dicas.txt', "2") ;
    EscolhaUsuario == "3" -> exibe_dica(3), writeln("\n=== Marcando ajuda 3 como usada..."), marca_dica_usada('dicas.txt', "3") ;
    writeln("Opcao Invalida"), dicas).


/*#################################*/
/* CALCULOS -- CALCULOS -- CALCULOS */

/* Em andamento */
calculaPontuacao(Acertos, TempoGasto, Pontuacao):-
    Pontuacao is (((Acertos * 50) // 12) + (50 - ((TempoGasto - 60) * (50 // 120)))).