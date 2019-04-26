#include <iostream>
#include <string>
#include <stdlib.h>
#include <fstream>
#include <vector>
#include <sstream>
#include <string>
#include <random>
#include <algorithm>
#include <cstdlib>
#include <ctime>
#include "json.hpp"
#include <iterator> 
#include <ctime>

using namespace std;
using json = nlohmann::json;
using jsonf = nlohmann::json;

#define UP_A 65
#define UP_Z 91
#define LOW_A 97
#define LOW_Z 122

// Funcoes
void criaPartidaMenu();  							 
void criarPergunta();								 
void singlePlayer();	 							
int randomValue(int max); 							
string tolower(string word); 						
int exibirDicas(int perguntaID); 					
void armazenaInfos(string jogador, int pontuacao);  
void verRanking();		 							
void darRecompensa(); 								
void print(vector<int> const &a);					
string playAgain();									
void multiPlayer();		 							
void instrucoes();									

// Variaveis Globais
vector<int> perguntasUsadas;
vector<string> validas = {"a","b","c","d","e","p"};
int acertos = 0;
int erros = 0;
int perguntasPartida = 0;
int tempoTotal = 0;
double pontuacaoFinal;
bool dicaEliminacao = false;
bool dicaPorcentagens = false;
bool dicaPular = false;


/* 
	Printa os valores dentro de um vetor
*/
void print(vector<int> const &a) {
	cout << "The vector elements are : ";

	for (int i = 0; i < a.size(); i++){
		cout << a.at(i) << ' ';
	}
}

// Main
int main() {
	string p;
	do {
		string opcao;
		time_t t = time(0);
		cout << "===== PerguntUP =====" << endl;
		cout << "by GERIGE" << endl << endl;
		cout << "Deseja ver as instrucoes?" << endl << "(s = sim; n = nao) ";
		cin >> opcao;
		if (tolower(opcao) == "s" ) {
			instrucoes();
		}
		criaPartidaMenu();
		cout << "Tempo total da Partida: " << (time(0) - t) << "'s"<< endl;

		p = playAgain();
	} while (p == "s");
}

/*
	Funcao que exibe as instrucoes do jogo.
*/
void instrucoes() {
	cout << "===== Instrucoes =====" << endl << endl
		 << "O PerguntUP eh um jogo de perguntas que pode ser jogado de duas maneiras:" << endl
		 << "-> Singleplayer ou Multiplayer" << endl
		 << "Cada partida possui 12 perguntas, divididas em 4 areas de conhecimento:" << endl
		 << "- Ciencias da Natureza" << endl
		 << "- Linguagens" << endl
		 << "- Ciencias Exatas" << endl
		 << "- Ciencias Humanas" << endl
		 << "Voce tera 15 segundos para responder cada pergunta (caso ultrapasse esse tempo, a pontuacao final sera penalizada)" << endl
		 << "Alehm disso, haverao dicas limitadas disponiveis:" << endl
		 << "- Eliminar alternativas: elimina duas alternativas" << endl
		 << "- Opiniao dos internautas: mostra a porcentagem de concordancia com cada alternativa" << endl
		 << "- Pular pergunta: pula para a proxima pergunta" << endl
		 << "A cada inicio de partida, voce tera 1 dica de cada" << endl
		 << "Para obter mais dicas, voce devera responder a pergunta em menos de 5 segundos" << endl
		 << "Se ja tiver sido usado alguma dica, ela sera reposta. Caso contrario, a dica recebida sera aleatoria" << endl
		 << "Alem disso, o sistema conta com um ranking com as 10 melhores pontuacoes. Ele e exibido no inicio e no final de cada partida" << endl << endl;
}

/* 
	Funcao que cria o menu do jogo e verifica se o usuario quer realmente jogar.
*/
void criaPartidaMenu() {
	int modo;
	int comecar;


	do{
		verRanking();
		string iniciar;
		cout << "Deseja iniciar uma nova partida?" << endl;
		cout << "(s = sim; n = nao): ";
		cin >> iniciar;

		if (tolower(iniciar) == "s"){
			comecar = 1;
		}
		else if (tolower(iniciar) == "n") {
			comecar = 0;
		}
		else{
			comecar = 2;
		}

		switch (comecar) {
			case 1:{

				string modalidade;
				do{
					cout << endl
						 << "Qual a forma de jogar?" << endl
						 << "(s = singlePlayer; m = multiPlayer) ";
					cin >> modalidade;

					if (tolower(modalidade) == "s") {
						modo = 0;
					} else if (tolower(modalidade) == "m") {
						modo = 1;
					} else {
						modo = 2;
					}

					switch (modo){
						case 0:{
							singlePlayer();
							break;
						}
						case 1:{
							multiPlayer();
							break;
						}
						default:{
							cout << "OPCAO INVALIDA!" << endl;
						}
					}
				} while (modo != 0 && modo != 1);
				break;
			}
			case 0:{
				cout << "Obrigado por jogar!" << endl;
				exit(0);
				break;
			}
			default:{
				cout << "OPCAO INVALIDA!" << endl;
			}
		}
	} while (modo != 0 && modo != 1);

	
}

/* 
	Funcao que inicia o modo SinglePlayer.
*/
void singlePlayer() {
	acertos = 0;
	erros = 0;
	tempoTotal = 0;
	dicaEliminacao = false;
	dicaPorcentagens = false;
	dicaPular = false;
	perguntasPartida = 0;

	string nomeJogador;
	cout << endl 
		 << "Nome do jogador: ";
	cin >> nomeJogador;

	do {
		cout << endl;
		criarPergunta();

		cout << "===== PLACAR =====" << endl;
		cout << "Acertos: " << acertos << endl;
		cout << "Erros: " << erros << endl << endl;
	} while (perguntasPartida < 12); 

	double q = (acertos * 50)/12;
	double t = 50 - ((tempoTotal - 60) * (50/120));
	if (t > 50) {
		t = 50;
	}
	pontuacaoFinal = ceil(q + t);

	if (pontuacaoFinal < 0) {
		pontuacaoFinal = 0;
	}
	
	armazenaInfos(nomeJogador, pontuacaoFinal);
	cout << "Obrigado por jogar, pontuacao final: " << pontuacaoFinal << endl;
	cout << endl << endl << endl;
	
	verRanking();
}

/* 
	Funcao que inicia o modo MultiPlayer competindo contra um outro jogador.
*/
void multiPlayer() {
	cout << "===== MODO MULTIPLAYER =====" << endl << endl;

	cout << "----- Vez do Jogador 1 -----" << endl;
	singlePlayer();
	int p1 = pontuacaoFinal;

	cout << "----- Vez do Jogador 2 -----" << endl;
	singlePlayer();
	int p2 = pontuacaoFinal;

	if (p1 > p2) {
		cout << "\033[0;32;1m" << "O jogador 1 venceu" << endl;
	} else if (p1 < p2) {
		cout << "\033[0;32;1m" << "O jogador 2 venceu" << endl;
	} else {
		cout << "\033[36;1m" << "Tivemos um EMPATE" << endl;
	}
	cout << "\x1b[0m";
}

/*
	Funcao que armazena as informacoes do jogador (nome e pontuacao).
*/
void armazenaInfos(string jogador, int pontuacao) {
	ifstream json_file("rankinInfos.json");
	jsonf jsonfile;
	json_file >> jsonfile;

	json j = {jogador, pontuacao};
	jsonfile += j;

	ofstream file("rankinInfos.json");
    file << jsonfile;
	
}

/*
	Funcao que exibe o ranking das 10 melhores pontuacoes quando fora da partida.
*/
void verRanking() {
	ifstream json_file("rankinInfos.json");
	jsonf jsonfile;
	json_file >> jsonfile;

	if (!(jsonfile.empty())) {
		cout << endl << "====== RANKING ======" << endl;

		int max;
		json temp;
		for (int i=0; i < jsonfile.size(); i++){
			max = i;
			for (int j=i+1; j < jsonfile.size(); j++){
				if (jsonfile[j][1] > jsonfile[max][1]){
					max = j;
				}
			}
			temp=jsonfile[i];
			jsonfile[i]=jsonfile[max];
			jsonfile[max]=temp;
		}

		int pos = 1;

		for (int i=0; i < 11 && i < jsonfile.size(); i++) {
			if (pos == 1) {
				cout << "\033[33;1m" << pos << ". "
					<< jsonfile[i][0] << " - "
					<< jsonfile[i][1] << "\x1b[0m"
					<< endl;
			} else if (pos == 2) {
				cout << "\033[34;1m" << pos << ". "
					<< jsonfile[i][0] << " - "
					<< jsonfile[i][1] << "\x1b[0m"
					<< endl;
			} else if (pos == 3) {
				cout << "\033[36m" << pos << ". "
					<< jsonfile[i][0] << " - "
					<< jsonfile[i][1] << "\x1b[0m"
					<< endl;
			} else {
				cout << pos << ". "
					<< jsonfile[i][0] << " - "
					<< jsonfile[i][1]
					<< endl;
			}	
			pos ++;
		}
		cout << "=====================" << endl << endl;
	}


}

/*
	Funcao que ativa o bônus/recompensa do jogador durante a partida
*/
void darRecompensa() {
	int v = -1;

	if (dicaEliminacao == true && dicaPorcentagens == true && dicaPular == true) {
		do {
			v = randomValue(4);
		} while (v < 1 || v > 3);
	} else if (dicaEliminacao == true && dicaPorcentagens == false && dicaPular == false) {
		v = 1;
	} else if (dicaEliminacao == false && dicaPorcentagens == true && dicaPular == false) {
		v = 2;
	} else if (dicaEliminacao == false && dicaPorcentagens == false && dicaPular == true) {
		v = 3;
	} else if (dicaEliminacao == true && dicaPorcentagens == true && dicaPular == false) {
		do {
			v = randomValue(3);
		} while (v < 1 || v > 2);
	} else if (dicaEliminacao == true && dicaPorcentagens == false && dicaPular == true) {
		do {
			v = randomValue(4);
		} while (v < 1 || v > 3 || v == 2);
	} else if (dicaEliminacao == false && dicaPorcentagens == true && dicaPular == true) {
		do {
			v = randomValue(4);
		} while (v < 2 || v > 3);
	}

	
	if (v == 1) {
		dicaEliminacao = false;
	} else if (v == 2) {
		dicaPorcentagens = false;
	} else if (v == 3) {
		dicaPular = false;
	}
	
}

/*
	Funcao que exibe uma pergunta do BD excolhida aleatoriamente utilizando o ID de uma pergunta e chama a funcao que pede a resposta da questao
*/
void criarPergunta() {
	ifstream json_file("perguntas.json");
	json perguntas;
	json_file >> perguntas;

	int perguntaID = -1;
	bool jaUsada;

	do {
		perguntaID = randomValue(perguntas.size());
		jaUsada = find(perguntasUsadas.begin(), perguntasUsadas.end(), perguntaID) != perguntasUsadas.end();

	} while (jaUsada == true);
		
	perguntasUsadas.push_back(perguntaID);

	cout << "Tipo: " << perguntas[perguntaID]["tipo"] << endl;
	cout << "Pergunta: " << perguntas[perguntaID]["pergunta"] << endl;
	
	cout << "A: " << perguntas[perguntaID]["a"] << '\n';
	cout << "B: " << perguntas[perguntaID]["b"] << '\n';
	cout << "C: " << perguntas[perguntaID]["c"] << '\n';
	cout << "D: " << perguntas[perguntaID]["d"] << '\n';
	cout << "E: " << perguntas[perguntaID]["e"] << '\n';
	
	if (dicaEliminacao == false || dicaPorcentagens == false || dicaPular == false) {
		cout << "P: PEDIR DICA" << '\n';
	} else {
		cout << "P: Voce nao possui mais dicas" << '\n';
	}

	time_t tempo = time(0);

	bool valida = false;
	string resposta;

	do {
		cout << "Resposta: ";
		cin >> resposta;
		
		resposta = tolower(resposta);
		valida = find(validas.begin(), validas.end(), resposta) != validas.end();

	} while (valida != true);

	if (tolower(resposta) == "p") {
		if (dicaEliminacao == false || dicaPorcentagens == false || dicaPular == false) {
			cout << endl;
			int tipoDica = exibirDicas(perguntaID);
			
			if (tipoDica != 3) {
				
				do {
					cout << "Resposta final: ";
					cin >> resposta;

					resposta = tolower(resposta);
					valida = find(validas.begin(), validas.end(), resposta) != validas.end();

				} while (valida != true);

			} else {
				return;				
			}
		} else {
			do {
				cout << "Resposta: ";
				cin >> resposta;

				resposta = tolower(resposta);
				valida = find(validas.begin(), validas.end(), resposta) != validas.end();

			} while (valida != true || resposta == "p");
		}
		

	}

	if (resposta == perguntas[perguntaID]["resposta"]){
		cout << "\033[0;32m" << "Acertou!!!" << endl << endl;
		acertos++;
	}
	else{
		cout << "\033[31;1m" << "Voce errou. A resposta certa era a letra " << perguntas[perguntaID]["resposta"] << endl << endl;
		erros++;
	}
	perguntasPartida++;
	tempo = time(0) - tempo; 
	if(tempo > 15){
		tempo = 15;
	}
	if (tempo <= 5 && resposta == perguntas[perguntaID]["resposta"]) {
		darRecompensa();
	}

	tempoTotal += tempo;
	cout << "\x1b[0m";
}

/* 
	Funcao que exibe as dicas para o usuario, conforme ele pedir.
*/
int exibirDicas(int perguntaID) {
	ifstream json_file("perguntas.json");
	json perguntas;
	json_file >> perguntas;
	
	if (dicaEliminacao == false) {
		cout << "1) Eliminar alternativas" << endl;
	}

	if (dicaPorcentagens == false) {
		cout << "2) Opiniao dos internautas" << endl;
	}

	if (dicaPular == false) {
		cout << "3) Pular pergunta" << endl;
	}

	bool valida;
	string tipoDica;
	int dica;
	do {
		cout << "Sua escolha: ";
		cin >> tipoDica;

		if (tipoDica == "1" && dicaEliminacao == false) {
			valida = true;
			dica = 1;
		} else if (tipoDica == "2" && dicaPorcentagens == false) {
			valida = true;
			dica = 2;
		} else if (tipoDica == "3" && dicaPular == false) {
			valida = true;
			dica = 3;
		}

	} while (valida != true);


	switch (dica) {
		case 1:{
			cout << "\nUma das alternativas a seguir esta correta: \n" << (string) perguntas[perguntaID]["eliminacao"] << endl;
			dicaEliminacao = true;
			break;
		}
		case 2:{
			cout << "\nEssa eh a opiniao dos internautas: \n" << (string) perguntas[perguntaID]["porcentagens"];
			dicaPorcentagens = true;
			break;
		}
		case 3:{
			cout << "\nVamos para a proxima pergunta!\n";
			dicaPular = true;
			break;
		}
		default:{
			cout << "Opcao invalida! Selecione uma opcao valida!" << endl;
			break;
		}
	}
	return dica;
}

/*
	Metodo que e responsavel por receber uma string e deixa-la em minusculo.
*/
string tolower(string word) {
	string lower;
	for (int i = 0; i < word.length(); i++) {
		if (word.at(i) >= UP_A && word.at(i) <= UP_Z) {
			lower += (word.at(i) + 32);
		}
		else {
			lower += word.at(i);
		}
	}
	return lower;
}

/*
	Funcao que calcula um inteiro aleatoriamente para servir de ID para cada questao.
*/
int randomValue(int max) {
	int perguntaID = 100 + max;
	int r;
	
	while (perguntaID > max){
		random_device rd;						  
		mt19937 eng(rd());						
		uniform_int_distribution<> distr(0, max);

		for (int n = 0; n < 40; ++n){
			r = distr(eng);
			if (r < max){
				perguntaID = r;
				break;
			}
		}
	}
	return perguntaID;
}

/*
	Funcao que faz com que o jogador jogue novamente, se ele desejar
*/
string playAgain() {
	string opcao;
		cout << "===== Partida encerrada =====" << endl 
			 << "Deseja jogar novamente? " << endl 
			 << "(s = sim; n = nao) ";
		cin >> opcao;
	return tolower(opcao);
}
