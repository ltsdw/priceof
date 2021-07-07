{-# LANGUAGE BangPatterns, OverloadedStrings, DeriveGeneric #-}

module Main (main) where

import qualified Data.ByteString.Lazy as B
import qualified Data.Sequence as S
import Network.HTTP.Client.Conduit  (defaultManagerSettings)
import Network.HTTP.Conduit         (responseBody, parseRequest, httpLbs, newManager, HttpException(..), Response)
import Data.Aeson                   (decode, FromJSON)
import Data.Text                    (Text)
import System.Environment           (getArgs)
import GHC.Generics                 (Generic)
import Text.Printf                  (printf)
import Control.Exception            (try)
import Control.Monad                (join)

data Props = Props {
    marketState :: !Text,
    currency :: !Text,
    exchange :: !Text,
    exchangeTimezoneName :: !Text,
    exchangeTimezoneShortName :: !Text,
    market :: !Text,
    regularMarketChange :: !Double,
    regularMarketChangePercent :: !Double,
    regularMarketTime :: !Int,
    regularMarketPrice :: !Double,
    regularMarketPreviousClose :: !Double,
    symbol :: !Text
    } deriving Generic

newtype Res = Res { result :: [Props] } deriving Generic

newtype IJSON = IJSON { quoteResponse :: Res } deriving Generic

instance FromJSON Props
instance FromJSON Res
instance FromJSON IJSON

main :: IO ()
main = getArgs >>= prittyPrint . getValues . createUrl

completeUrl :: [String] -> String
completeUrl = go []
    where
        go _    []       = []
        go !acc [x]      = acc ++ x
        go !acc (x:xs)   = go (acc ++ x ++ ",") xs

createUrl :: [String] -> String
createUrl = ((("https://query1.finance.yahoo.com/v7/finance/quote?lang=en-US&region=US&corsDomain=finance.yahoo.com&fields=" ++)
      (completeUrl fields) ++) "&symbols=" ++) . completeUrl
    where
        fields = ["symbol","marketState","regularMarketPrice","regularMarketChange",
                  "regularMarketChangePercent","preMarketPrice","preMarketChange",
                  "preMarketChangePercent","postMarketPrice","postMarketChange",
                  "postMarketChangePercent","currency"]

a = createUrl

zip5 :: [a] -> [b] -> [c] -> [d] -> [e] -> S.Seq (a,b,c,d,e)
zip5 = go S.Empty
    where
        go !acc (a:as) (b:bs) (c:cs) (d:ds) (e:es) = go (acc S.|> (a,b,c,d,e)) as bs cs ds es
        go !acc _ _ _ _ _ = acc

getValues :: String -> IO (Maybe IJSON)
getValues !url =
    go <$> (try $! join $ httpLbs <$> parseRequest url <*> newManager defaultManagerSettings
    :: IO (Either HttpException (Response B.ByteString)))
    where
        go (Right v) = decode $! responseBody v :: Maybe IJSON
        go _          = Nothing 

printAll :: S.Seq (Text, Double, Double, Double, Text) -> IO ()
printAll stcks = do
    pp'
    pp ("SYMBOL","C. PRICE","L. CLOSED","PERCENTAGE")
    pp'
    mapM_ aux stcks
    pp'
    where
        pp' = printf $ replicate 89 '-' ++ "\n"

        pp :: (Text, String, String, String) -> IO ()
        pp (a,b,c,d) = printf "%-6s %-14s %-6s %-14s %-6s %-14s %-6s %-14s %s\n" sep a sep b sep c sep d sep
            where
                sep :: String
                sep = "|"

        aux (sb,pr,cl,pc,cr) = pp (sb, pp'' pr cr, pp'' cl cr, pp'' pc "%")
            where
                pp'' :: Double -> Text -> String
                pp'' a b = printf "%.2f %s" a b

prittyPrint :: IO (Maybe IJSON) -> IO ()
prittyPrint = (go =<<)
    where
        go v = case v of
            Nothing      -> myerror
            (Just value) -> do
                let !symb   = fmap symbol                     $ result $ quoteResponse value :: [Text]
                    !price  = fmap regularMarketPrice         $ result $ quoteResponse value :: [Double]
                    !close  = fmap regularMarketPreviousClose $ result $ quoteResponse value :: [Double]
                    !perc   = fmap regularMarketChangePercent $ result $ quoteResponse value :: [Double]
                    !crrcy  = fmap currency                   $ result $ quoteResponse value :: [Text]
                    !stocks = zip5 symb price close perc crrcy
                case stocks of
                    S.Empty -> myerror
                    _       -> printAll stocks

myerror :: IO ()
myerror = putStrLn "Sorry, symbol(s) doesn't exist or an error occurred!"

