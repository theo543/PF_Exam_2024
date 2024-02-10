data Pereche a b = MyP a b deriving Show
data Lista a = MyL [a] deriving Show

class MyOp m where
    myFilter :: (a -> Bool) -> (b -> Bool) -> m (Pereche a b) -> m (Pereche a b)

instance MyOp Lista where
    myFilter fA fB list = MyL $ filter filterBoth (unLista list)
        where
            filterBoth (MyP a b) = fA a && fB b
            unLista :: Lista a -> [a]
            unLista (MyL l) = l

lp :: Lista (Pereche Int Char)
lp = MyL [MyP 97 'a', MyP 3 'b', MyP 100 'd']

lpRes :: Lista (Pereche Int Char)
lpRes = MyL [MyP 3 'b']

test :: Lista (Pereche Int Char)
test = myFilter (< 10) (< 'e') lp
