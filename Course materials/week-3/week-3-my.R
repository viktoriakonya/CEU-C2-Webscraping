

rm(list=ls())

# Libraries
library(rvest)
library(jsonlite)
library(data.table)
library(httr)

# Create JSON strin
s <- '{"first_json" : "hello_ceu", "year" : 2021, "Class" : "BA" }'

# Write it out as JSON
tl <- fromJSON(s)

# 
toJSON(s, auto_unbox = T)
toJSON(s, pretty = T, auto_unbox = T)


# IMDB #########################################################################

# Network tab ->  start recording / clear everything
# Response -> application/json
# Response -> application/ld + json

t <- read_html('https://www.imdb.com/title/tt1160419')
write.html(t, 't.html')


# get the json of it. 
json_data <- 
  fromJSON(
    t %>%
      html_nodes(xpath = "//script[@type='application/ld+json']")%>%
      html_text()
  )

json_2_data <- 
  fromJSON(
    t %>%
      html_nodes(xpath = "//script[@id='__NEXT_DATA__']")%>%
      html_text()
  )

json_data$review
View(json_data$actor)

toJSON(json_data, pretty = T, auto_unbox = T)

# xpath: different method to identify HTML nodes (alternative to CSS selector) -> only use when we want to have the JSON out of it
# we cannot scrape page where we need to log in first


# Json in html document payscale ###############################################

t <- read_html('https://www.payscale.com/research/US/Job=Product_Manager%2C_Software/Salary')

td  <- fromJSON(t %>%
                  html_nodes(xpath = "//script[@type='application/ld+json']")%>%
                  html_text()
)

td2  <- fromJSON(t %>%
                   html_nodes(xpath = "//script[@type='application/json']")%>%
                   html_text()
)

# write function that returns the link
View(td2$props$pageProps$pageData$byDimension$`Job by Location`$rows)



toJSON(td, pretty = T, auto_unbox = T)
toJSON(td2, pretty = T, auto_unbox = T)

# http://jsonviewer.stack.hu/


# GET and POST #################################################################
# Post request: change something (send message, update account)
# Get: gets / fetches data

# https://github.com/daroczig/CEU-R-mastering

# https://exchangerate.host/#/#our-services

# https://www.youtube.com/watch?v=UObINRj2EGY


url <- 'https://api.exchangerate.host/convert?from=USD&to=EUR' 
# can pass other parametes 
# Endpoint until ?
# add another parameter and
data <- fromJSON(url)
print(data)


t <- GET('https://api.exchangerate.host/convert', query=list(from="USD", to="EUR"))
# with endpint + pass query with list of parameters -> get response

t <- fromJSON(content(t, "text"))
# get the text out of response and save it as JSON

t <- GET('https://api.exchangerate.host/convert', query=list(from="USD", to="EUR"), verbose(info = T))
# verbose: print everything with get request


# Task exchange rate ###########################################################
# Write a function which will return exchange rates, inputs: start_date, end_date, base, to. Check Time-Series endpoint


url <-  'https://api.exchangerate.host/timeseries?start_date=2020-01-01&end_date=2020-01-04&base=USD'


get_api <- function(start_date, end_date, base) {
  
  t <- GET('https://api.exchangerate.host/timeseries', query=list(start_date=start_date, end_date=end_date, base=base))
  t <- fromJSON(content(t, "text"))
  
  t <- data.frame ( names = names(t$rates), values = as.numeric(unlist(t$rates)))
  
  return(t)
  
}

df <- get_api(start_date = '2020-01-01', end_date = '2020-01-04', base = 'HUF')



View(df$rates)

unlist(df$rates)

str(unlist(df$rates))

as.numeric(unlist(df$rates))

data.frame ( names = names(df$rates), values = as.numeric(unlist(df$rates)))


# NASDAQ #######################################################################
# API call -> Copy request
# Change offset


t <- fromJSON('https://api.nasdaq.com/api/screener/stocks?tableonly=true&limit=25&offset=150')
View(t$data$table$rows[1:5])


t <- fromJSON('https://api.nasdaq.com/api/screener/stocks?tableonly=false&limit=25&offset=150')


# HW
# Find api
# process list
# create df
# Call api many times with function


