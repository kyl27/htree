import Data.List
import System.Directory

indent :: Int -> String
indent depth
    | depth == 0 = "    "
    | otherwise = foldl dup "" [0..depth]
    where dup acc ele = acc ++ "    "


tree :: Int -> FilePath -> IO ()
tree depth filepath = do
    contents <- getDirectoryContents filepath
    let items = filter (not . isPrefixOf ".") contents
    let ls_rec acc ele = do
        let fullPath = filepath ++ "/" ++ ele
        isFile <- doesFileExist fullPath
        if isFile then
            acc >> putStrLn (indent depth ++ ele)
        else
            acc >> putStrLn (indent depth ++ ele ++ "/")
            >> withCurrentDirectory fullPath (tree (depth + 1) fullPath)
    foldl ls_rec (return ()) items


main :: IO ()
main = do
    getCurrentDirectory >>= tree 0
