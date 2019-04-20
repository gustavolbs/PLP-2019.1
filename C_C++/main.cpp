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
void criarPergunta();	// Feito

vector<int> perguntas_usadas;
int pontuacao = 0;
int erros = 0;

/* Printa os valores dentro de um vetor */
void print(std::vector<int> const &a)
{
	std::cout << "The vector elements are : ";

	for (int i = 0; i < a.size(); i++)
		std::cout << a.at(i) << ' ';
}

// Main
int main()
{
	cout << "===== PerguntUP =====" << endl
		 << endl;
	criaPartidaMenu();
}

/* 
	Função que cria o menu do jogo e verifica se o usuário quer realmente jogar.
*/
void criaPartidaMenu()
{
	int modo;
	int comecar;
	do
	{
		string iniciar;
		cout << "Deseja iniciar uma nova partida?" << endl;
		cout << "(s = sim; n = não) \n";
		cin >> iniciar;

		if (iniciar == "s" || iniciar == "S")
		{
			comecar = 1;
		}
		else if (iniciar == "n" || iniciar == "N")
		{
			comecar = 0;
		}
		else
		{
			comecar = 2;
		}

		switch (comecar)
		{
		case 1:
		{

			string modalidade;
			do
			{
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
				switch (modo)
				{
				case 0:
				{
					singlePlayer();
					break;
				}
				case 1:
				{
					multiPlayer();
					break;
				}
				default:
				{
					cout << "OPCAO INVALIDA!" << endl;
				}
				}
			} while (modo != 0 && modo != 1);
			break;
		}
		case 0:
		{
			cout << "Obrigado por jogar!" << endl;
			exit(0);
			break;
		}
		default:
		{
			cout << "OPCAO INVALIDA!" << endl;
		}
		}
	} while (modo != 0 && modo != 1);
}

/* 
	Função que inicia o modo SinglePlayer competindo contra o BOT (vamo verificar isso).
*/
void singlePlayer()
{
	// Inicia o modo SinglePlayer

	// Random de perguntas

	do
	{
		cout << endl;
		criarPergunta();

		cout << "===== PLACAR =====" << endl;
		cout << "Pontuação: " << pontuacao << endl;
		cout << "Erros: " << erros << endl
			 << endl;

	} while (pontuacao <= 10 && erros < 3);

	if (pontuacao >= 10) {
		cout << "Parabéns, você venceu com " << pontuacao << " e " << erros << " erros" << endl;
	} else if (erros >= 3 && pontuacao > 0) {
		cout << "Ah, que pena. Você errou " << erros << " vezes e por isso perdeu, mas você conseguiu marcar " << pontuacao << " ponto(s)" << endl;
	} else if (erros >= 3 && pontuacao == 0) {
		cout << "Que chato, você errou " << erros << " vezes e não acertou nenhuma vez. Mais sorte na próxima vez." << endl;
	}
}

/* 
	Função que inicia o modo MultiPlayer competindo contra um outro jogador (vamo verificar isso).
*/
void multiPlayer()
{
	// Inicia o modo MultiPlayer
}

/*
	Função que exibe o ranking de pontuacao quando fora da partida. (Isso vai ser loko)
*/
void verRanking()
{
	// Exibe o ranking enquanto fora de uma partida
}

/*
	Função que ativa o bônus/recompensa do jogador durante a partida
*/
void ativarRecompensa()
{
	// usado dentro de uma partida
}

/*
	Função que finaliza uma partida (tenho minhas duvidas sobre esse método)
*/
void finalizarPartida()
{
	// Encerra a partida atual (caso o usuário não esteja em uma pegunta)
}

/*
	Função que exibe uma pergunta do BD excolhida aleatoriamente utilizando o ID de uma pergunta e chama a função que pede a resposta da questão
*/
void criarPergunta()
{
	// Exibe uma pergunta do banco de dados aleatoriamente utilizando o id da pergunta ao usuário e pede uma resposta

	int pergunta_id = 100;
	int r;
	do
	{
		/* Random number --> Bad alloc */
		while (pergunta_id > 47)
		{
			std::random_device rd;						  // obtain a random number from hardware
			std::mt19937 eng(rd());						  // seed the generator
			std::uniform_int_distribution<> distr(0, 48); // define the range

			for (int n = 0; n < 40; ++n)
			{
				r = distr(eng);
				if (r < 48)
				{
					pergunta_id = r;
					break;
				}
			}
			break;
		}

		if (!perguntas_usadas.empty())
		{
			bool exists = std::find(perguntas_usadas.begin(), perguntas_usadas.end(), pergunta_id) != perguntas_usadas.end();
			if (exists != true)
			{
				break;
			}
			cout << exists << endl;
		}
		else
		{
			break;
		}
	} while (true);

	perguntas_usadas.push_back(pergunta_id);

	std::ifstream json_file("perguntas.json");
	json perguntas;
	json_file >> perguntas;

	std::string key = std::to_string(pergunta_id);

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

	if (resposta == perguntas[key]["resposta"])
	{
		cout << "Acertou!!" << endl
			 << endl;
		pontuacao++;
		return;
	}
	else
	{
		cout << "Voce errou. A resposta certa era a letra " << perguntas[key]["resposta"] << endl
			 << endl;
		erros++;
		return;
	}
}
