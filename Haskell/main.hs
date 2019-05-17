import System.IO
import Data.Char
import System.Random
import Data.List.Split
import Control.Monad

data Pergunta =
    Pergunta { pergunta :: String
            , a :: String
            , b :: String
            , c :: String
            , d :: String
            , e :: String
            , tipo :: String
            , resposta :: String
                } deriving Show

-- Funcao que só mostra as instrucoes do jogo                
instrucoes :: String
instrucoes = "\n===== Instrucoes =====\nO PerguntUP eh um jogo de perguntas que pode ser jogado de duas maneiras:\n-> Singleplayer ou Multiplayer\nCada partida possui 12 perguntas, divididas em 4 areas de conhecimento:\n- Ciencias da Natureza\n- Linguagens\n- Ciencias Exatas\n- Ciencias Humanas\nVoce tera 15 segundos para responder cada pergunta (caso ultrapasse esse tempo, a pontuacao final sera penalizada)\nAlehm disso, haverao dicas limitadas disponiveis:\n- Eliminar alternativas: elimina duas alternativas\n- Opiniao dos internautas: mostra a porcentagem de concordancia com cada alternativa\n- Pular pergunta: pula para a proxima pergunta\nA cada inicio de partida, voce tera 1 dica de cada\nPara obter mais dicas, voce devera responder a pergunta em menos de 5 segundos\nSe ja tiver sido usado alguma dica, ela sera reposta. Caso contrario, a dica recebida sera aleatoria\nAlem disso, o sistema conta com um ranking com as 10 melhores pontuacoes. Ele e exibido no inicio e no final de cada partida\n"

-- Funcao principal do programa. Executa a parte logica atraves de chamadas de funcoes secundarias
main :: IO ()
main = do 
    ent <- entradaUser ("\n===== PerguntUP =====" ++ "\nby GERIGE" ++ "\n\n(1) Ver as instrucoes\n(2) Seguir para o jogo\n(3) Sair\n")
    case ent of
        "1" -> -- Ver as instrucoes chamando a funcao "instrucoes"
            do
                putStrLn (instrucoes)
                main -- Chama novamente o "main" apos a execucao
                return() -- Fecha a funcao apos toda a recursividade
        "2" -> -- Seguir para o jogo em si chamando a funcao "criarPartida"
            do
                criarPartida -- Executa a funcao que inicia o menu para comecar uma partida
                return() -- Fecha a funcao apos toda a recursividade
        "3" -> -- Sai do jogo
            return()  -- Fecha a funcao apos toda a recursividade
        _ -> -- Qualquer outra entradaUser que nao seja "1", "2" ou "3" sera ignorada e a funcao sera chamada novamente
            do
                putStrLn ("\nOpcao Invalida!\n")
                main -- Chamada do "main" para entradas invalidas
                return()  -- Fecha a funcao apos toda a recursividade

















                
-- Funcao que cuida da criacao da partida atraves de chamadas de funcoes secundarias
criarPartida :: IO ()
criarPartida = do
    ent <- entradaUser ("\nDeseja iniciar uma nova partida?\n(1) Sim\n(2) Nao\n")
    case ent of
        "1" -> -- Iniciar um nova partida chamando a funcao "modoJogo"
            do
                modoJogo
                criarPartida -- Chama novamente a funcao "criarPartida" caso o usuario deseje jogar novamente
                return()  -- Fecha a funcao apos toda a recursividade
        "2" -> -- Fecha o jogo e retorna para o "main"
            do
                putStrLn ("\nObrigado por jogar!\n")
                main -- Chama o "main" para que o programa reinicie
                return()  -- Fecha a funcao apos toda a recursividade
        _ ->
            do
                putStrLn ("\nOpcao Invalida!\n")
                criarPartida -- Chama a funcao 
                return()  -- Fecha a funcao apos toda a recursividade

-- Funcao que 
modoJogo :: IO ()
modoJogo = do
    ent <- entradaUser ("\nQual o modo de jogo?\n(1) SinglePlayer\n(2) MultiPlayer\n")
    case ent of
        "1" ->
            do
                singlePlayer
                return()  -- Fecha a funcao apos toda a recursividade
        "2" ->
            do
                putStrLn ("\nMultiPlayer\n")
                return()  -- Fecha a funcao apos toda a recursividade
        _ ->
            do
                putStrLn ("\nOpcao Invalida!\n")
                modoJogo
                return()  -- Fecha a funcao apos toda a recursividade

entradaUser :: String -> IO String
entradaUser ent = do
    putStrLn (ent)
    getLine

singlePlayer :: IO ()
singlePlayer = do

-- Definir "VARIÀVEIS"

    ent <- entradaUser("\nNome do Jogador:")
    
    printPergunta12 12    
    
    
    
    escrita (ent,"pontuacao")
    

printPergunta12 n
    | n == 0 = do return ()
    | otherwise = do 
        gerandoPerguntaAleatoria
        printPergunta12 (n-1)


escrita :: (String,String) -> IO ()
escrita inth = do
    arq <- readFile "ranking.txt"
    let newArq = arq ++ (fst inth ++ ":" ++ snd inth ++ "\r\n")
    when (length newArq > 0) $
        writeFile "ranking.txt" newArq

    
gerandoPerguntaAleatoria :: IO String
gerandoPerguntaAleatoria = do

    -- Tirar pergunta da Lista


    arq <- readFile "perguntas.txt"
    let lista = splitOn "---" arq
    num <- randomRIO (0,47::Int)
    let pergunta = drop 10 ((splitOn "\r\n" (lista !! num)) !! 0)
        letraA = ((splitOn "\r\n" (lista !! num)) !! 1)
        letraB = ((splitOn "\r\n" (lista !! num)) !! 2)
        letraC = ((splitOn "\r\n" (lista !! num)) !! 3)
        letraD = ((splitOn "\r\n" (lista !! num)) !! 4)
        letraE = ((splitOn "\r\n" (lista !! num)) !! 5)
        tipo = "\n" ++ ((splitOn "\r\n" (lista !! num)) !! 6)
        resposta = drop 10 ((splitOn "\r\n" (lista !! num)) !! 7)
    
    putStrLn (show $ tipo)
    putStrLn (show $ pergunta)
    putStrLn (show $ letraA)
    putStrLn (show $ letraB)
    putStrLn (show $ letraC)
    putStrLn (show $ letraD)
    putStrLn (show $ letraE)

    entradaUser("\nResposta:")
    -- resp <- entradaUser("\nResposta:\n")
    -- case resp of
    --     resposta ->
    --         do
                

