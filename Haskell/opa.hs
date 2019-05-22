import System.IO
import Data.Char
import System.Random
import Data.List.Split
import Data.List
import Control.Monad


aleatorio :: [Int] -> IO ()
aleatorio nums = do
    num <- randomRIO (0,47::Int)
    if (num `elem` nums)
        then do
            aleatorio nums
            
        else do
            putStrLn $ show (num)
            return()