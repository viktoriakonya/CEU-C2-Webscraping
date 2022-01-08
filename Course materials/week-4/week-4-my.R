

rm(list=ls())

# trimws()

# Error handling
get_onepage <- function(b) {
  
  tryCatch({
    2+'dfdf'
  }, error = function(e) {
    print(e)
    return(data.table())})
  
}

a <- get_onepage()
t <- sapply(1:10, get_onepage)



# 1. Get data from coingecko API ##################################################
# Endpoints are listed on the site
# Get a curl comment + response
# copy curl comment -> paste it to https://curlconverter.com/#r


# A. Get all criptos

# curl -X 'GET' \
# 'https://api.coingecko.com/api/v3/coins/list?include_platform=false' \
# -H 'accept: application/json'
#https://api.coingecko.com/api/v3/coins/list?include_platform=false

library(httr)
library(jsonlite)
library(tidyverse)

headers = c(
  `accept` = 'application/json'
)

params = list(
  `include_platform` = 'true'
)

res <- httr::GET(url = 'https://api.coingecko.com/api/v3/coins/list', httr::add_headers(.headers=headers), query = params)

# Get df (flatten: cbind dataframe )
df <- fromJSON(content(res, 'text'), flatten = T) 

# Same result
df2 <- fromJSOM('https://api.coingecko.com/api/v3/coins/list?include_platform=false')


# B. Get historical prices

headers = c(
  `accept` = 'application/json'
)

params = list(
  `date` = '30-12-2017'
)

res <- httr::GET(url = 'https://api.coingecko.com/api/v3/coins/ethereum/history', httr::add_headers(.headers=headers), query = params)
df <- fromJSON(content(res, 'text'), flatten = T) 
df$localization

# C. Get the time series of one crypto


url <- 'https://api.coingecko.com/api/v3/coins/ethereum/ohlc?vs_currency=usd&days=90'
df <- fromJSON('https://api.coingecko.com/api/v3/coins/ethereum/ohlc?vs_currency=usd&days=90')

headers = c(
  `accept` = 'application/json'
)

params = list(
  `vs_currency` = 'usd',
  `days` = '90'
)

res <- httr::GET(url = 'https://api.coingecko.com/api/v3/coins/ethereum/ohlc', httr::add_headers(.headers=headers), query = params)

df <- data.frame(fromJSON(content(res, 'text')) )

colnames(df) <- c("Date", 
                  "O", 
                  "H",  
                  "L", 
                  "C")

df$Date <- as.POSIXct(df$Date/1000, origin="1970-01-01")

ggplot(df) +
  aes(x = Date, y = O) +
  geom_line(size = 0.5, colour = "#112446") +
  theme_bw()



# 2. Tradingview
# get api from scan in inspect (record scrolling)

require(httr)
library(data.table)

headers = c(
  `authority` = 'scanner.tradingview.com',
  `sec-ch-ua` = '" Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"',
  `accept` = 'text/plain, */*; q=0.01',
  `content-type` = 'application/x-www-form-urlencoded; charset=UTF-8',
  `sec-ch-ua-mobile` = '?0',
  `user-agent` = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36',
  `sec-ch-ua-platform` = '"Windows"',
  `origin` = 'https://www.tradingview.com',
  `sec-fetch-site` = 'same-site',
  `sec-fetch-mode` = 'cors',
  `sec-fetch-dest` = 'empty',
  `referer` = 'https://www.tradingview.com/',
  `accept-language` = 'en-US,en;q=0.9',
  `cookie` = '_sp_ses.cf1a=*; _ga=GA1.2.1005188261.1637602718; _gid=GA1.2.1186873766.1637602718; _sp_id.cf1a=4932abbf-d76a-4e3b-ae20-5789f6d17ebd.1637602712.1.1637602827.1637602712.4789f466-1240-4331-b196-15ef5f8a2b4a'
)

data = '{"filter":[{"left":"market_cap_basic","operation":"nempty"},{"left":"type","operation":"in_range","right":["stock","dr","fund"]},{"left":"subtype","operation":"in_range","right":["common","foreign-issuer","","etf","etf,odd","etf,otc","etf,cfd"]},{"left":"exchange","operation":"in_range","right":["AMEX","NASDAQ","NYSE"]},{"left":"is_primary","operation":"equal","right":true}],"options":{"lang":"en"},"markets":["america"],"symbols":{"query":{"types":[]},"tickers":[]},"columns":["logoid","name","close","change","change_abs","Recommend.All","volume","Value.Traded","market_cap_basic","price_earnings_ttm","earnings_per_share_basic_ttm","number_of_employees","sector","description","type","subtype","update_mode","pricescale","minmov","fractional","minmove2","currency","fundamental_currency_code"],"sort":{"sortBy":"market_cap_basic","sortOrder":"desc"},"range":[0,600]}'

res <- httr::POST(url = 'https://scanner.tradingview.com/america/scan', httr::add_headers(.headers=headers), body = data)

t <- fromJSON(content(res, 'text'))
t_col <- fromJSON(data)
t_col$columns

x <- t$data$d

df2 <- rbindlist(
lapply (t$data$d, function(x){
  data.frame(t(data.frame(x)), stringsAsFactors = T)
}))

name <- function(variables) {
  
}

names(df2) <- t_col$columns




# 3. Write function (trd), with JSON input, return DF
# Markets -> Stocks -> Top gainers


trd <- function(json) {

  
  
  
  require(httr)
  
  headers = c(
    `authority` = 'scanner.tradingview.com',
    `sec-ch-ua` = '" Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"',
    `accept` = 'text/plain, */*; q=0.01',
    `content-type` = 'application/x-www-form-urlencoded; charset=UTF-8',
    `sec-ch-ua-mobile` = '?0',
    `user-agent` = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36',
    `sec-ch-ua-platform` = '"Windows"',
    `origin` = 'https://www.tradingview.com',
    `sec-fetch-site` = 'same-site',
    `sec-fetch-mode` = 'cors',
    `sec-fetch-dest` = 'empty',
    `referer` = 'https://www.tradingview.com/',
    `accept-language` = 'en-US,en;q=0.9',
    `cookie` = '_sp_ses.cf1a=*; _ga=GA1.2.1005188261.1637602718; _gid=GA1.2.1186873766.1637602718; _gat_gtag_UA_24278967_1=1; _sp_id.cf1a=4932abbf-d76a-4e3b-ae20-5789f6d17ebd.1637602712.1.1637604339.1637602712.4789f466-1240-4331-b196-15ef5f8a2b4a'
  )
  
  data = '{"filter":[{"left":"change","operation":"nempty"},{"left":"exchange","operation":"in_range","right":["AMEX","NASDAQ","NYSE"]},{"left":"change","operation":"greater","right":0},{"left":"close","operation":"in_range","right":[2,10000]},{"left":"subtype","operation":"nequal","right":"preferred"}],"options":{"lang":"en","active_symbols_only":true},"markets":["america"],"symbols":{"query":{"types":[]},"tickers":[]},"columns":["logoid","name","close","change","change_abs","Recommend.All","volume","Value.Traded","market_cap_basic","price_earnings_ttm","earnings_per_share_basic_ttm","number_of_employees","sector","description","type","subtype","update_mode","pricescale","minmov","fractional","minmove2","currency","fundamental_currency_code"],"sort":{"sortBy":"change","sortOrder":"desc"},"range":[0,100]}'
  
  res <- httr::POST(url = 'https://scanner.tradingview.com/america/scan', httr::add_headers(.headers=headers), body = data)
  
  
  
}



# EU funding
# Inspect -> find2


require(httr)

headers = c(
  `Connection` = 'keep-alive',
  `sec-ch-ua` = '" Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"',
  `Accept` = 'application/json, text/plain, */*',
  `Content-Type` = 'application/x-www-form-urlencoded',
  `sec-ch-ua-mobile` = '?0',
  `User-Agent` = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36',
  `sec-ch-ua-platform` = '"Windows"',
  `Origin` = 'https://www.palyazat.gov.hu',
  `Sec-Fetch-Site` = 'same-site',
  `Sec-Fetch-Mode` = 'cors',
  `Sec-Fetch-Dest` = 'empty',
  `Referer` = 'https://www.palyazat.gov.hu/',
  `Accept-Language` = 'en-US,en;q=0.9'
)

data = list(
  `filter` = '{"where":{"fejlesztesi_program_nev":"Sz\xE9chenyi terv plusz"},"skip":"0","limit":10,"order":"konstrukcio_kod, palyazo_neve ASC"}'
)

res <- httr::POST(url = 'https://ginapp-api.fair.gov.hu/api/tamogatott_proj_kereso/find2', httr::add_headers(.headers=headers), body = data)

t <- fromJSON(content(res, 'text'))




# HW
# work with JSon, plots