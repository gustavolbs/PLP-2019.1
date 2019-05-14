import GHC.Char
import System.Random
import System.IO
import Control.Monad
import Data.Char
import Data.List.Split

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

singlePlayer :: IO ()
singlePlayer = do
    ent <- entrada("\nNome do Jogador:\n")
    escrita (ent,"0")
    

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
    putStrLn (show (printaBonito (splitOn "--\r\n" arq)))

printaBonito :: [String] -> String
printaBonito lista
                    | (len == 1) = head lista
                    | otherwise = (printaBonito (splitOn "\r\n" (head lista))) ++ "\n" ++ printaBonito (tail lista)
                    where len = length lista