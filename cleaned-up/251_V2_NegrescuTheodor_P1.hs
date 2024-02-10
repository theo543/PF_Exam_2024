import Data.Char (isLower, isDigit, digitToInt)

transformChar :: Char -> String
transformChar char
        | isDigit char = [char, char]
        | char `elem` "ADT" = ""
        | isLower char = "*"
        | otherwise = [char]

transform :: String -> String
transform str = foldr (++) "" $ map transformChar str

transform2 :: String -> String
transform2 = (>>= transformChar)

testStr :: String

testStr = "Ana,2"

testRes :: String
testRes = "**,22"

test :: Bool
test = and $ map (\f -> f testStr == testRes) [transform, transform2]
