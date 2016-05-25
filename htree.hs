import Data.List
import System.Directory


tree :: Int -> FilePath -> IO ()
tree depth filepath = do
    contents <- getDirectoryContents filepath
    let items = filter (not . isPrefixOf ".") contents
    let fullPaths = map ((filepath ++ "/") ++) items
    let ls_rec acc ele = do 
        isFile <- doesFileExist ele
        if isFile then 
            acc >> putStrLn (show depth ++ ele)
        else 
            acc >> withCurrentDirectory ele (tree (depth + 1) ele)
    foldl ls_rec (return ()) fullPaths


main :: IO ()
main = do 
    getCurrentDirectory >>= tree 0
