library(rvest)
library(jsonlite)
library(xml2)
library(tidyverse)
library(httr)


data <- data.frame(university_name = character(), 
                  university_rank = character(), 
                  university_primary_key = integer(),
                  state = character(),
                  city = character(),
                  zip = integer (),
                  link = character())


base <- "https://www.usnews.com"

df <- fromJSON('https://www.usnews.com/best-colleges/api/search?_sort=rank&_sortDirection=asc&_page=1&schoolType=national-universities')
max_iter <- df$data$totalPages # number of pages

a <- fromJSON('https://www.usnews.com/best-colleges/api/search?_sort=rank&_sortDirection=asc&_page=1&schoolType=national-universities')

for (i in 1:max_iter) {
  
  df <- fromJSON(paste0('https://www.usnews.com/best-colleges/api/search?_sort=rank&_sortDirection=asc&_page=', i ,'&schoolType=national-universities'))
  
  # Get links
  links <- df$data$items$institution$linkedDisplayName
  links <- gsub("\"", "", sub(">.*", "", gsub("<strong><a class=\"black90\" href=", "", links, fixed=TRUE)))

  # Insert into dataframe
  data_i <- data.frame(cbind(
              university_name = df$data$items$institution$displayName,
              university_rank = df$data$items$ranking$displayRank,
              university_primary_key = df$data$items$institution$primaryKey,
              state = df$data$items$institution$state,
              city = df$data$items$institution$city,
              zip = df$data$items$institution$zip,
              link = paste0(base, links)
              ))
  
  # Append to main dataset
  data <- rbind(data, data_i)

}


get_one_page <- function(url, name) {
    
    # Get link
    t <- read_html(url) 
    
    # Save HTML to working directory
    write_html(t, paste0(name, '.html'))
  
} 

# Create Df
mapply(get_one_page, data$link , data$university_primary_key)




