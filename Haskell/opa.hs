import System.IO
import Data.Char
import System.Random
import Data.List.Split
import Data.List
import Data.Ord
import Control.Monad
import Control.DeepSeq


-- Funcao que só mostra as instrucoes do jogo                
instrucoes :: String
instrucoes = "\n===== Instrucoes =====\nO PerguntUP eh um jogo de perguntas que pode ser jogado de duas maneiras:\n-> Singleplayer ou Multiplayer\nCada partida possui 12 perguntas, divididas em 4 areas de conhecimento:\n- Ciencias da Natureza\n- Linguagens\n- Ciencias Exatas\n- Ciencias Humanas\nVoce tera 15 segundos para responder cada pergunta (caso ultrapasse esse tempo, a pontuacao final sera penalizada)\nAlehm disso, haverao dicas limitadas disponiveis:\n- Eliminar alternativas: elimina duas alternativas\n- Opiniao dos internautas: mostra a porcentagem de concordancia com cada alternativa\n- Pular pergunta: pula para a proxima pergunta\nA cada inicio de partida, voce tera 1 dica de cada\nPara obter mais dicas, voce devera responder a pergunta em menos de 5 segundos\nSe ja tiver sido usado alguma dica, ela sera reposta. Caso contrario, a dica recebida sera aleatoria\nAlem disso, o sistema conta com um ranking com as 10 melhores pontuacoes. Ele e exibido no inicio e no final de cada partida\n"

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
                putStrLn ("Obrigado por jogar!")
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

entradaUser :: String -> IO String
entradaUser ent = do
    putStrLn (ent)
    getLine

-- Modo SinglePlayer
singlePlayer :: IO ()
singlePlayer = do
    ent <- entradaUser("\nNome do Jogador:")
    arq <- readFile "perguntas.txt"

    printPergunta12 arq ent 12

    acertos <- contaAcertos
    putStr ("\nSua pontuacao final: ")
    putStrLn (show $ acertos)

    
    let newArq = arq
    seq (length newArq) (return ())
    writeFile "outro.txt" "newArq"

    escrita (ent, pontuacaoAcertos acertos)






escrita :: (String,Int) -> IO ()
escrita inth = do
    arq <- readFile "ranking.txt"
    let newArq = arq ++ (fst inth ++ ":" ++ show (snd inth) ++ "\r\n")
    seq (length newArq) (writeFile "ranking.txt" newArq)

exibeRanking :: IO ()
exibeRanking = do
    arq <- readFile "ranking.txt"
    let linha = splitOn "\r\n" arq
    if (length arq > 0)
        then do
            putStrLn ("\n====== RANKING ======")
            if (length linha > 10)
                then do
                    converterLista arq 10
                else
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
    printaTudo (reverse resultado2) n   
    
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

pontuacaoAcertos :: Int -> Int
pontuacaoAcertos acertos = div (acertos * 50) 12

-- pontuacaoTempo :: Int -> Int
-- pontuacaoTempo tempoTotal = 50 - ((tempoTotal - 60) * (50/120))

-- pontuacaoFinal :: Int
-- pontuacaoFinal =
--     if (pontuacaoTempo tempoTotal > 50)
--         then
--             if (ceiling (pontuacaoAcertos acertos + 50) < 0)
--                 then
--                     0
--                 else
--                     ceiling (pontuacaoAcertos acertos + 50)
--         else
--             if (ceiling (pontuacaoAcertos acertos + pontuacaoTempo tempoTotal) < 0)
--                 then
--                     0
--                 else
--                     ceiling (pontuacaoAcertos acertos + pontuacaoTempo tempoTotal)
    

printPergunta12 :: String -> String -> Int -> IO ()
printPergunta12 arq nome n
    | n == 0 = return ()
    | otherwise = do
        gerandoPerguntaAleatoria arq nome
        printPergunta12 arq nome (n-1)
        


gerandoPerguntaAleatoria :: String -> String -> IO ()
gerandoPerguntaAleatoria arq nome = do

    -- Tirar pergunta da Lista

    let lista = splitOn "---" arq
    num <- randomRIO (0,47::Int) -- Excluir pergunta da lista
    let pergunta = lista !! num
    let miniLista = splitOn "\n" (pergunta) 
    
    
    if (((drop 11 (miniLista) !! 7) == "-RESPc") || ((drop 11 (miniLista) !! 7) == "-RESPe"))
        then do
            gerandoPerguntaAleatoria arq nome
        else
            do
                putStrLn ("\n==== Placar ====")
                erros <- contaErros
                acertos <- contaAcertos
                putStr ("Erros:")
                putStrLn (show $ erros)
                putStr ("Acertos:")
                putStrLn (show $ acertos)
                printaPergunta nome lista num

                
contaErros :: IO Int
contaErros = do
    arq <- readFile "outro.txt"
    let erros = length (splitOn "-RESPe" arq) - 1 
    return (erros)

contaAcertos :: IO Int
contaAcertos = do
    arq <- readFile "outro.txt"
    let acertos = length (splitOn "-RESPc" arq) - 1
    return (acertos)

                
printaPergunta :: String -> [String] -> Int -> IO ()
printaPergunta nome lista num = do
    let perg = lista !! num
    let pergunta = drop 10 ((splitOn "\r\n" (perg)) !! 0)
        letraA = ((splitOn "\r\n" (perg)) !! 1)
        letraB = ((splitOn "\r\n" (perg)) !! 2)
        letraC = ((splitOn "\r\n" (perg)) !! 3)
        letraD = ((splitOn "\r\n" (perg)) !! 4)
        letraE = ((splitOn "\r\n" (perg)) !! 5)
        tipo = "\n" ++ ((splitOn "\r\n" (perg)) !! 6)
        resposta = drop 10 ((splitOn "\r\n" (perg)) !! 7)
    
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
                seq (length newArq) (return ())
                writeFile "outro.txt" "newArq"
                -- when (length newArq > 0) $
                --     writeFile "perguntas.txt" newArq
                
            else do
                case resp of
                    "p" ->
                        do
                            ajuda nome lista num
                            return ()
                    _ ->
                        do
                            putStrLn ("Resposta errada.")
                            let newArq = ((intercalate "---" (take num lista)) ++ "---" ++ (intercalate "---" [perg ++ "-RESPe"]) ++ "---" ++ (intercalate "---" (drop (num+1) lista)))
                            -- seq (length newArq) (return ())
                            -- writeFile "perguntas.txt" newArq
                            -- when (length newArq > 0) $
                            --     writeFile "perguntas.txt" newArq
                            writeFile "outro.txt" "newArq"
                            
        else do
            putStrLn ("Resposta invalida!")
            printaPergunta nome lista num
            return ()

ajuda :: String -> [String] -> Int -> IO ()
ajuda nome lista num = do
    arq <- readFile "perguntas.txt"
    
    if (last lista == "dica1") || (last lista == "dica2") || (last lista == "dica3")
        
        then do
            putStrLn ("\nVoce nao tem mais dicas para essa pergunta\n")
            printaPergunta nome lista num
            return()
    else do
        ajuda <- entradaUser("\n(1) Dica 1\n(2) Dica 2\n(3) Pular pergunta\n")
        case ajuda of
            "1" ->
                do
                    putStrLn ("\ndica um\n")
                    let newArq = arq ++ "\r\n---" ++ "dica1"
                    when (length newArq > 0) $
                        writeFile "dica.txt" newArq
                    printaPergunta nome (lista ++ ["dica1"]) num
                    return ()
            "2" ->
                do
                    putStrLn ("\ndica dois\n")
                    let newArq = arq ++ "\r\n---" ++ "dica1"
                    when (length newArq > 0) $
                        writeFile "dica.txt" newArq
                    printaPergunta nome (lista ++ ["dica2"]) num
                    return ()
            "3" ->
                do
                    putStrLn ("\ndica tres\n")
                    let newArq = arq ++ "\r\n---" ++ "dica1"
                    when (length newArq > 0) $
                        writeFile "dica.txt" newArq
                    printaPergunta nome (lista ++ ["dica3"]) num
                    return ()