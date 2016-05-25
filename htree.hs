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
        isFile <- doesFileExist ele
        if isFile then
            acc >> print ele
        else
            acc >> withCurrentDirectory ele (ls ele)
    foldl ls_rec (return ()) fullPaths
