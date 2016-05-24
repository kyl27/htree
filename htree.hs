import System.Directory

main :: IO ()
main = do 
    getCurrentDirectory >>= ls


ls :: FilePath -> IO ()
ls filepath = do
    -- print filepath
    contents <- getDirectoryContents filepath
    let items = filter (`notElem` [".", ".."]) contents
    let fullPaths = map ((filepath ++ "/") ++) items
    let ls_rec acc ele = do 
        print ele
        isFile <- doesFileExist ele
        if isFile then 
            acc 
        else 
            withCurrentDirectory ele (ls ele)
    foldl ls_rec (print "") fullPaths
