newtype AE a = AE {getAE :: (Either String a, String)} deriving Show

instance Functor AE where
    fmap f (AE (Right val, log)) = AE (Right (f val), log)
    fmap f (AE (Left err, log)) = AE (Left err, log)

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

testAE2 :: AE Int
testAE2 = divManyAE $ 1024 * 3

testAE3 :: AE Int
testAE3 = (* 100) <$> divAE 64

wrappedFn :: AE (Int -> Int)
wrappedFn = AE (Right (* 100), "multiply by 100")

modifiedFn :: AE (Int -> Int)
modifiedFn = wrappedFn >>= (\f -> AE (Right ((+ 1) . f), " after adding 1"))

testAE4 :: AE Int
testAE4 = modifiedFn <*> AE (Right 5, "5")
