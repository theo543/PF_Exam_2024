newtype AE a = AE {getAE :: (Either String a, String)} deriving Show

instance Functor AE where
    fmap f ma = f <$> ma

instance Applicative AE where
    pure = return
    mf <*> ma = do
        f <- mf
        f <$> ma

instance Monad AE where
    return a = AE (Right a, "")
    (>>=) (AE (Left err, log)) fn = AE (Left err, log)
    (>>=) (AE (Right val, log)) fn = AE (newVal, log ++ newLog)
        where
            (AE (newVal, newLog)) = fn val

testAE :: AE Int
testAE = ma >>= f
    where
        ma = AE (Right 7, "ana are mere ")
        f x = AE (if x `mod` 2 == 0 then Right x else Left "error", "si pere!")

divAE :: Int -> AE Int
divAE x | x `mod` 2 == 0 = AE (Right (x `div` 2), " div: " ++ show x)
        | otherwise = AE (Left "odd", " " ++ show x ++ " is ODD!")

divManyAE :: Int -> AE Int
divManyAE x = divAE x >>= divManyAE

testAE2 = divManyAE $ 1024 * 3
