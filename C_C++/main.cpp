#include <iostream>
#include <string>
#include <stdlib.h>
#include <fstream>
#include <vector>
#include <sstream>
#include <string>

using namespace std;

// Funções
void responderPergunta(int pergunta_id);
void criaPartidaMenu();
void singlePlayer();
void multiPlayer();
void verRanking();
void ativarRecompensa();
void finalizarPartida();
void criarPergunta();
void read_record();


// Main
int main() {
	cout << "Este jogo utiliza a conexão com a internet para baixar os dados necessários. Certifique-se de estar conectado.\n\nBaixando dados necessários ..." << endl << endl;
	//da pra funcionar sem internet mas com internet ele vai atualizar o arquivo
	
	system("wget -O questions.csv -q https://docs.google.com/spreadsheets/d/1KOp3Y1zcwSTH1nK_h6pcaACUmvN-lbAY9iDKjmvbfms/export?format=csv&id=1KOp3Y1zcwSTH1nK_h6pcaACUmvN-lbAY9iDKjmvbfms&gid=0");
	
	cout << "Download concluido." << endl << endl;
	read_record();
	cout << "===== PerguntUP =====" << endl << endl;
	criaPartidaMenu();



}


/* 
	Função que recebe o ID de uma pergunta, lê a resposta do usuário e verifica se a resposta condiz com a resposta no banco de dados.
*/
void responderPergunta (int pergunta_id) {
	string perguntas[10][10];//tmp
    // Puxa a resposta certa da questão
	string resposta_certa = perguntas[pergunta_id][0];//posicao arbitaria
    int pontuacao = 0;//Apenas para teste
	
	string resposta;
	cin >> resposta;
	// Verifica a resposta
	if (resposta == resposta_certa) {
		pontuacao++;
	} else {
		cout << "Você errou!" << endl;
	}



	// TO DO
	// Vai pra próxima pergunta
	
}


/* 
	Função que cria o menu do jogo e verifica se o usuário quer realmente jogar.
*/
void criaPartidaMenu() {
	int modo;
	int comecar;
	do {
		string iniciar;
		cout << "Deseja iniciar uma nova partida?" << endl;
		cout << "(s = sim; n = não) \n";
		cin >> iniciar;

		if (iniciar == "s" || iniciar == "S") {
			comecar = 1;
		} else if (iniciar == "n" || iniciar == "N") {
			comecar = 0;
		} else {
			comecar = 2;
		}
		
		switch (comecar) {
			case 1:{

				string modalidade;
				// char mod;
				do {
					cout << "Qual a forma de jogar?" << endl << "s = singlePlayer; m = multiPlayer" << endl;
					cin >> modalidade;

					// mod = tolower(modalidade);
					if (modalidade == "s" || modalidade == "S") {
						modo = 0;
					} else if (modalidade == "m" || modalidade == "M") {
						modo = 1;
					} else {
						modo = 2;
					}

					switch (modo) {
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
				} while( modo != 0 && modo != 1);
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
	} while( modo != 0 && modo != 1);	
}


/* 
	Função que inicia o modo SinglePlayer competindo contra o BOT (vamo verificar isso).
*/
void singlePlayer() {
	// Inicia o modo SinglePlayer
}


/* 
	Função que inicia o modo MultiPlayer competindo contra um outro jogador (vamo verificar isso).
*/
void multiPlayer() {
	// Inicia o modo MultiPlayer
}


/*
	Função que exibe o ranking de pontuacao quando fora da partida. (Isso vai ser loko)
*/
void verRanking() {
	// Exibe o ranking enquanto fora de uma partida
}


/*
	Função que ativa o bônus/recompensa do jogador durante a partida
*/
void ativarRecompensa() {
	// usado dentro de uma partida
}


/*
	Função que finaliza uma partida (tenho minhas duvidas sobre esse método)
*/
void finalizarPartida() {
	// Encerra a partida atual (caso o usuário não esteja em uma pegunta)	
}


/*
	Função que exibe uma pergunta do BD excolhida aleatoriamente utilizando o ID de uma pergunta e chama a função que pede a resposta da questão
*/
void criarPergunta() {
	// Exibe uma pergunta do banco de dados aleatoriamente utilizando o id da pergunta ao usuário e pede uma resposta
	
	int pergunta_id; //tmp
	responderPergunta(pergunta_id);
}


//CSV Reader ALPHA TEST

void read_record(){ 
	
    // File pointer 
    fstream fin; 
  
    // Open an existing file 
    fin.open("questions.csv", ios::in); 
  
    // Read the Data from the file 
    // as String Vector 
    vector<string> row; 
    string line, word, temp; 
    while (fin >> temp) { 
  
        row.clear(); 
		getline(fin, line, '\n'); 
        // read an entire row and 
        // store it in a string variable 'line' 
        getline(fin, line, '\n'); 
		cout << line << endl;
        // used for breaking words 
        stringstream s(line); 
  
        // read every column data of a row and 
        // store it in a string variable, 'word' 
        while (getline(s, word)) {
            // add all the column data 
            // of a row to a vector 
            row.push_back(word);
        } 

            // Print the found data 
            for (int i = 0;i < row.size();i++){
				cout << row[i] << "\n";
			}
             cout << endl;
    } 
} 


/*
string Perguntas () {
string perguntas[] = {"Normalmente, quantos litros de sangue uma pessoa tem? Em média, quantos são retirados numa doação de sangue?"

a) Tem entre 2 a 4 litros. São retirados 450 mililitros
b) Tem entre 4 a 6 litros. São retirados 450 mililitros
c) Tem 10 litros. São retirados 2 litros
d) Tem 7 litros. São retirados 1,5 litros
e) Tem 0,5 litros. São retirados 0,5 litros"
}
*/


  //https://stackoverflow.com/questions/25217349/how-to-convert-csv-file-to-json-using-c//



 //     WES START        //
// Falta fazer o metodo //

// #include <iostream>
// #include <fstream>

// using namespace std;

// int main(){

//   ifstream ip("dadosnp.csv");

//   if(!ip.is_open()) cout << "ERROR: File Open" << '\n';

//   string perguntas,a,b,c,d,e,tipo, result;

//   while(ip.good()){
//     getline(ip,perguntas,',');
//     getline(ip,a,',');
//     getline(ip,b,',');
//     getline(ip,c,',');
//     getline(ip,d,',');
//     getline(ip,e,',');
//     getline(ip,tipo,'\n');

//   // Laco em cima das repostas, FULL GAMBIARRAAAAAAAAA PORRAAAAAAAAAA
//   for(int i = 0; i < tipo.length()-3; i++){
//     result += tipo[i];
//   }

//     cout << perguntas << '\n';
//     cout << "A: " << a << '\n';
//     cout << "B: " << b << '\n';
//     cout << "C: " << c << '\n';
//     cout << "D: " << d << '\n';
//     cout << "E: " << e << '\n';
//     cout << "Tipo: " << result << "\n";
//     result = "";
//     cout << "-------------------" << '\n';
//   }

//   ip.close();
// }