
# Libraries
library(xml2) # read and write out html
library(rvest)
library(data.table)



# Functions  -------------------------------------------------------------------
welcome <- function(name="Viki", a, c) {
  return(paste("Welcome ", name, "!"))
}

welcome('CEU')
welcome()

# Task 1: Create a function called multi which will take argument a and b and return with the a * b - b
a <- 5
b <- 7
multi <- function(a, b) {
  return( a * b - b)
}

multi(2,3)


# Task 2: Create a function named bmi_calc which will  -------------------------
# have two inputs weight(kg) and height(cm) and calculate the BMI index weight/height(meter)^2.

bmi_calc <- function(weight, height) {
  return(weight/height^2)
}

bmi_calc(50,150)


# Modified version -------------------------------------------------------------

bmi_calc2 <- function(weight, height) {
  if(is.numeric(weight) &is.numeric(height)){
    return(weight/height^2)
  } else{ 
    return('Not numeric!')
  }  
}

bmi_calc2(50,150)
bmi_calc2('a',150)
bmi_calc2(50) # with one argument and no default value the function will give error


bmi_calc3 <- function(weight, height) {
  if(is.numeric(weight) &is.numeric(height)){
    return(weight/height^2)
  } 
  stop('Error#1: Not a number')
}
bmi_calc3('a',150)


# For loops -------------------------------------------------------------------------------------------------

for (i in 1:10) {
  print(i)
}

# Task 3: Reproduce the following printing with a for loop. (Use builtin vector called letters)
letters

for (i in 1:length(letters)) {
  print(paste0("The ",i,". letter is ", letters[i]))
}


# While loop -------------------------------------------------------------------------------------------------

j <- 1
while (j < 10) {
  print("hello")
  j = j + 1
}


while (j < 10) {
  print("hello")
  j = j+1
  if(j ==5) {
    return("Done")
  }
}


while (j < 10) {
  print("hello")
  j = j+1
  if(j ==5) {
    break()
  }
}

# Iterate links -----------------------------------------------------------------------------------------------

j <-1
while (j<10) {
  t_url <- paste0('https://baseurl.com/page', j)
  print(t_url)
  j <- j+1
}

# Sapply, Lapply ---------------------------------------------------------------

my_square <- function(x) {
  return(x^2)
}

my_square(2)

t <- sapply(1:10, my_square) # takes every element from list, does the calculation for each element (passes rlrmrnts to function one-by-one), returns a vector
t
t[5]

t2 <- lapply(1:10, my_square) # returns a list
t2
unlist(t2) # get back the same result
t2[[5]]

lapply(1:10, function(x){
  return(x^3)
}) # anonymus function


# Elements ---------------------------------------------------------------------
# with class (element between div) -> use .
# with id (element between div, unique) -> use #
# tags (p, h1, h2, a) -> dont have to use anything



# Read HTML from local ---------------------------------------------------------

# Read in HTML
t <- read_html('index.html') # part of xml package

# Write out HTML
write_html(t, 't.html')

# get class
t %>% 
  html_nodes('.demo-class') %>%  # html_node return only first element, found xml node
  html_text() # returns all text in one text

# get tags
t %>% 
  html_nodes('p') # p is only once in the html

t %>% 
  html_nodes('h1') # returns a vector

# get id
t %>% 
  html_nodes('#select-with-id') # get tag


# Read HTML from online --------------------------------------------------------


t <- read_html('https://www.boats.com/boats/grady-white/canyon-376-7987260/')
write_html(t, 't.html') # check if data is downloaded

t <- read_html('https://www.boats.com/boats/prestige/420-8040261/')
t %>% html_nodes('#specifications .oem-page__title') %>% html_text()




# Get data from Economist ------------------------------------------------------

t <- read_html("https://www.economist.com/leaders") # text is not coming up, data is coming later with the JSON

# Shows a lot of thing that do not show up -> it is saved to disc -> Search in text
write_html(t, 't.html') 

# SelectorGadget -> select element in Chrome that you want -> add to pipeline
# it is a class -> we used .
t_titles <- t %>% 
    html_nodes('.headline-link span') %>% # every element is divided by the link
    html_text()

# Title
titles <- t_titles[seq(2, length(t_titles), by = 2)] # select every second element
titles

# Tags
tags <- t_titles[seq(1, length(t_titles), by = 2)]
tags

# Get links
rel_link <- t %>% html_nodes('.headline-link') %>% html_attr('href')
rel_link

links<- paste0("https://www.economist.com/leaders", rel_link)
links

# Teaser
teaser <- t %>% html_nodes('.teaser__text')%>% html_text()
teaser

df <- data.frame('titles' = titles, 'tags' = tags, 'teaser' = teaser)
df



# Put everything into function -------------------------------------------------
get_one_page <- function(t_url) {
  
  t <- read_html(t_url)

  # write_html(t, 't.html')
  
  t_titles <- t %>% 
    html_nodes('.headline-link span') %>% 
    html_text()
  
  titles <- t_titles[seq(2, length(t_titles), by = 2)] 

  tags <- t_titles[seq(1, length(t_titles), by = 2)]
  
  rel_link <- t %>% html_nodes('.headline-link') %>% html_attr('href')
  
  links<- paste0("https://www.economist.com/leaders", rel_link)
  
  teaser <- t %>% html_nodes('.teaser__text')%>% html_text()
  
  df <- data.frame('titles' = titles, 'tags' = tags, 'teaser' = teaser)
  
  return(df)

}

# One page
link <- "https://www.economist.com/leaders"
df <- get_one_page(link)

# Multiple pages
links <- paste0('https://www.economist.com/leaders?page=', 1:3)

list_of_dfs <- lapply(links, get_one_page)

find_df <- rbindlist(list_of_dfs)



# Scrape Yacht website ---------------------------------------------------------


t_url <- "https://www.yachtworld.co.uk/yacht/2021-ryck-280-8036770"
t <- read_html(t_url)

t_list <- list()
t_list[['link']] <- t_url
t_list[['length']] <- t %>% html_nodes('.boat-length') %>% html_text()
t_list[['price']] <- t %>% html_nodes('.payment-total') %>% html_text()
t_list[['location']] <- t %>% html_node('.location') %>% html_text() #get the first location with NODE

# Get elements from table
keys <- t %>% html_nodes('.datatable-title') %>% html_text()
values <- t %>% html_nodes('.datatable-value') %>% html_text()



for (i in 1:length(keys)) {
  t_list[[keys[i]]] <- values[i]
}

df <- data.frame(t_list)

#rbindlist() 


get_one_yacht <- function(t_url) {
  
  t <- read_html(t_url)
  
  t_list <- list()
  t_list[['link']] <- t_url
  t_list[['length']] <- t %>% html_nodes('.boat-length') %>% html_text()
  t_list[['price']] <- t %>% html_nodes('.payment-total') %>% html_text()
  t_list[['location']] <- t %>% html_node('.location') %>% html_text() #get the first location with NODE
  
  keys <- t %>% html_nodes('.datatable-title') %>% html_text()
  values <- t %>% html_nodes('.datatable-value') %>% html_text()
  
  for (i in 1:length(keys)) {
    t_list[[keys[i]]] <- values[i]
  }
  
  df <- data.frame(t_list)
  
  return(t_list)
  
}

df <- get_one_yacht('https://www.yachtworld.co.uk/yacht/2016-absolute-56-8004339/')


links <- c('https://www.yachtworld.co.uk/yacht/2016-absolute-56-8004339/',
           'https://www.yachtworld.co.uk/yacht/2009-maxi-dolphin-md65-adastra-8046953/',
           'https://www.yachtworld.co.uk/yacht/2013-fairline-targa-38-8057254/')

list_of_lists <- lapply(links, get_one_yacht)

df <- rbindlist(list_of_lists, fill = T) # manages with different length
df


# Find links of boats
t <- read_html('https://www.yachtworld.co.uk/boats-for-sale/?page=2')
all_link <- t %>% html_nodes('a') %>% html_attr('href')
all_link(starts_with(all_link, 'https://www.boatsgroup.com/'))


# Tesla ---------------------------------------------------------------------------------------------

t_url <- 'https://www.ultimatespecs.com/car-specs/Tesla/106267/Tesla-Model-S-70.html'
t <- read_html(t_url)


name <- t %>% html_nodes('.page_ficha_title_text') %>% html_text()

all_text <- t %>% html_nodes('.tabletd') %>% html_text()

keys <- all_text[seq(1, length(all_text), by = 2)] 
values <- all_text[seq(2, length(all_text), by = 2)] 

t_list <- list()

for (i in 1:length(keys)) {
  t_list[[keys[i]]] <- values[i]
}




