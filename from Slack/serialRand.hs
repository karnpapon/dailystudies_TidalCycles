
import System.Random
import Data.Array.IO
import Control.Monad
import System.IO.Unsafe
import Control.Concurrent.MVar
 
let shuffle :: [a] -> IO [a]
    shuffle xs = do
      ar <- newArray n xs
      forM [1..n] $ \i -> do
        j <- randomRIO (i,n)
        vi <- readArray ar i
        vj <- readArray ar j
        writeArray ar j vi
        return vj
      where
        n = length xs
        newArray :: Int -> [a] -> IO (IOArray Int a)
        newArray n xs =  newListArray (1,n) xs
    serialRand :: Eq a => [a] -> IO (Pattern a)
    serialRand xs = do mv <- newMVar []
                       return $ sig (\t -> unsafePerformIO $ do xs <- takeMVar mv
                                                                xs' <- fill xs
                                                                putMVar mv (tail xs')
                                                                return $ head xs'
                                    )
      where fill [] = shuffle xs
            fill (x:[]) = do xs' <- shuffle xs
                             let xs'' | x == head xs' = x:((tail xs') ++ [head xs'])
                                      | otherwise = x:xs'
                             return xs''
            fill xs = return xs
