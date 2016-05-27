import Data.List
import System.Directory
import System.Environment
import System.FilePath
import Text.Regex.TDFA


getFullPath :: FilePath -> IO FilePath
getFullPath filepath = do
    cwd <- getCurrentDirectory
    return (cwd </> filepath)


indent :: Int -> String
indent depth
    | depth == 0 = "    "
    | otherwise = foldl dup "" [0..depth]
    where dup acc ele = acc ++ "    "


parseHeaders :: [String] -> [String]
parseHeaders lines = map extract (filter isInclude lines)
    where
        isInclude line = line =~ "#include <.*>" :: Bool
        extract header =
            case header =~ "#include <(.*)>" :: [[String]] of
                [[_, filename]] -> filename
                otherwise       -> header


getHeaders :: FilePath -> IO [FilePath]
getHeaders filepath = do
    exists <- doesFileExist filepath
    if exists then do
        contents <- readFile filepath
        return (parseHeaders (lines contents))
    else
        return []


htree :: Int -> FilePath -> IO ()
htree depth filepath = do
    headers <- getHeaders filepath
    case headers of
        [] -> return ()
        files -> mapM_ include files
        where
            include file = do
                putStrLn (indent depth ++ file)
                getFullPath file >>= htree (depth + 1)


main :: IO ()
main = do
    args <- getArgs
    case args of
        arg:_ -> putStrLn "Header include tree:" >> getFullPath arg >>= htree 0
        []    -> putStrLn "Must provide file name in current directory."
