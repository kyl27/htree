import Data.List
import System.Directory
import System.FilePath


indent :: Int -> String
indent depth
    | depth == 0 = "    "
    | otherwise = foldl dup "" [0..depth]
    where dup acc ele = acc ++ "    "


tree :: Int -> FilePath -> IO ()
tree depth filepath = do
    contents <- getDirectoryContents filepath
    let items = filter (not . isPrefixOf ".") contents
    let ls_rec file = do
        let fullPath = filepath </> file
        isFile <- doesFileExist fullPath
        if isFile then do
            putStrLn (indent depth ++ file)
        else do
            putStrLn (indent depth ++ file ++ "/")
            withCurrentDirectory fullPath (tree (depth + 1) fullPath)
    mapM_ ls_rec items


main :: IO ()
main = do
    putStrLn "File tree:"
    getCurrentDirectory >>= tree 0
