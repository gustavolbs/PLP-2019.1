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
// Funções
void criaPartidaMenu();  // Feito
void singlePlayer();	 // Feito
void multiPlayer();		 // Sem cabimento
void verRanking();		 // A fazer (sei nao, viss...)
void ativarRecompensa(); // A fazer
void finalizarPartida(); // Expliquem a ideia desse metodo
void criarPergunta(int tipoPergunta);	// Feito
void playAgain();	// A fazer
int randomValue(int max);

vector<int> perguntasUsadas;
int acertos = 0;
int erros = 0;

/* Printa os valores dentro de um vetor */
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
	// Inicia o modo SinglePlayer

	// Random de perguntas

	for(int i = 0;i < 12;i++){
		cout << endl;
		criarPergunta(i % 4);

		cout << "===== PLACAR =====" << endl;
		cout << "Pontuação: " << acertos << endl;
		cout << "Erros: " << erros << endl << endl;

	}
	int pontuacaoFinal = (acertos * 0.6) - (erros * 0.4); //falta ajustar
	//cout << "Obrigado por jogar, porntuacao final: " << pontuacaoFinal << "\nAcertos: " << pontuacao << "\nErros: " << erros << endl;
	cout << "Obrigado por jogar, porntuacao final: " << pontuacaoFinal << endl;
	
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
void criarPergunta(int tipoPergunta){
	// Exibe uma pergunta do banco de dados aleatoriamente utilizando o id da pergunta ao usuário e pede uma resposta
	ifstream json_file("perguntas.json");
	json perguntas;
	json_file >> perguntas;
	int perguntaID = -1;
	bool jaUsada;
	string key;
	cout << tipoPergunta << endl;
	do{
		perguntaID = randomValue(perguntas.size());
		key = to_string(perguntaID);
		jaUsada = find(perguntasUsadas.begin(), perguntasUsadas.end(), perguntaID) != perguntasUsadas.end();

	}while(jaUsada == true);
	/* || !(
	(tipoPergunta == 0 && perguntas[key]["tipo"] == "humanas") ||
	(tipoPergunta == 1 && perguntas[key]["tipo"] == "linguagens") ||
	(tipoPergunta == 2 && perguntas[key]["tipo"] == "matematica") ||
	(tipoPergunta == 3 && perguntas[key]["tipo"] == "natureza")
	));
	*/

	//Precisamos adicionar mais perguuntas de matematica

	perguntasUsadas.push_back(perguntaID);

	// Enunciado pergunta
	cout << "Pergunta: " << perguntas[key]["pergunta"] << endl;

	// Opções
	cout << "A: " << perguntas[key]["a"] << '\n';
	cout << "B: " << perguntas[key]["b"] << '\n';
	cout << "C: " << perguntas[key]["c"] << '\n';
	cout << "D: " << perguntas[key]["d"] << '\n';
	cout << "E: " << perguntas[key]["e"] << '\n';

	// Resposta pergunta
	cout << "Resposta: ";
	string resposta;
	cin >> resposta;
	if (resposta == perguntas[key]["resposta"]){
		cout << "\033[0;32m" << "Acertou!!" << endl << endl;
		acertos++;
	}
	else{
		cout << "\033[1;31m" << "Voce errou. A resposta certa era a letra " << perguntas[key]["resposta"] << endl << endl;
		erros++;
	}
	cout << "\x1b[0m";
}

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
