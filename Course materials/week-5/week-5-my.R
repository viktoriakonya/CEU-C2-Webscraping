

rm(list=ls())

# Import libraries
require(httr)
library(jsonlite)
library(xml2)


################################################################################
# 1. FORBES DATA
################################################################################

# Link: https://www.forbes.com/lists/global2000/
# F12

# A: Get data with GET request 
t <- fromJSON('https://www.forbes.com/forbesapi/org/global2000/2021/position/true.json?limit=2000')

# GET request
t <- GET('https://www.forbes.com/forbesapi/org/global2000/2021/position/true.json?limit=2000')
t # response is 200 so it is fine

#
res <- read_html(content(t, 'text'))

# Read JSON with GET command -> it did not work
# fromJSON + URL -> works in web browser we expected it to work (in case of open API it works)
# fromJSON makes a get request and we will have the response

# B: Get it as Curl

headers = c(
  `authority` = 'www.forbes.com',
  `sec-ch-ua` = '" Not A;Brand";v="99", "Chromium";v="96", "Google Chrome";v="96"',
  `accept` = 'application/json, text/plain, */*',
  `sec-ch-ua-mobile` = '?0',
  `user-agent` = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/96.0.4664.45 Safari/537.36',
  `sec-ch-ua-platform` = '"Windows"',
  `sec-fetch-site` = 'same-origin',
  `sec-fetch-mode` = 'cors',
  `sec-fetch-dest` = 'empty',
  `referer` = 'https://www.forbes.com/lists/global2000/',
  `accept-language` = 'en-US,en;q=0.9',
  `cookie` = 'notice_behavior=expressed,eu; _ga=GA1.2.647253911.1637784701; notice_preferences=0:1a8b5228dd7ff0717196863a5d28ce6c; notice_gdpr_prefs=0:1a8b5228dd7ff0717196863a5d28ce6c; cmapi_gtm_bl=ga-ms-ua-ta-asp-bzi-sp-awct-cts-csm-img-flc-fls-mpm-mpr-m6d-tc-tdc; cmapi_cookie_privacy=permit 1 required; client_id=b952302a04680aa2ea0e1129aa212947653; global_ad_params=%7B%7D; gaWelcomPageTracked=true; __aaxsc=1; AMP_TOKEN=%24NOT_FOUND; _gid=GA1.2.938487257.1638290677; rbzid=wK46I8t6wbVHYVRj4V3ZuJE0f5cXuSqagwV8MZVGlfqEngLIFfR4u88IqhlQ/C7KTQzsOqOpZepb9PsB0So7IejrVzHMPO4eZoTcwekWumjb0K5UEARNkEf2p8hTaMcreL9OJDrGFuqby/YFmTyMA8qoLiqX41Dsb6U4yzU3EbcTi78Z4/0zRd1bRTYephkd+czvgPi/5/2zJ42MObszr+ueaqCljhezsHGMJ/qrw1Q2CUHxC9j/LbJ2m1JvWfLWf3kvwHLXXCjqiEN0LO8cOg==; rbzsessionid=26ea69f8a7752b315da0deec8dacd130; __qca=P0-2126407220-1638290676695; cX_P=kwmbyvamy1tw0pf1; __pat=-18000000; cX_S=kwmbz6f7xza0g66k; cX_G=cx%3A15rm6ylyprbp41zlacqxy0evqr%3A2iseoylxlamzq; _cb_ls=1; _cb=Chf9z_D2Rpj6C7E7Yb; _cb_svref=null; aasd=2%7C1638290671664; __pvi=%7B%22id%22%3A%22v-kwmbyvaprevm8sha%22%2C%22domain%22%3A%22.forbes.com%22%2C%22time%22%3A1638290745725%7D; __adblocker=true; __pnahc=3; __tbc=%7Bjzx%7DIFcj-ZhxuNCMjI4-mDfH1PkB1_2wKvuMHNsTyVYoT2vIeSCKD7kq5E8nZYApDgq0yFuJ8yUngKfez939v-bSV9xPZeYnwtDXGGxE92kmcbg; xbc=%7Bjzx%7DGDuaYaUyDCypIpC2jQa1G0Bgl95RZrNuI_EW3EMcf84_ssWvmmiX1yqhztQY5aQmPYYBgC_1TsIfmA2KA3sq5r6wlqmfOJafKBoTXiHhkJ0x4Mr3n2e1xJ9ay2vsrJpisaNReQC-pZG2ADl43GEsiv49Rwxsh2UQs-erzr3MO5OGQsVl1d19_ZsazGUKZ-EQpmA1a0X6b6x23l62sgPK743E5FZcaBOS0yiDLYAc3TE3fIMDHiZ6WD7UCILLCbK0IttMklig5v8-muJgGgx4x3oYRBmEAjqcW1d9aM3_2XkWyeZSi9Etup_RR8yfsmC4voAy3qZ-Dwk2JMJy8CUssbH0bH9XIb3gp6ik5bR16fgM6DKk0wvjrdvz6rN8N_MwFMstzLAQVieVmjGPVIyOV3DWKdLPK9dVPZzvw5JvSYoIkHBilvU2HKnSr-y0qCRJtFWER-BHJxVOHYxxzggmWp_TiMviuHW4Uzqcn8CKhe277mHl0B2QNfUVIu5H28u58rtDhrv0wcPXxpYux86Jh3f2DQ9gtr35Zds3yYongHaCtUsvc_x2stIZlbNxdbMflK3aoglMcTzN7WRPmt5g4WYyyO1P3ZvTaAix5TIE4fJNovRQ_m1QJIVJ6g__knHqxToxY_Ig5tUGln_1GQmr6-OVGzPZAE5qFgZhARcSWYzCAia9vdrF2ol9XJzHJh1VGvHnNUzZ-_1WZX0XDis3EEBSvQgBNBeSQdnL50WVr_nWHT29vapiB6J7M2c_TU8uchhPV4G1JTLShx8fcu0bolv8L3NtOpVYgAzRQsvPImn0HY9o3UxkOD7fIEPa1SSVmsxVdDy4_40Vr6xa1LKSMkwRkBpd7eG1Rqgk1hxRYeu4HS31M1mmo_mbLch8G4XA; _chartbeat2=.1638290692552.1638290749589.1.Dufh5TJ6D1nNK4DiBNAWjYkr7_.2; QSI_HistorySession=https%3A%2F%2Fwww.forbes.com%2Flists%2Fglobal2000%2F%234a0b9e1f5ac0~1638290692874%7Chttps%3A%2F%2Fwww.forbes.com%2Flists%2Fglobal2000%2F%231b2ca6d45ac0~1638290756539; __gads=ID=152dce9f02f6f636:T=1638290893:S=ALNI_MbMbaUNYP-fbkZoa7Sb20nEyTLrxg; _gat_UA-5883199-3=1; _chartbeat4=t=alfmWBWmfJpBhcT56BT9IsnBnGcue&E=29&x=0&c=4.34&y=10490&w=880; mnet_session_depth=3%7C1638290668312'
)

params = list(
  `limit` = '2000'
)

res <- httr::GET(url = 'https://www.forbes.com/forbesapi/org/global2000/2021/position/true.json', httr::add_headers(.headers=headers), query = params)

forbes <- fromJSON(content(res, 'text'))


# Curl: send a lot of additional information with your request -> we got the response
# Extract text out of it, Again used fromJSON


################################################################################
# 2. BIllionares list
################################################################################

library(rvest)

# Link: https://stats.areppim.com/listes/list_billionairesx02xwor.htm


t <- read_html('https://stats.areppim.com/listes/list_billionairesx02xwor.htm')
tr <- t %>% html_table()
View(tr[[1]])


################################################################################
# 3. Skyscanner
################################################################################

# Link: https://skyscanner.github.io/slate/#api-documentation


# tripdays <- 1:15
# origins <- list(list('c'= 'HU', 'a' = "BUD"), list('c'='MT', 'a'= 'MLA'), list('c'='ES', 'a'='BCN'), list('c'='UK', 'a'='STN'), list('c'='UK', 'a'= 'STN'))
# currency <- 'EUR'

from <- Sys.Date()+20
to <- Sys.Date()+30
origin_country <- 'HU'
currency <- 'HUF'
origin_city_id <- 'BUD'
api_key <- 'ah395258861593902161819075536914'

sky_url<-paste0("https://partners.api.skyscanner.net/apiservices/browsequotes/v1.0/",origin_country,"/",currency,"/en-US/",origin_city_id,"-sky/Anywhere/",from,"/",to,"?apiKey=",api_key)
df <- fromJSON(sky_url, flatten = T)

# 4 dataframes
head(df$Quotes)
df$Carriers

# Replace carrier ids with names

library(data.table)

dt <- df$Quotes
dt$OutboundLeg.CarrierIds <- unlist(dt$OutboundLeg.CarrierIds)

dt$OutboundLeg.CarrierIds


get_carrier_name <- function(x, carrier_df) {
  carrier_df[CarrierId == x ]$Name
  
}

get_carrier_name(x, data.table(df$Carriers))


dt$OutboundLeg.CarrierIds <- sapply(dt$OutboundLeg.CarrierIds, get_carrier_name, data.table(df$Carriers))
# running variable, function, everyting else that we pass in order

################################################################################
# 4. Coctail - public open API
################################################################################

# Link: https://www.thecocktaildb.com/api.php

# Find all drinks which has vodka

df <- fromJSON('https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=Vodka')
df <- df$drinks


id = 15346


get_ing <- function(id) {

  ingredient <- fromJSON(paste0('https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=', id))
  t <- ingredient$drinks
  
  ing <- as.character(t[, which(startsWith(names(t), 'strIngredient'))])
  return(ing[ing != 'NA' & ing !='' ])

}

tl <- sapply(df$idDrink[1:5], get_ing)
ing <- as.character(unlist(tl))
t <- data.frame(table(ing))
t[order(-N)]

tl <- lapply(df$idDrink[1:5], get_ing)














