
# Import libraries
library(xml2) # read and write out html
library(rvest)
library(data.table)


# Page 1 ###############################################x

# Topic
rovat <- "gazdasag"
rovat <- "deviza"

# Get link
t <- read_html(paste0("https://www.portfolio.hu/",rovat,"?page=1")) 

# Titles
titles_articles <- t %>% html_nodes('.category-articles') %>% html_nodes('.art') %>% html_nodes('a') %>% html_text() 
titles_articles

# Subitles
subtitles_articles <- t %>% html_nodes('.category-articles') %>% html_nodes('.art') %>% html_nodes('p') %>% html_text() 
subtitles_artlicles

# Links
links_articles <- t %>% html_nodes('.category-articles') %>% html_nodes('.art') %>% html_nodes('a') %>%  html_attr('href')
links_articles
links_articles <- links_articles[grepl( paste0("https://www.portfolio.hu/",rovat,"/"), links_articles)]

df_articles <- data.frame('titles' = titles_articles, 'subtitles' = subtitles_articles, 'links' = links_articles)


# Titles2
titles_header <- t %>% html_nodes('.category-articles') %>%  html_nodes('.overlay')  %>% html_nodes('a') %>%  html_text() 
titles_header <- titles_header[seq(2, length(titles_header), by = 2)]
titles_header

# Links2
links_header <- t %>% html_nodes('.category-articles') %>%  html_nodes('.overlay')  %>% html_nodes('a') %>% html_attr('href')
links_header <- links_header[seq(2, length(links_header), by = 2)]
links_header

df_header <- data.frame('titles' = titles_header, 'subtitles' = NA, 'links' = links_header)
df_header

df <- rbind(df_header, df_articles)
df

# Page 2 ###############################################x

# Get link
t <- read_html(paste0("https://www.portfolio.hu/",rovat,"?page=2")) 

# Tites
titles <- t %>% html_nodes('.article-lists') %>% html_nodes('h3') %>% html_text() 
titles

# Subtites
subtitles <- t %>% html_nodes('.article-lists') %>% html_nodes('p') %>% html_text() 
subtitles

# Link
links <- t %>% html_nodes('.article-lists') %>% html_nodes('a') %>%  html_attr('href')
links <- links[grepl( paste0("https://www.portfolio.hu/",rovat,"/"), links)]
links

df <- data.frame('titles' = titles, 'subtitles' = subtitles, 'links' = links)



# IF
# Topic
rovat <- "gazdasag"

main_url <- "https://www.portfolio.hu"
rovat <- "deviza"
page_num <- 1




get_one_page <- function(url) {
  
  # Concatenate url
  # url <- paste0(main_url, rovat, "?page=", as.character(page_num))
  

  # Different logic is needed for the first and the rest of the pages
  
  if (grepl( "page=1", url) == TRUE) {
    
    
    ### First page ###
    
    # Get link
    t <- read_html(url) 
    
    
    # A. Get data from articles 
    
    # Titles
    titles_articles <- t %>% html_nodes('.category-articles') %>% html_nodes('.art') %>% html_nodes('a') %>% html_text() 
    
    # Subitles
    subtitles_articles <- t %>% html_nodes('.category-articles') %>% html_nodes('.art') %>% html_nodes('p') %>% html_text() 
    
    # Links
    links_articles <- t %>% html_nodes('.category-articles') %>% html_nodes('.art') %>% html_nodes('a') %>%  html_attr('href')
    links_articles <- links_articles[grepl( paste0("https://www.portfolio.hu/" ,rovat,"/"), links_articles)]
    
    # Put articles part together
    df_articles <- data.frame('titles' = titles_articles, 'subtitles' = subtitles_articles, 'links' = links_articles)
    
    
    # B. Get data from header
    
    # Titles
    titles_header <- t %>% html_nodes('.category-articles') %>%  html_nodes('.overlay')  %>% html_nodes('a') %>%  html_text() 
    titles_header <- titles_header[seq(2, length(titles_header), by = 2)]
    
    # Links
    links_header <- t %>% html_nodes('.category-articles') %>%  html_nodes('.overlay')  %>% html_nodes('a') %>% html_attr('href')
    links_header <- links_header[seq(2, length(links_header), by = 2)]
    
    # Put header part together
    df_header <- data.frame('titles' = titles_header, 'subtitles' = NA, 'links' = links_header)
    
    
    # C. Append two parts
    df <- rbind(df_header, df_articles)
    
    return(df)
    
    
  }else{
    
    ### Rest of the pages ###
    
    # Get link
    t <- read_html(url) 
    
    # Tites
    titles <- t %>% html_nodes('.article-lists') %>% html_nodes('h3') %>% html_text() 
    
    # Subtites
    subtitles <- t %>% html_nodes('.article-lists') %>% html_nodes('p') %>% html_text() 
    
    # Link
    links <- t %>% html_nodes('.article-lists') %>% html_nodes('a') %>%  html_attr('href')
    links <- links[grepl( paste0("https://www.portfolio.hu/",rovat,"/"), links)]
    
    df <- data.frame('titles' = titles, 'subtitles' = subtitles, 'links' = links)
    return(df)
  
    
  } # end else
  
  
} # end func


# Scrape one page
main_url <- "https://www.portfolio.hu/"

rovat <- "gazdasag"
page_num <- 1
df1 <- get_one_page(paste0(main_url, rovat, "?page=", as.character(page_num)))
df1

page_num <- 2
df2 <- get_one_page(paste0(main_url, rovat, "?page=", as.character(page_num)))
df2

page_num <- 1
rovat <- "deviza"
df3 <- get_one_page(paste0(main_url, rovat, "?page=", as.character(page_num)))
df3

page_num <- 5
rovat <- "befektetes"
df4 <- get_one_page(paste0(main_url, rovat, "?page=", as.character(page_num)))
df4
# Works with the following rovats: 



# Multiple pages
rovat <- "gazdasag"
page_num <- 1

links <- paste0(paste0(main_url, rovat, "?page=", 1:5))

list_of_dfs <- lapply(links, get_one_page)

find_df <- rbindlist(list_of_dfs)
















