import System.IO
import Data.Char
import System.Random
import Data.List.Split
import Data.List
import Control.Monad
import Control.DeepSeq
import Text.Read



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
instrucoes = "\n===== Instrucoes =====\nO PerguntUP eh um jogo de perguntas que pode ser jogado de duas maneiras:\n-> Singleplayer ou Multiplayer\nCada partida possui 12 perguntas, divididas em 4 areas de conhecimento:\n- Ciencias da Natureza\n- Linguagens\n- Ciencias Exatas\n- Ciencias Humanas\nVoce tera 15 segundos para responder cada pergunta (caso ultrapasse esse tempo, a pontuacao final sera penalizada)\nAlem disso, haverao dicas limitadas disponiveis:\n- Eliminar alternativas: elimina duas alternativas\n- Opiniao dos internautas: mostra a porcentagem de concordancia com cada alternativa\n- Pular pergunta: pula para a proxima pergunta\nA cada inicio de partida, voce tera 1 dica de cada\nAlem disso, o sistema conta com um ranking com as 10 melhores pontuacoes. Ele e exibido no inicio e no final de cada partida\n"

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
                exibeRanking
                return()  -- Fecha a funcao apos toda a recursividade
        "2" ->
            do
                multiPlayer
                exibeRanking
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







        












    
-- MATEMÁGICA
pontuacao :: Int -> Int -> Int
pontuacao acertos erros = do
    let pontos = ((div (acertos * 200) 12) - (div (erros * 20) 12))
    if (pontos < 0)
        then 0
        else ((div (acertos * 200) 12) - (div (erros * 20) 12))

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



-- MISTURAR
shuffles x = if length x < 2 then return x else do
    i <- System.Random.randomRIO (0, length(x)-1)
    r <- shuffles (take i x ++ drop (i+1) x)
    return (x!!i : r)



-- TUDO SOBRE SINGLEPLAYER MULTIPLAYER
-- Modo SinglePlayer
singlePlayer :: IO ()
singlePlayer = do
    ent <- entradaUser("\nNome do Jogador:")
    arq <- readFile "perguntasBckUp.txt"
    
    gerandoPerguntaAleatoria ent 12 arq

    when (length arq > 0) $
        writeFile "perguntas.txt" arq
    
    
    rnf "" `seq` (writeFile "dicas.txt" $ "")

    return ()


multiPlayer :: IO ()
multiPlayer = do
    putStr ("\n===== Jogador 1 =====\n")
    singlePlayer
    
    putStr ("\n===== Jogador 2 =====\n")
    singlePlayer

    rank <- readFile "ranking.txt"
    let rankSplit = splitOn "\r\n" rank
    let p1 = read (last (splitOn ":" (rankSplit !! (length rankSplit -3)))) :: Int
    let p2 = read (last (splitOn ":" (rankSplit !! (length rankSplit -2)))) :: Int

    putStrLn ("\n#### Resultado ####\n")

    if (p1 > p2)
        then do
            putStrLn ("\nJogador 1 venceu!\n")
        else if (p2 > p1)
            then do
                putStrLn ("\nJogador 2 venceu!\n")
            else do
                putStrLn ("\nEmpate!\n")














-- TUDO SOBRE CRIAR E PRINTAR PERGUNTAS       
gerandoPerguntaAleatoria :: String -> Int -> String -> IO ()
gerandoPerguntaAleatoria nome n arq
    | n == 0 = do 
        acertos <- contaAcertos
        erros <- contaErros
    
        putStr ("\nSua pontuacao final: ")
        putStrLn (show $ pontuacao acertos erros)    
    
        escrita (nome, (pontuacao acertos erros))

        return ()

    | otherwise = do
        let lista = splitOn "---" arq
        num <- randomRIO (0,47::Int)
        let pergunta = lista !! num
        
        if ((drop 11 ((splitOn "\n" (pergunta)) !! 7) == "-RESPc") || (drop 11 ((splitOn "\n" (pergunta)) !! 7) == "-RESPe"))
            then do
                gerandoPerguntaAleatoria nome n arq
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
                    arq <- openFile "perguntas.txt" ReadMode
                    content <- hGetContents arq
                    gerandoPerguntaAleatoria nome (n-1) content
                    hClose arq
                    return ()
        
        rnf arq `seq` (writeFile "perguntas.txt" $ arq)
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
    putStrLn ("p: Pedir ajuda\n")

    resp <- entradaUser("Resposta:")
    if (resp `elem` ["a","b","c","d","e","p"])
        then if (resp == resposta)
            then do
                putStrLn ("Resposta certa!")
                let newArq = ((intercalate "---" (take num lista)) ++ "---" ++ (intercalate "---" [perg ++ "-RESPc"]) ++ "---" ++ (intercalate "---" (drop (num+1) lista)))
                putStrLn ("\n=== Marcando pergunta como respondida...")
                rnf newArq `seq` (writeFile "perguntas.txt" $ newArq)
                
            else do
                case resp of
                    "p" ->
                        do
                            ajuda lista num
                    _ ->
                        do
                            putStrLn ("Resposta errada.")
                            let newArq = ((intercalate "---" (take num lista)) ++ "---" ++ (intercalate "---" [perg ++ "-RESPe"]) ++ "---" ++ (intercalate "---" (drop (num+1) lista)))
                            putStrLn ("\n=== Marcando pergunta como respondida...")
                            rnf newArq `seq` (writeFile "perguntas.txt" $ newArq)

                            
        else do
            putStrLn ("Resposta invalida!")
            printaPergunta lista num
            return ()

ajuda :: [String] -> Int -> IO ()
ajuda lista num = do

    arqDica <- openFile "dicas.txt" ReadMode
    content <- hGetContents arqDica
    let dicas = splitOn "---" content 
    
    if (last dicas == (show num) ++ "dica1") || (last dicas == (show num) ++ "dica2") || (last dicas == (show num) ++ "dica3")
        
        then do
            putStrLn ("\n#### Voce nao tem mais ajuda para essa pergunta ####\n")
            printaPergunta lista num
            return()
        else if length dicas == 4
            then do
                putStrLn ("\n#### Voce nao tem mais ajudas para o jogo ####\n")
                printaPergunta lista num
                return()
            else do
                ajuda <- entradaUser("\n(1) Eliminar alternativas\n(2) Opiniao dos internautas\n(3) Pular pergunta\n")
                case ajuda of
                    "1" ->
                        do
                            let newArq = content ++ "---" ++ (show num) ++ "dica1"
                            putStrLn ("\n=== Marcando ajuda 1 como usada...")
                            hClose arqDica
                            rnf newArq `seq` (writeFile "dicas.txt" $ newArq)
                            printaPergunta (dicaUm lista num) num
                            
                    "2" ->
                        do
                            let newArq = content ++ "---" ++ (show num) ++ "dica2"
                            putStrLn ("\n=== Marcando dica 2 como usada...")
                            hClose arqDica
                            rnf newArq `seq` (writeFile "dicas.txt" $ newArq)
                            dicaDois lista num
                            printaPergunta (lista) num
                            
                    "3" ->
                        do
                            let newArq = content ++ "---" ++ (show num) ++ "dica3"
                            putStrLn ("\n=== Marcando dica 3 como usada...")
                            hClose arqDica
                            rnf newArq `seq` (writeFile "dicas.txt" $ newArq)
                            putStrLn ("\n==== Pergunta pulada ====")
                            if num == 47
                                then do 
                                    printaPergunta lista (num-1)
                                else do
                                    printaPergunta lista (num + 1)        
    return ()

dicaUm :: [String] -> Int -> [String]
dicaUm lista num = do
    let comeco = take num lista
    let newElem = logicaDicaUm (lista !! num)
    let final = drop (num+1) lista 
    let result = comeco ++ [newElem] ++ final
    result
 
logicaDicaUm :: String -> String
logicaDicaUm perg = do
    let pergList = splitOn "\n" perg
        pergunta = (pergList !! 0)
        letraA = (pergList !! 1)
        letraB = (pergList !! 2)
        letraC = (pergList !! 3)
        letraD = (pergList !! 4)
        letraE = (pergList !! 5)
        tipo = (pergList !! 6)
        resposta = (pergList !! 7)
    if (last (resposta)) == 'a'
        then do 
            let newletraC = take 3 letraC
            let newletraE = take 3 letraE
            let newPerg = pergunta ++ "\n" ++ letraA ++ "\n" ++ letraB ++ "\n" ++ newletraC ++ "\n" ++ letraD ++ "\n" ++ newletraE ++ "\n" ++ tipo ++ "\n" ++ resposta
            newPerg
        else do
            if (last (resposta)) == 'b'
                then do
                    let newletraC = take 3 letraC
                    let newletraE = take 3 letraE
                    let newPerg = pergunta ++ "\n" ++ letraA ++ "\n" ++ letraB ++ "\n" ++ newletraC ++ "\n" ++ letraD ++ "\n" ++ newletraE ++ "\n" ++ tipo ++ "\n" ++ resposta
                    newPerg
                    else do
                        if (last (resposta)) == 'c'
                            then do
                                let newletraB = take 3 letraB
                                let newletraD = take 3 letraD
                                let newPerg = pergunta ++ "\n" ++ letraA ++ "\n" ++ newletraB ++ "\n" ++ letraC ++ "\n" ++ newletraD ++ "\n" ++ letraE ++ "\n" ++ tipo ++ "\n" ++ resposta
                                newPerg
                            else do 
                                if (last (resposta)) == 'd'
                                    then do
                                        let newletraA = take 3 letraA
                                        let newletraB = take 3 letraB
                                        let newPerg = pergunta ++ "\n" ++ newletraA ++ "\n" ++ newletraB ++ "\n" ++ letraC ++ "\n" ++ letraD ++ "\n" ++ letraE ++ "\n" ++ tipo ++ "\n" ++ resposta
                                        newPerg
                                    else do
                                        let newletraB = take 3 letraB
                                        let newletraD = take 3 letraD
                                        let newPerg = pergunta ++ "\n" ++ letraA ++ "\n" ++ newletraB ++ "\n" ++ letraC ++ "\n" ++ newletraD ++ "\n" ++ letraE ++ "\n" ++ tipo ++ "\n" ++ resposta
                                        newPerg
                
dicaDois :: [String] -> Int -> IO ()
dicaDois lista num = do
    let perg = lista !! num
        pergList = splitOn "\n" perg
        resposta = (pergList !! 7)
    porcentagens <- (randomList 5 [])
    let letras = ["a","b","c","d","e"]

    if (last (resposta)) == 'a'
        then do 
            let certa = head porcentagens
            resto <- shuffles (tail porcentagens)
            let final = [certa] ++ resto
            printaPorcentagem final 
        else if (last (resposta)) == 'b'
            then do
                let certa = head porcentagens
                resto <- shuffles (tail porcentagens)
                let final = [head resto] ++ [certa] ++ (tail resto)
                printaPorcentagem final
            else if (last (resposta)) == 'c'
                then do
                    let certa = head porcentagens
                    resto <- shuffles (tail porcentagens)
                    let final = (take 2 resto) ++ [certa] ++ (drop 2 resto)
                    printaPorcentagem final
                else if (last (resposta)) == 'd'
                    then do
                        let certa = head porcentagens
                        resto <- shuffles (tail porcentagens)
                        let final = (take 3 resto) ++ [certa] ++ (drop 3 resto)
                        printaPorcentagem final
                        
                    else do
                        let certa = head porcentagens
                        resto <- shuffles (tail porcentagens)
                        let final = resto ++ [certa]
                        printaPorcentagem final
                                    
printaPorcentagem :: [Int] -> IO ()
printaPorcentagem lista = do
    putStrLn ("Opiniao dos Internautas:")
    putStrLn ("A: " ++ (show (lista !! 0)) ++ "% dos internautas votaram nesta opcao") 
    putStrLn ("B: " ++ (show (lista !! 1)) ++ "% dos internautas votaram nesta opcao")
    putStrLn ("C: " ++ (show (lista !! 2)) ++ "% dos internautas votaram nesta opcao")
    putStrLn ("D: " ++ (show (lista !! 3)) ++ "% dos internautas votaram nesta opcao")
    putStrLn ("E: " ++ (show (lista !! 4)) ++ "% dos internautas votaram nesta opcao")













-- TUDO SOBRE EXIBICAO RANKING
exibeRanking :: IO ()
exibeRanking = do
    arq <- readFile "ranking.txt"
    let linha = splitOn "\r\n" arq
    if (length arq > 0)
        then do
            putStrLn ("\n====== RANKING ======")
            converterLista arq (length linha)
        else do
            putStrLn ("\n====== RANKING VAZIO ======")
            return ()
            
converterLista :: String -> Int -> IO ()
converterLista arq n = do
    let linha = splitOn "\r\n" arq
    let listaResult = []
    let lul = vamo linha (n-1) listaResult
    let resultado0 = map listToPair lul
    let resultado1 = map segundoInt resultado0
    let resultadoSort = sortOn snd resultado1
    let resultado2 = (map segundoString resultadoSort)
    let resultado3 = tupleToList resultado2
    let resultado4 = tail resultado3
    printaTudo (reverse resultado4) 1
       
    
printaTudo :: [[String]] -> Int -> IO ()
printaTudo resultado n
    | (n == 11) = return ()
    | otherwise = do
        putStr ((show n) ++ ". ")
        putStr $ show (head (head resultado)) -- User
        putStr (" - ")
        let pontos = drop 5 (last (head resultado))
        putStrLn $ show (pontos) -- Pontos
        if (length (tail resultado) /= 0)
            then do printaTudo (tail resultado) (n+1)
            else return ()
        

vamo :: [String] -> Int -> [String] -> [[String]]
vamo lista (-1) listaResult = []
vamo lista (n)listaResult = resultado : vamo lista (n-1) listaResult
    where 
        tupla = splitOn ":" (lista !! n)
        resultado = tupla ++ listaResult
    
segundoInt :: (String,String) -> (String, Maybe Int)
segundoInt (x,y) = (x, readMaybe y :: Maybe Int)

segundoString :: (String,Maybe Int) -> (String, String)
segundoString (x,y) = (x, (show y))

listToPair :: [String] -> (String,String)
listToPair [""] = ("","")
listToPair [x,y] = (x, y)

pairToList :: (String, String) -> [String]
pairToList (x,y) = [x,y]

tupleToList :: [(String, String)] -> [[String]]
tupleToList = map pairToList  


randomList :: Int -> [Int] -> IO ([Int])
randomList 0 lista = return []
randomList n lista = do
    if (n == 1)
        then do
            let valor = (100 - (sum lista))
            r  <- randomRIO (valor,valor)
            rs <- randomList (n-1) (r:lista)
            return (reverse (sort (r:rs)))
        else do
            if (n == 5)
                then do 
                    let valor = 100
                    r  <- randomRIO (0,valor)
                    rs <- randomList (n-1) (r:lista)
                    return (reverse (sort (r:rs)))
                else do 
                    let valor = (100 - (sum lista))
                    r  <- randomRIO (0,valor)
                    rs <- randomList (n-1) (r:lista)
                    return (reverse (sort (r:rs)))