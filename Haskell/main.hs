import System.IO
import Data.Char
import System.Random
import Data.List.Split
import Data.List
import Control.Monad
import Control.DeepSeq



-- TUDO SOBRE CRIACAO E EXIBICAO DE MENU
-- Funcao principal do programa. Executa a parte logica atraves de chamadas de funcoes secundarias
main :: IO ()
main = do 
    ent <- entradaUser ("\n===== PerguntUP =====" ++ "\nby GERIGE" ++ "\n\n(1) Ver as instrucoes\n(2) Seguir para o jogo\n(3) Exibir o ranking\n(4) Sair\nEscolha:")
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
        "3" -> 
            do
                exibeRanking
                main -- Chama novamente o "main" apos a execucao
                return()  -- Fecha a funcao apos toda a recursividade
        "4" -> -- Sai do jogo
            return()  -- Fecha a funcao apos toda a recursividade
        _ -> -- Qualquer outra entradaUser que nao seja "1", "2" ou "3" sera ignorada e a funcao sera chamada novamente
            do
                putStrLn ("Opcao Invalida!")
                main -- Chamada do "main" para entradas invalidas
                return()  -- Fecha a funcao apos toda a recursividade

-- Funcao que só mostra as instrucoes do jogo                
instrucoes :: String
instrucoes = "\n===== Instrucoes =====\nO PerguntUP eh um jogo de perguntas que pode ser jogado de duas maneiras:\n-> Singleplayer ou Multiplayer\nCada partida possui 12 perguntas, divididas em 4 areas de conhecimento:\n- Ciencias da Natureza\n- Linguagens\n- Ciencias Exatas\n- Ciencias Humanas\nVoce tera 15 segundos para responder cada pergunta (caso ultrapasse esse tempo, a pontuacao final sera penalizada)\nAlehm disso, haverao dicas limitadas disponiveis:\n- Eliminar alternativas: elimina duas alternativas\n- Opiniao dos internautas: mostra a porcentagem de concordancia com cada alternativa\n- Pular pergunta: pula para a proxima pergunta\nA cada inicio de partida, voce tera 1 dica de cada\nPara obter mais dicas, voce devera responder a pergunta em menos de 5 segundos\nSe ja tiver sido usado alguma dica, ela sera reposta. Caso contrario, a dica recebida sera aleatoria\nAlem disso, o sistema conta com um ranking com as 10 melhores pontuacoes. Ele e exibido no inicio e no final de cada partida\n"

-- Funcao que cuida da criacao da partida atraves de chamadas de funcoes secundarias
criarPartida :: IO ()
criarPartida = do
    ent <- entradaUser ("\nDeseja iniciar uma nova partida?\n(1) Sim\n(2) Nao\nEscolha:")
    case ent of
        "1" -> -- Iniciar um nova partida chamando a funcao "modoJogo"
            do
                modoJogo
                criarPartida -- Chama novamente a funcao "criarPartida" caso o usuario deseje jogar novamente
                return()  -- Fecha a funcao apos toda a recursividade
        "2" -> -- Fecha o jogo e retorna para o "main"
            do
                putStrLn ("Ok! Até a próxima!")
                main -- Chama o "main" para que o programa reinicie
                return()  -- Fecha a funcao apos toda a recursividade
        _ ->
            do
                putStrLn ("Opcao Invalida!")
                criarPartida -- Chama a funcao 
                return()  -- Fecha a funcao apos toda a recursividade

-- Funcao que 
modoJogo :: IO ()
modoJogo = do
    ent <- entradaUser ("\nQual a forma de jogar?\n(1) SinglePlayer\n(2) MultiPlayer\nEscolha:")
    case ent of
        "1" ->
            do
                singlePlayer
                return()  -- Fecha a funcao apos toda a recursividade
        "2" ->
            do
                multiPlayer
                return()  -- Fecha a funcao apos toda a recursividade
        _ ->
            do
                putStrLn ("Opcao Invalida!")
                modoJogo
                return()  -- Fecha a funcao apos toda a recursividade










-- TUDO SOBRE ENTRADA E SAIDA DE DADOS E LEITURA DE ARQUIVOS
entradaUser :: String -> IO String
entradaUser ent = do
    putStrLn (ent)
    getLine

escrita :: (String,Int) -> IO ()
escrita inth = do
    arq <- readFile "ranking.txt"
    let newArq = arq ++ (fst inth ++ ":" ++ show (snd inth) ++ "\r\n")
    seq (length newArq) (writeFile "ranking.txt" newArq)


-- leArquivo :: String -> Handle
-- leArquivo nomeArquivo = do
--     handle <- openFile nomeArquivo ReadMode





        












    
-- MATEMÁGICA
pontuacao :: Int -> Int -> Int
pontuacao acertos erros = ((div (acertos * 70) 12) - (div (erros * 30) 12))
          
contaErros :: IO Int
contaErros = do
    arq <- readFile "perguntas.txt"
    let erros = length (splitOn "-RESPe" arq) - 1 
    return (erros)

contaAcertos :: IO Int
contaAcertos = do
    arq <- readFile "perguntas.txt"
    let acertos = length (splitOn "-RESPc" arq) - 1
    return (acertos)

-- porcentagens :: [Int] -> Int -> Int -> [Int]
-- porcentagens lista valorMax valAnterior
--     | ((length lista) == 4) = porcentagens ([valorMax - valAnterior] ++ lista) (valorMax - valAnterior) x
--     | ((length lista) < 5) = porcentagens ([x] ++ lista) (valorMax - valAnterior) x
--     | ((length lista) == 5) = lista
--     where x = randomRIO (0,(valorMax - valAnterior)::Int)    













-- TUDO SOBRE SINGLEPLAYER MULTIPLAYER
-- Modo SinglePlayer
singlePlayer :: IO ()
singlePlayer = do
    -- putStrLn ("Chegou aqui")
    ent <- entradaUser("\nNome do Jogador:")
    arq <- readFile "perguntas.txt"
    
    -- printPergunta12 ent 12
    putStrLn ("\n=== Selecionando a primeira pergunta...")
    gerandoPerguntaAleatoria 12 arq

    acertos <- contaAcertos
    erros <- contaErros
    
    putStr ("\nSua pontuacao final: ")
    putStrLn (show $ pontuacao acertos erros)    
    
    escrita (ent, (pontuacao acertos erros))

    writeFile "perguntas.txt" arq

    return ()


multiPlayer :: IO ()
multiPlayer = do
    putStr ("\n===== Jogador 1 =====\n")
    singlePlayer
    rank <- readFile "ranking.txt"
    let rankSplit = splitOn "\r\n" rank
    let p1 = read (last (splitOn ":" (rankSplit !! (length rankSplit -2)))) :: Int

    putStr ("\n===== Jogador 2 =====\n")
    singlePlayer
    rank <- readFile "ranking.txt"
    let rankSplit = splitOn "\r\n" rank
    let p2 = read (last (splitOn ":" (rankSplit !! (length rankSplit -2)))) :: Int

    if (p1 > p2)
        then do
            putStrLn ("\nJogador 1 venceu!\n")
        else if (p2 > p1)
            then do
                putStrLn ("\nJogador 2 venceu!\n")
            else do
                putStrLn ("\nEmpate!\n")














-- TUDO SOBRE CRIAR E PRINTAR PERGUNTAS
printPergunta12 :: Int -> IO ()
printPergunta12 n
    | n == 0 = return ()
    | otherwise = do
        arq <- readFile "perguntas.txt"
        gerandoPerguntaAleatoria n arq
        printPergunta12 (n-1)
        
gerandoPerguntaAleatoria :: Int -> String -> IO ()
gerandoPerguntaAleatoria n arq
    | n == 0 = return ()
    | otherwise = do
        let lista = splitOn "---" arq
        num <- randomRIO (0,47::Int)
        let pergunta = lista !! num
        
        if ((drop 11 ((splitOn "\n" (pergunta)) !! 7) == "-RESPc") || (drop 11 ((splitOn "\n" (pergunta)) !! 7) == "-RESPe"))
            then do
                putStrLn ("\n=== Pergunta repetida. Selecionando nova pergunta...")
                gerandoPerguntaAleatoria n arq
                return ()
            else
                do
                    putStrLn ("\n==== Placar ====")
                    erros <- contaErros
                    acertos <- contaAcertos
                    putStr ("Erros:")
                    putStrLn (show $ erros)
                    putStr ("Acertos:")
                    putStrLn (show $ acertos)
                    printaPergunta lista num
        arq <- readFile "perguntas.txt"
        putStrLn ("\n=== Selecionando nova pergunta...")
        gerandoPerguntaAleatoria (n-1) arq
        return ()

              
printaPergunta :: [String] -> Int -> IO ()
printaPergunta lista num = do
    let perg = lista !! num
    let pergunta = drop 10 ((splitOn "\n" (perg)) !! 0)
        letraA = ((splitOn "\n" (perg)) !! 1)
        letraB = ((splitOn "\n" (perg)) !! 2)
        letraC = ((splitOn "\n" (perg)) !! 3)
        letraD = ((splitOn "\n" (perg)) !! 4)
        letraE = ((splitOn "\n" (perg)) !! 5)
        tipo = "\n" ++ ((splitOn "\n" (perg)) !! 6)
        resposta = drop 10 ((splitOn "\n" (perg)) !! 7)
    
    putStrLn (tipo)
    putStrLn (pergunta)
    putStrLn (letraA)
    putStrLn (letraB)
    putStrLn (letraC)
    putStrLn (letraD)
    putStrLn (letraE)
    putStrLn ("p: Pedir dica\n")

    resp <- entradaUser("Resposta:")
    if (resp `elem` ["a","b","c","d","e","p"])
        then if (resp == resposta)
            then do
                putStrLn ("Resposta certa!")
                let newArq = ((intercalate "---" (take num lista)) ++ "---" ++ (intercalate "---" [perg ++ "-RESPc"]) ++ "---" ++ (intercalate "---" (drop (num+1) lista)))
                putStrLn ("\n=== Marcando pergunta como respondida...")
                when (length newArq > 0) $
                    writeFile "perguntas.txt" newArq
                
            else do
                case resp of
                    "p" ->
                        do
                            ajuda lista num
                            return ()
                    _ ->
                        do
                            putStrLn ("Resposta errada.")
                            let newArq = ((intercalate "---" (take num lista)) ++ "---" ++ (intercalate "---" [perg ++ "-RESPe"]) ++ "---" ++ (intercalate "---" (drop (num+1) lista)))
                            putStrLn ("\n=== Marcando pergunta como respondida...")
                            when (length newArq > 0) $
                                writeFile "perguntas.txt" newArq
                            
        else do
            putStrLn ("Resposta invalida!")
            printaPergunta lista num
            return ()

ajuda :: [String] -> Int -> IO ()
ajuda lista num = do
    arq <- readFile "perguntas.txt"

    
    if (last lista == "dica1") || (last lista == "dica2") || (last lista == "dica3")
        
        then do
            putStrLn ("\nVoce nao tem mais dicas para essa pergunta\n")
            printaPergunta lista num
            return()
    else do
        ajuda <- entradaUser("\n(1) Eliminar alternativas\n(2) Opiniao dos internautas\n(3) Pular pergunta\n")
        case ajuda of
            "1" ->
                do
                    putStrLn ("\ndica um\n")
                    let newArq = arq ++ "\r\n---" ++ "dica1"
                    putStrLn ("\n=== Marcando dica 1 como usada...")
                    when (length newArq > 0) $
                        writeFile "perguntas.txt" newArq
                    printaPergunta (lista ++ ["dica1"]) num
                    return ()
            "2" ->
                do
                    putStrLn ("\ndica dois\n")
                    let newArq = arq ++ "\r\n---" ++ "dica2"
                    putStrLn ("\n=== Marcando dica 2 como usada...")
                    when (length newArq > 0) $
                        writeFile "perguntas.txt" newArq
                    printaPergunta (lista ++ ["dica2"]) num
                    return ()
            "3" ->
                do
                    putStrLn ("\ndica tres\n")
                    let newArq = arq ++ "\r\n---" ++ "dica3"
                    putStrLn ("\n=== Marcando dica 3 como usada...")
                    when (length newArq > 0) $
                        writeFile "perguntas.txt" newArq
                    printaPergunta (lista ++ ["dica3"]) num
                    return ()


 
 







-- TUDO SOBRE EXIBICAO RANKING
exibeRanking :: IO ()
exibeRanking = do
    arq <- readFile "ranking.txt"
    let linha = splitOn "\r\n" arq
    if (length arq > 0)
        then do
            putStrLn ("\n====== RANKING ======")
            converterLista arq (length linha)
        else
            return ()
            
converterLista :: String -> Int -> IO ()
converterLista arq n = do
    let linha = splitOn "\r\n" arq
    let listaResult = []
    let lul = vamo linha (n-1) listaResult
    let resultado0 = sortOn snd (map segundoInt (map listToPair lul)) -- [(),(),()]
    let resultado1 = (map segundoString resultado0)
    let resultado2 = tupleToList resultado1
    if (n > 10)
        then do printaTudo (reverse resultado2) 10
        else do printaTudo (reverse resultado2) n
       
    
printaTudo :: [[String]] -> Int -> IO ()
printaTudo resultado n 
    | (n == 0) = return ()
    | otherwise = do
        putStr $ ((show (abs(n-10)+1)) ++ ". ")
        putStr $ show (head (head resultado)) -- User
        putStr (" - ")
        putStrLn $ show (last (head resultado)) -- Pontos
        printaTudo (tail resultado) (n-1)
        

vamo :: [String] -> Int -> [String] -> [[String]]
vamo lista (-1) listaResult = []
vamo lista (n)listaResult = resultado : vamo lista (n-1) listaResult
    where 
        tupla = splitOn ":" (lista !! n)
        resultado = tupla ++ listaResult
    
segundoInt :: (String,String) -> (String, Int)
segundoInt (x,y) = (x, (read y :: Int))

segundoString :: (String,Int) -> (String, String)
segundoString (x,y) = (x, (show y))


listToPair :: [a] -> (a,a)
listToPair [x,y] = (x, y)

pairToList :: (a, a) -> [a]
pairToList (x,y) = [x,y]

tupleToList :: [(String, String)] -> [[String]]
tupleToList = map pairToList  