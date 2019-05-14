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

instrucoes :: String
instrucoes = "\n===== Instrucoes =====\nO PerguntUP eh um jogo de perguntas que pode ser jogado de duas maneiras:\n-> Singleplayer ou Multiplayer\nCada partida possui 12 perguntas, divididas em 4 areas de conhecimento:\n- Ciencias da Natureza\n- Linguagens\n- Ciencias Exatas\n- Ciencias Humanas\nVoce tera 15 segundos para responder cada pergunta (caso ultrapasse esse tempo, a pontuacao final sera penalizada)\nAlehm disso, haverao dicas limitadas disponiveis:\n- Eliminar alternativas: elimina duas alternativas\n- Opiniao dos internautas: mostra a porcentagem de concordancia com cada alternativa\n- Pular pergunta: pula para a proxima pergunta\nA cada inicio de partida, voce tera 1 dica de cada\nPara obter mais dicas, voce devera responder a pergunta em menos de 5 segundos\nSe ja tiver sido usado alguma dica, ela sera reposta. Caso contrario, a dica recebida sera aleatoria\nAlem disso, o sistema conta com um ranking com as 10 melhores pontuacoes. Ele e exibido no inicio e no final de cada partida\n"

main :: IO ()
main = do 
    ent <- entradaUser ("\n===== PerguntUP =====" ++ "\nby GERIGE" ++ "\n(1) Ver as instrucoes\n(2) Seguir para o jogo\n(3) Sair\n")
    case ent of
        "1" ->
            do
                putStrLn (instrucoes)
                main
                return()
        "2" ->
            do
                criarPartida
                return()
        "3" ->
            return()
        _ ->
            do
                putStrLn ("\nOpcao Invalida!\n")
                main
                return()

criarPartida :: IO ()
criarPartida = do
    ent <- entradaUser ("\nDeseja iniciar uma nova partida?\n(1) Sim\n(2) Nao\n")
    case ent of
        "1" ->
            do
                modoJogo
                criarPartida
                return()
        "2" ->
            do
                putStrLn ("\nObrigado por jogar!\n")
                return()
        _ ->
            do
                putStrLn ("\nOpcao Invalida!\n")
                criarPartida
                return()

modoJogo :: IO ()
modoJogo = do
    ent <- entradaUser ("\nQual o modo de jogo?\n(1) SinglePlayer\n(2) MultiPlayer\n")
    case ent of
        "1" ->
            do
                singlePlayer
                leitura
                return()
        "2" ->
            do
                putStrLn ("\nMultiPlayer\n")
                return()
        _ ->
            do
                putStrLn ("\nOpcao Invalida!\n")
                modoJogo
                return()

entradaUser :: String -> IO String
entradaUser ent = do
    putStrLn (ent)
    getLine

singlePlayer :: IO ()
singlePlayer = do
    ent <- entrada("\nNome do Jogador:\n")
    escrita (ent,"pontuacao")
    
entrada :: String -> IO String
entrada ent = do
    putStrLn (ent)
    getLine

escrita :: (String,String) -> IO ()
escrita inth = do
    writeFile "ranking.txt" ("(" ++ fst inth ++ ", " ++ snd inth ++ ")")

leitura :: IO ()
leitura = do
    arq <- readFile "perguntas.txt"
    putStrLn (show $ splitOn "\r\n" (printaBonito (splitOn "--" arq)))

gerandoPerguntaAleatoria :: IO ()
gerandoPerguntaAleatoria = do
    num <- randomRIO (1,540::Int)
    if num `elem` [2,11..540]
        then do putStrLn (show $ num)
        else do gerandoPerguntaAleatoria

printaBonito :: [String] -> String
printaBonito lista
                    | (len == 1) = head lista
                    | otherwise = (printaBonito (splitOn "\r\n" (head lista))) ++ "\n" ++ printaBonito (tail lista)
                    where len = length lista