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
#include <iterator> // for std::begin, std::end
#include <ctime>

using namespace std;
using json = nlohmann::json;
using jsonf = nlohmann::json;

#define UP_A 65
#define UP_Z 91
#define LOW_A 97
#define LOW_Z 122

//Precisamos adicionar mais perguuntas de matematica


// Funções
void multiPlayer();		 							// Em andamento (falta testar e ajustar, se for preciso)
void playAgain();									// Em andamento (falta testar e ajustar, se for preciso)

// Feitos
void criaPartidaMenu();  							// Feito -> Ajustando para Multiplayer
void criarPergunta();								// Feito
void singlePlayer();	 							// Feito -> Ajustar calculo pontuação
int randomValue(int max); 							// Feito
string tolower(string word); 						// Feito
int exibirDicas(int perguntaID); 					// Feito
void armazenaInfos(string jogador, int pontuacao);  // Feito
void verRanking();		 							// Feito
void darRecompensa(); 								// Feito
void print(vector<int> const &a);					// Feito


// Variáveis Globais
vector<int> perguntasUsadas;
vector<string> validas = {"a","b","c","d","e","p"};
int acertos = 0;
int erros = 0;
int tempoTotal = 0;
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
	time_t t = time(0);
	cout << "===== PerguntUP =====" << endl << endl;
	criaPartidaMenu();
	cout << "Tempo: " << (time(0) - t) << "'s"<< endl;
	playAgain();
}

/* 
	Função que cria o menu do jogo e verifica se o usuário quer realmente jogar.
*/
void criaPartidaMenu() {
	int modo;
	int comecar;


	do{
		verRanking();
		string iniciar;
		cout << "Deseja iniciar uma nova partida?" << endl;
		cout << "(s = sim; n = não): ";
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
					cout << "Qual a forma de jogar?" << endl << "s = singlePlayer; m = multiPlayer" << endl;
					cin >> modalidade;
					modo = 2;

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
	Função que inicia o modo SinglePlayer competindo contra o BOT (vamo verificar isso).
*/
void singlePlayer() {
	string nomeJogador;
	cout << "Nome do jogador: ";
	cin >> nomeJogador;

	do {
		cout << endl;
		criarPergunta();

		cout << "===== PLACAR =====" << endl;
		cout << "Acertos: " << acertos << endl;
		cout << "Erros: " << erros << endl << endl;
	} while (acertos < 10 && erros < 3); 

	
	int pontuacaoFinal = (acertos * 0.6) + ((180 - tempoTotal) * 0.4);
	if (pontuacaoFinal < 0) {
		pontuacaoFinal = 0;
	}
	
	armazenaInfos(nomeJogador, pontuacaoFinal);
	cout << "Obrigado por jogar, pontuacao final: " << pontuacaoFinal << endl;
	cout << endl << endl << endl << endl;
	
	verRanking();
}

/* 
	Função que inicia o modo MultiPlayer competindo contra um outro jogador.
*/
void multiPlayer() {
	cout << "===== MODO MULTIPLAYER =====" << endl << endl;

	cout << "----- Vez do Jogador 1 -----" << endl;
	singlePlayer();

	system("cls");

	cout << "----- Vez do Jogador 1 -----" << endl;
	singlePlayer();

}

/*
	Função que armazena as informações do jogador (nome e pontuacao).
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
	Função que exibe o ranking das 10 melhores pontuações quando fora da partida.
*/
void verRanking() {
	ifstream json_file("rankinInfos.json");
	jsonf jsonfile;
	json_file >> jsonfile;

	cout << "====== RANKING ======" << endl;

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

/*
	Função que ativa o bônus/recompensa do jogador durante a partida
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
	Função que exibe uma pergunta do BD excolhida aleatoriamente utilizando o ID de uma pergunta e chama a função que pede a resposta da questão
*/
void criarPergunta() {
	// Exibe uma pergunta do banco de dados aleatoriamente utilizando o id da pergunta ao usuário e pede uma resposta
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

	// Enunciado pergunta
	cout << "Tipo: " << perguntas[perguntaID]["tipo"] << endl;
	cout << "Pergunta: " << perguntas[perguntaID]["pergunta"] << endl;
	// Opções
	cout << "A: " << perguntas[perguntaID]["a"] << '\n';
	cout << "B: " << perguntas[perguntaID]["b"] << '\n';
	cout << "C: " << perguntas[perguntaID]["c"] << '\n';
	cout << "D: " << perguntas[perguntaID]["d"] << '\n';
	cout << "E: " << perguntas[perguntaID]["e"] << '\n';
	
	if (dicaEliminacao == false || dicaPorcentagens == false || dicaPular == false) {
		cout << "P: PEDIR DICA" << '\n';
	} else {
		cout << "P: Você não possui mais dicas" << '\n';
	}

	time_t tempo = time(0);

	bool valida = false;
	// Resposta pergunta
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

	tempo = time(0) - tempo; 
	if (tempo <= 5) {
		darRecompensa();
	}

	tempoTotal += tempo;
	cout << "\x1b[0m";
}

/* 
	Função que exibe as dicas para o usuário, conforme ele pedir.
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
	int tipoDica;
	do {
		cout << "Sua escolha: ";
		cin >> tipoDica;
		cin.sync();

		if (tipoDica == 1 && dicaEliminacao == false) {
			valida = true;
		} else if (tipoDica == 2 && dicaPorcentagens == false) {
			valida = true;
		} else if (tipoDica == 3 && dicaPular == false) {
			valida = true;
		}

	} while (valida != true);


	switch (tipoDica) {
		// Eliminar respostas
		case 1:{
			cout << "\nUma das alternativas a seguir esta correta: \n" << (string) perguntas[perguntaID]["eliminacao"] << endl;
			dicaEliminacao = true;
			break;
		}
		// Porcentagem das questões
		case 2:{
			cout << "\nEssa eh a opiniao dos internautas: \n" << (string) perguntas[perguntaID]["porcentagens"];
			dicaPorcentagens = true;
			break;
		}
		// Pular pergunta
		case 3:{
			cout << "\nVamos para a próxima pergunta!\n";
			dicaPular = true;
			break;
		}
		default:{
			cout << "Opção inválida! Selecione uma opção válida!" << endl;
			break;
		}
	}
	return tipoDica;
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
	Função que calcula um inteiro aleatoriamente para servir de ID para cada questão.
*/
int randomValue(int max) {
	int perguntaID = 100 + max;
	int r;
	/* Random number --> Bad alloc */
	while (perguntaID > max){
		random_device rd;						  // obtain a random number from hardware
		mt19937 eng(rd());						  // seed the generator
		uniform_int_distribution<> distr(0, max); // define the range

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
	Função que faz com que o jogador jogue novamente, se ele desejar
*/
void playAgain() {
	string opcao;
	do {
		cout << "===== Partida encerrada =====" << endl << "Deseja jogar novamente?" << endl;
		cin >> opcao;
		if (tolower(opcao) == "s") {
			criaPartidaMenu();
		}
	} while (tolower(opcao) != "s");
	
	
}