import System.Random
import Data.List.Split
import Data.Time.Clock

entradaUser :: String -> IO String
entradaUser ent = do
    putStrLn (ent)
    getLine

printaPergunta :: [String] -> Int -> IO ()
printaPergunta lista num = do
    let pergunta = drop 10 ((splitOn "\r\n" (lista !! num)) !! 0)
        letraA = ((splitOn "\r\n" (lista !! num)) !! 1)
        letraB = ((splitOn "\r\n" (lista !! num)) !! 2)
        letraC = ((splitOn "\r\n" (lista !! num)) !! 3)
        letraD = ((splitOn "\r\n" (lista !! num)) !! 4)
        letraE = ((splitOn "\r\n" (lista !! num)) !! 5)
        tipo = ((splitOn "\r\n" (lista !! num)) !! 6)
        resposta = drop 10 ((splitOn "\r\n" (lista !! num)) !! 7)
    
    putStrLn (show $ tipo)
    putStrLn (show $ pergunta)
    putStrLn (show $ letraA)
    putStrLn (show $ letraB)
    putStrLn (show $ letraC)
    putStrLn (show $ letraD)
    putStrLn (show $ letraE)
    putStrLn (show $ resposta)

gerandoPerguntaAleatoria :: IO ()
gerandoPerguntaAleatoria = do

    -- Tirar pergunta da Lista


    arq <- readFile "perguntas.txt"
    let lista = splitOn "---" arq
    num <- randomRIO (0,47::Int)
    
    let tempo = getCurrentTime

    printaPergunta lista num

    resp <- entradaUser("\nResposta:")
    if (resp `elem` ["a","b","c","d","e","1","2","3"])
        then
            if (resp == (drop 10 ((splitOn "\r\n" (lista !! num)) !! 7)))
                then do
                    putStrLn $ show ("Resposta certa!")
                    return ()
            else do
                case resp of
                    "1" ->
                        do
                            putStrLn $ show ("dica um")
                            return ()
                    "2" ->
                        do
                            putStrLn $ show ("dica dois")
                            return ()
                    "3" ->
                        do
                            putStrLn $ show ("dica tres")
                            return ()
                    _ ->
                        do
                            putStrLn $ show ("Resposta errada")
                            return ()
        else do putStrLn $ show ("Resposta invalida!")
    putStrLn ("Seu tempo foi:")
    putStrLn (tempo)