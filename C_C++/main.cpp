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


using namespace std;
using json = nlohmann::json;

#define UP_A 65
#define UP_Z 91
#define LOW_A 97
#define LOW_Z 122



// Funções
void multiPlayer();		 // Sem cabimento
void verRanking();		 // A fazer (sei nao, viss...)
void ativarRecompensa(); // A fazer
void finalizarPartida(); // Expliquem a ideia desse metodo
void playAgain();	// A fazer
int exibirDicas(string Key); // A fazer

// Feitos
void criaPartidaMenu();  // Feito
void criarPergunta();	// Feito
void singlePlayer();	 // Feito
int randomValue(int max); // Feito
string tolower(string word);

vector<int> perguntasUsadas;
int acertos = 0;
int erros = 0;
bool dicaEliminacao = false;
bool dicaPorcentagens = false;
bool dicaPular = false;





/* 
	Printa os valores dentro de um vetor
*/
void print(vector<int> const &a){
	cout << "The vector elements are : ";

	for (int i = 0; i < a.size(); i++){
		cout << a.at(i) << ' ';
	}
}

// Main
int main(){
	cout << "===== PerguntUP =====" << endl << endl;
	criaPartidaMenu();
}

/* 
	Função que cria o menu do jogo e verifica se o usuário quer realmente jogar.
*/
void criaPartidaMenu(){
	int modo;
	int comecar;
	do{
		string iniciar;
		cout << "Deseja iniciar uma nova partida?" << endl;
		cout << "(s = sim; n = não) \n";
		cin >> iniciar;

		if (iniciar == "s" || iniciar == "S"){
			comecar = 1;
		}
		else if (iniciar == "n" || iniciar == "N"){
			comecar = 0;
		}
		else{
			comecar = 2;
		}

		switch (comecar){
		case 1:{

			string modalidade;
			do{
				/* cout << "Qual a forma de jogar?" << endl << "s = singlePlayer; m = multiPlayer" << endl;
					cin >> modalidade;

					if (modalidade == "s" || modalidade == "S") {
						modo = 0;
					} else if (modalidade == "m" || modalidade == "M") {
						modo = 1;
					} else {
						modo = 2;
					} */
				modo = 0;
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
void singlePlayer(){
	do {
		cout << endl;
		criarPergunta();

		cout << "===== PLACAR =====" << endl;
		cout << "Pontuação: " << acertos << endl;
		cout << "Erros: " << erros << endl << endl;
	} while (acertos <= 10 && erros < 3); 

	
	int pontuacaoFinal = (acertos * 0.6) - (erros * 0.4); //falta ajustar
	if (pontuacaoFinal < 0) {
		pontuacaoFinal = 0;
	}
	
	cout << "Obrigado por jogar, pontuacao final: " << pontuacaoFinal << endl;
	cout << endl << endl << endl << endl;
	
}

/* 
	Função que inicia o modo MultiPlayer competindo contra um outro jogador (vamo verificar isso).
*/
void multiPlayer(){
	// Inicia o modo MultiPlayer
}

/*
	Função que exibe o ranking de pontuacao quando fora da partida. (Isso vai ser loko)
*/
void verRanking(){
	// Exibe o ranking enquanto fora de uma partida
}

/*
	Função que ativa o bônus/recompensa do jogador durante a partida
*/
void ativarRecompensa(){
	// usado dentro de uma partida
}

/*
	Função que finaliza uma partida (tenho minhas duvidas sobre esse método)
*/
void finalizarPartida(){
	// Encerra a partida atual (caso o usuário não esteja em uma pegunta)
}

/*
	Função que exibe uma pergunta do BD excolhida aleatoriamente utilizando o ID de uma pergunta e chama a função que pede a resposta da questão
*/
void criarPergunta(){
	// Exibe uma pergunta do banco de dados aleatoriamente utilizando o id da pergunta ao usuário e pede uma resposta
	ifstream json_file("perguntas.json");
	json perguntas;
	json_file >> perguntas;

	int perguntaID = -1;
	bool jaUsada;

	string key;
	
	
	do{
		perguntaID = randomValue(perguntas.size());
		key = to_string(perguntaID);
		jaUsada = find(perguntasUsadas.begin(), perguntasUsadas.end(), perguntaID) != perguntasUsadas.end();

	} while(jaUsada == true);
	
	
	//Precisamos adicionar mais perguuntas de matematica

	perguntasUsadas.push_back(perguntaID);

	// Enunciado pergunta
	cout << "Tipo: " << perguntas[key]["tipo"] << endl;
	cout << "Pergunta: " << perguntas[key]["pergunta"] << endl;

	// Opções
	cout << "A: " << perguntas[key]["a"] << '\n';
	cout << "B: " << perguntas[key]["b"] << '\n';
	cout << "C: " << perguntas[key]["c"] << '\n';
	cout << "D: " << perguntas[key]["d"] << '\n';
	cout << "E: " << perguntas[key]["e"] << '\n';
	cout << "P: PEDIR DICA" << '\n';
	
	// Resposta pergunta
	cout << "Resposta: ";
	string resposta,resposta1;
	cin >> resposta1;
	resposta = tolower(resposta1);

	if (resposta == "p" || resposta == "P") {
		cout << endl;
		int tipoDica = exibirDicas(key);
		
		if (tipoDica != 3) {
			cout << "Resposta final: ";
			cin >> resposta;
		}
	}


	if (resposta == perguntas[key]["resposta"]){
		cout << "\033[0;32m" << "Acertou!!!" << endl << endl;
		acertos++;
	}
	else{
		cout << "\033[1;31m" << "Voce errou. A resposta certa era a letra " << perguntas[key]["resposta"] << endl << endl;
		erros++;
	}
	cout << "\x1b[0m";
}

/* 
	Função que exibe as dicas para o usuário, conforme ele pedir.
*/
int exibirDicas(string Key) {
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

	int tipoDica;
	cin >> tipoDica;

	switch (tipoDica) {
		// Eliminar respostas
		case 1:{
			cout << "Uma das alternativas a seguir esta correta: " << perguntas[Key]["eliminacao"] << endl;
			dicaEliminacao = true;
			break;
		}
		// Porcentagem das questões
		case 2:{
			cout << "Essa eh a opiniao dos internautas: " << perguntas[Key]["porcentagens"];
			dicaPorcentagens = true;
				break;
		}
		// Pular pergunta
		case 3:{
			cout << "Vamos para a próxima questão" << endl;
			dicaPular = true;
			break;
		}
		default:{
			cout << "FAZER VERIFICAÇÂO DICA INVALIDA" << endl;
			break;
		}
	}
	return tipoDica;
}

/*
	Metodo que e responsavel por receber uma string e deixa-la em minusculo.
		Usado principalmente para a validacao das respostas.
*/
string tolower(string word){
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
int randomValue(int max){
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
