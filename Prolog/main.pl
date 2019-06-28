/* FUNCIONALIDADES

--- Feito ---
Menu Inicial
Instrucoes
Cria Partida
Leitura de arquivo
Montar pergunta
Avaliaçao da resposta do usuário
Contagem de pontos
Dicas
SinglePlayer
MultiPlayer
Inserção no ranking
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
    writeln("\n===== PerguntUP ====="),
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
    Escolha == "4" -> (writeln("Obrigado por jogar! :)\n")) ;
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
    writeln("Alem disso, o sistema conta com um ranking com as 10 melhores pontuacoes. Ele eh exibido no inicio e no final de cada partida\n"),
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
    writeln("\n====== RANKING ======"),
    print_lista(Resultado, 1),
    main.

/*#################################*/
/* PARTIDA -- PARTIDA -- PARTIDA -- PARTIDA */
/* Inacabadoo */

modo_de_jogo:-
    writeln("\nQual a forma de jogar?\n(1) SinglePlayer\n(2) MultiPlayer\nEscolha:"),
    read(E), atom_string(E, Escolha),
    (Escolha == "1" -> (single_player(Nome, Pontuacao), ranking) ;
    Escolha == "2" -> (multi_player, ranking) ;
    (writeln("Opcao Invalida"), modo_de_jogo)).

single_player(Nome, Pontuacao):-
    writeln("Nome do Jogador:"),
    read(Nome), atom_string(Nome, NomeStr),
    ler_txt('perguntas.txt', Perguntas),
    monta_pergunta(Perguntas, 0, 0, 12, Pontuacao, 0),
    add_ranking(Pontuacao, NomeStr),
    limpa_arquivo('perguntasUsadas.txt'),
    limpa_arquivo('dicas.txt').

multi_player:-
    writeln("\n===== Jogador 1 ====="),
    single_player(Nome1, Pontuacao1),
    writeln("\n===== Jogador 2 ====="),
    single_player(Nome2, Pontuacao2),
    
    writeln("\n#### Resultado ####\n"),
    ((Pontuacao1 > Pontuacao2) -> write(Nome1), writeln(" (Jogador 1) venceu!\n") ;
    (Pontuacao2 > Pontuacao1) -> write(Nome2), writeln(" (Jogador 2) venceu!\n") ;
    writeln("\nEmpate!\n")).

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
escrever_ranking(Filename, Lista):-
    open(Filename, write, OS),
    escreve_lista_ranking(OS, Lista, 1),
    close(OS).

escreve_lista_ranking(OS, [], _).
escreve_lista_ranking(OS, [X|Y], Index):-
    Index =< 10 ->
    (write(OS, X),
    nl(OS),
    IndexProx is Index + 1,
    escreve_lista_ranking(OS, Y, IndexProx)).

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
    split_string(String, "-", "-", DicasUsadas),
    close(OS).

/* Escrita de Dicas usadas */
marca_dica_usada(Filename, Dica):-
    open(Filename, append, OS),
    write(OS, Dica),
    close(OS).

/* Apaga qualquer informacao no arquivo */
limpa_arquivo(Filename):-
    open(Filename, write, OS),
    write(OS, ""),
    close(OS).

recupera_dica(Filename):-
    ler_dicas_usadas(Filename, DicasUsadas),
    remover_ultimo_elem(DicasUsadas, Dicas),
    atualiza_dicas('dicas.txt', Dicas).

atualiza_dicas(Filename, Dicas):-
    open(Filename, write, OS),
    escreve_tudo(Dicas, OS),
    close(OS).

escreve_tudo([],_).
escreve_tudo([X|Y], OS):-
    write(OS, X),
    write(OS, "---"),
    escreve_tudo(Y, OS).

/*#################################*/
/* MONTAGEM DE PERGUNTA -- MONTAGEM DE PERGUNTA */

monta_pergunta(Perguntas, Acertos, Erros, TotalPerguntas, Pontuacao, Tempo):-
    TotalPerguntas == 0 -> (writeln("\nSua Pontuacao final foi:"),
    calculaPontuacao(Acertos, Tempo, Pontuacao), writeln(Pontuacao)) ;

    (pega_pergunta(Perguntas, Escolhida),
    split_string(Escolhida, "\n", "", Saida),
    printa_pergunta(Saida, Resposta),
    avaliando_resposta(Saida, Resposta, Acertos, Erros, AcertosFinal, ErrosFinal, TempoGasto, IsPulo), TempoTotal is TempoGasto + Tempo,
    writeln("\n==== Placar Parcial ===="),
    write("Acertos: "), writeln(AcertosFinal),
    write("Erros: "), writeln(ErrosFinal),
    (IsPulo == 1 -> PerguntasFaltantes is TotalPerguntas ;
    PerguntasFaltantes is TotalPerguntas - 1),
    monta_pergunta(Perguntas, AcertosFinal, ErrosFinal, PerguntasFaltantes, Pontuacao, TempoTotal)).

pega_pergunta(ListaPerguntas, Pergunta):-
    random(0, 100, R),
    length(ListaPerguntas, Tamanho),
    Index is (R mod Tamanho),
    get_elemento(ListaPerguntas, 0, Index, PerguntaEscolhida),
    ler_txt('perguntasUsadas.txt', Usadas),
    (pertence(Usadas, PerguntaEscolhida) -> pega_pergunta(ListaPerguntas, Pergunta) ;
    (Pergunta = PerguntaEscolhida, insere_pergunta('perguntasUsadas.txt', PerguntaEscolhida))).

/* Problema na contagem de acertos e erros */
avaliando_resposta(Pergunta, Resposta, Acertos, Erros, AcertosFinal, ErrosFinal, TempoGasto, IsPulo):-
    get_time(Inicio),
    read(RespUs), get_time(Fim),
    atom_string(RespUs, RString),
    Tempo is Fim - Inicio,
    split_string(Resposta, ":", " ", R), get_elemento(R, 0, 1, RespostaCorreta),
    (pertence(["a", "b", "c", "d", "e", "p"], RString) -> (
        RString == "p" -> dicas(RespostaCorreta, Pergunta, IsPulo), (IsPulo == 1 -> (write(""), AcertosFinal is Acertos, ErrosFinal is Erros, TempoGasto is Tempo) ; avaliando_resposta(Pergunta, Resposta, Acertos, Erros, AcertosFinal, ErrosFinal, TempoGasto, IsPulo)) ;
        (RString == RespostaCorreta -> (
            writeln("Resposta certa!"), writeln("\n=== Marcando pergunta como respondida..."), AcertosFinal is (Acertos + 1), ErrosFinal is Erros, TempoGasto is Tempo) ;
            (writeln("Resposta errada!"), writeln("\n=== Marcando pergunta como respondida..."), ErrosFinal is (Erros + 1), AcertosFinal is Acertos, TempoGasto is Tempo))) ;
    (writeln("Resposta invalida!"), 
    printa_pergunta(Pergunta, Resp),
    avaliando_resposta(Pergunta, Resp, Acertos, Erros, AcertosFinal, ErrosFinal, TempoGasto, IsPulo))).

/*#################################*/
/* EXIBIÇÃO E ARMAZENAMENTO DE RANKING -- EXIBIÇÃO E ARMAZENAMENTO DE RANKING */

/* Em andamento */
add_ranking(Nome, Pontuacao):-
    ler_ranking('ranking.txt', Top10),
    string_concat(Nome, " - ", X),
    string_concat(X, Pontuacao, Pessoa),
    inserir_final(Top10, Pessoa, Top10Atual),
    sort_compound(Top10Atual, L),
    inverter(L, Lista),
    escrever_ranking('ranking.txt', Lista).

/*#################################*/

/*#####################################*/
/* Ordena Raking */

sort_compound(L1,LL) :-
    split_compound(L1,L2),
    sort(L2,L3),
    recombine(L3,LL).

split_compound([H|T], [[N,L2]|T2]) :-
    split_string(H,"-"," ",[H1,L2]),
    number_string(N,H1),
    split_compound(T,T2).

split_compound([],[]).

recombine([[A,B]|T], [C|T2]) :-
    atomics_to_string([A,' - ',B],C),
    recombine(T,T2).
    
recombine([],[]).


/* PREDICADOS PARA LISTAS -- PREDICADOS PARA LISTAS */

inverter([],[]).
inverter([X|Y],Z):-
	inverter(Y,Y1),
	conc(Y1,[X],Z).

conc([],L,L).
conc([X|L1],L2,[X|L3]):-
	conc(L1,L2,L3).

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
print_lista([""],1):-
    writeln("\n====== RANKING VAZIO ======").
print_lista([""],_).
print_lista([X|Y], Posicao):-
    write(Posicao), write(". "), writeln(X),
    ProximaPosicao is Posicao + 1, print_lista(Y, ProximaPosicao).

somar_lista([], 0).
somar_lista([X|Y], Soma):-
    somar_lista(Y, K),
    Soma is X + K.

gera_lista_aleatoria(Lista, TamanhoAtual, TamanhoMax, ListaComElementos):-
    TamanhoAtual =\= TamanhoMax ->
    somar_lista(Lista, Soma),
    Max is 101 - Soma,
    random(0, Max, R),
    TamanhoA is TamanhoAtual + 1,
    inserir_final(Lista, R, ListaA),
    gera_lista_aleatoria(ListaA, TamanhoA, TamanhoMax, ListaComElementos) ;
    ListaComElementos = Lista.

inserir_final([""], Y, [Y]).
inserir_final([], Y, [Y]).
inserir_final([I|R], Y, [I|R1]):-
    inserir_final(R, Y, R1).

remover(X,[X|C],C).	
remover(X,[Y|C],[Y|D]):-
	remover(X,C,D).

intersec([X|Y],L,[X|Z]):-
	pertence(L, X),
	intersec(Y,L,Z).
intersec([_|X],L,Y):-
	intersec(X,L,Y).
intersec(_,_,[]).

max([X],X).
max([X|Y],M):-
	max(Y,N), 
    (X>N -> M=X ; M=N).

print_elementos_lista([]).
print_elementos_lista([X|Y]):-
    writeln(X), print_elementos_lista(Y).

remover_ultimo_elem([X|Y], Lista, ListaN):-
    length(Y, Tamanho),
    Tamanho =\= 0 -> remover_ultimo_elem(Y, [Lista| X]) ;
    ListaN = Lista.


/*#################################*/
/* DICAS -- DICAS -- DICAS -- DICAS -- DICAS -- DICAS */

dicas(RespostaCorreta, Pergunta, IsPulo):-
    ler_dicas_usadas('dicas.txt', DicasUsadas),
    Indices = ["1","2","3"],
    Lista = ["\n(1) Eliminar alternativas", "(2) Opiniao dos internautas", "(3) Pular pergunta\n"],
    intersec(Indices, DicasUsadas, ListaIndices),
    length(ListaIndices, Tamanho),
    (Tamanho == 0 ->
    (print_elementos_lista(Lista), le_opcao(RespostaCorreta, Pergunta, IsPulo)) ;
    (Tamanho == 1 -> 
    (get_elemento(ListaIndices, 1, 1, Elemento), number_string(Indice, Elemento),
        get_elemento(Lista, 1, Indice, Dica1), remover(Dica1, Lista, Dicas), print_elementos_lista(Dicas),
        le_opcao(RespostaCorreta, Pergunta, IsPulo))) ;
    (Tamanho == 2 ->
    (get_elemento(ListaIndices, 1, 1, Elemento1), get_elemento(ListaIndices, 1, 2, Elemento2),
        number_string(Indice1, Elemento1), number_string(Indice2, Elemento2),
        get_elemento(Lista, 1, Indice1, Dica1), get_elemento(Lista, 1, Indice2, Dica2),
        remover(Dica1, Lista, D), remover(Dica2, D, Dicas), print_elementos_lista(Dicas),
        le_opcao(RespostaCorreta, Pergunta, IsPulo))) ;
    writeln("\n#### Voce nao tem mais dicas ####\n")).

le_opcao(RespostaCorreta, Pergunta, IsPulo):-
    read(X), atom_string(X, EscolhaUsuario),
    (EscolhaUsuario == "1" -> writeln("\n=== Marcando ajuda 1 como usada..."), marca_dica_usada('dicas.txt', "1---"), exibe_dica1(RespostaCorreta, Pergunta), IsPulo is 0 ;
    EscolhaUsuario == "2" -> writeln("\n=== Marcando ajuda 2 como usada..."), marca_dica_usada('dicas.txt', "2---"), exibe_dica2(RespostaCorreta, Pergunta), IsPulo is 0  ;
    EscolhaUsuario == "3" -> writeln("\n=== Marcando ajuda 3 como usada..."), marca_dica_usada('dicas.txt', "3---"), exibe_dica3(IsPulo) ;
    (writeln("Opcao Invalida"), dicas(RespostaCorreta, Pergunta, IsPulo))).

/* DICA 1 */
exibe_dica1(RespostaCorreta, Pergunta):-
    random(0, 5, R1),
    Max1 is 5 - R1,
    random(0, Max1, R2),
    remover(RespostaCorreta, ["a", "b", "c", "d", "e"], Lista),
    get_elemento(Lista, 0, R1, Elemento1),
    get_elemento(Lista, 0, R2, Elemento2),
    Eliminadas = [Elemento1, Elemento2],
    printa_pergunta(Pergunta, Eliminadas, 1).

printa_pergunta(Pergunta, Eliminadas, 1):-
    write("\n"),
    get_elemento(Pergunta, 0, 6, Tipo),
    writeln(Tipo),
    get_elemento(Pergunta, 0, 0, Enunciado),
    writeln(Enunciado),
    get_elemento(Pergunta, 0, 1, AlternativaA),
    (pertence(Eliminadas, "a") -> write("") ;
    writeln(AlternativaA)),
    get_elemento(Pergunta, 0, 2, AlternativaB),
    (pertence(Eliminadas, "b") -> write("") ;
    writeln(AlternativaB)),
    get_elemento(Pergunta, 0, 3, AlternativaC),
    (pertence(Eliminadas, "c") -> write("") ;
    writeln(AlternativaC)),
    get_elemento(Pergunta, 0, 4, AlternativaD),
    (pertence(Eliminadas, "d") -> write("") ;
    writeln(AlternativaD)),
    get_elemento(Pergunta, 0, 5, AlternativaE),
    (pertence(Eliminadas, "e") -> write("") ;
    writeln(AlternativaE)),
    get_elemento(Pergunta, 0, 7, Resposta).
    
/* DICA 2  */
exibe_dica2(RespostaCorreta, Pergunta):-
    gera_lista_aleatoria([], 0, 5, Lista),
    printa_pergunta(Pergunta, Lista, RespostaCorreta, 2).

printa_pergunta(Pergunta, Porcentagens, RespostaCorreta, 2):-
    write("\n"),
    max(Porcentagens, Certa), remover(Certa, Porcentagens, P),
    get_elemento(Pergunta, 0, 6, Tipo),
    writeln(Tipo),
    get_elemento(Pergunta, 0, 0, Enunciado),
    writeln(Enunciado),

    get_elemento(Pergunta, 0, 1, AlternativaA),
    get_elemento(Pergunta, 0, 2, AlternativaB),
    get_elemento(Pergunta, 0, 3, AlternativaC),
    get_elemento(Pergunta, 0, 4, AlternativaD),
    get_elemento(Pergunta, 0, 5, AlternativaE),

    string_concat(Certa, " % --> ", PorcentagemCerta),
    get_elemento(P, 0, 0, P1), string_concat(P1, " % --> ", Porcentagem1),
    get_elemento(P, 0, 1, P2), string_concat(P2, " % --> ", Porcentagem2),
    get_elemento(P, 0, 2, P3), string_concat(P3, " % --> ", Porcentagem3),
    get_elemento(P, 0, 3, P4), string_concat(P4, " % --> ", Porcentagem4),

    (RespostaCorreta == "a" -> (
        string_concat(PorcentagemCerta, AlternativaA, LetraA),
        string_concat(Porcentagem1, AlternativaB, LetraB),
        string_concat(Porcentagem2, AlternativaC, LetraC),
        string_concat(Porcentagem3, AlternativaD, LetraD),
        string_concat(Porcentagem4, AlternativaE, LetraE)) ;
    RespostaCorreta == "b" -> (
        string_concat(PorcentagemCerta, AlternativaB, LetraB),
        string_concat(Porcentagem1, AlternativaA, LetraA),
        string_concat(Porcentagem2, AlternativaC, LetraC),
        string_concat(Porcentagem3, AlternativaD, LetraD),
        string_concat(Porcentagem4, AlternativaE, LetraE)) ;
    RespostaCorreta == "c" -> (
        string_concat(PorcentagemCerta, AlternativaC, LetraC),
        string_concat(Porcentagem1, AlternativaA, LetraA),
        string_concat(Porcentagem2, AlternativaB, LetraB),
        string_concat(Porcentagem3, AlternativaD, LetraD),
        string_concat(Porcentagem4, AlternativaE, LetraE)) ;
    RespostaCorreta == "d" -> (
        string_concat(PorcentagemCerta, AlternativaD, LetraD),
        string_concat(Porcentagem1, AlternativaA, LetraA),
        string_concat(Porcentagem2, AlternativaB, LetraB),
        string_concat(Porcentagem3, AlternativaC, LetraC),
        string_concat(Porcentagem4, AlternativaE, LetraE)) ;
    (
        string_concat(PorcentagemCerta, AlternativaE, LetraE),
        string_concat(Porcentagem1, AlternativaA, LetraA),
        string_concat(Porcentagem2, AlternativaB, LetraB),
        string_concat(Porcentagem3, AlternativaC, LetraC),
        string_concat(Porcentagem4, AlternativaD, LetraD))),
    
    Lista = [LetraA, LetraB, LetraC, LetraD, LetraE],
    print_elementos_lista(Lista).

exibe_dica3(IsPulo):-
    writeln("////// Pergunta Pulada\n"),
    IsPulo = 1.

/*#################################*/
/* CALCULOS -- CALCULOS -- CALCULOS */

/* Em andamento */
calculaPontuacao(Acertos, TempoGasto, Pontuacao):-
    Pontuacao is (((Acertos * 50) // 12) + (50 - ((TempoGasto - 60) * (50 // 120)))).