import Data.List
import System.Directory
import System.FilePath


getHeaders :: FilePath -> IO (Maybe [FilePath])
getHeaders filepath = do
    exists <- doesFileExist filepath
    if exists then do
        contents <- readFile filepath
        return (Just (lines contents))
    else
        return Nothing


htree :: Int -> FilePath -> IO ()
htree depth filepath = do
    headers <- getHeaders filepath
    case headers of
        Nothing -> return ()
        Just files -> foldl include (return ()) files
        where
            include acc ele = do
                cwd <- getCurrentDirectory
                acc >> putStrLn (indent depth ++ ele)
                    >> htree (depth + 1) (cwd </> ele)


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
        let fullPath = filepath </> ele
        isFile <- doesFileExist fullPath
        if isFile then
            acc >> putStrLn (indent depth ++ ele)
        else
            acc >> putStrLn (indent depth ++ ele ++ "/")
            >> withCurrentDirectory fullPath (tree (depth + 1) fullPath)
    foldl ls_rec (return ()) items


main :: IO ()
main = do
    -- getCurrentDirectory >>= tree 0
    htree 0 "/Users/kevin/workspace/htree/src/file.a"
