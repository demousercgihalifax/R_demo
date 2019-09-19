# Step1 Install Relavent package
# install.packages('rvest')
# install.packages('stringr')
# install.packages('mailR')
# install.packages('lubridate')


# Step 1.1: Loading the packages we need

library(rvest)
library(stringr)
library(mailR)
library(lubridate)


#Creating functio 
yahoo_fin <- function(script , country) {
  #Specifying the url for desired website 
  scriptname <-  toupper(script)
  #scriptname <- 'AAPL'
  country <- tolower(country)
  #country <- 'in'
  scriptname
  country
  page <- str_c('https://',str_trim(country),'.finance.yahoo.com/quote/',str_trim(scriptname))  
  page
  
  #Reading the html content from 
  page_html <- read_html(page)
  
  #scrape title of the product> I am keeping this ling to understand the transformations  
  title_html <- html_nodes(page_html, 'h1')
  #head(title_html)
  title <- html_text(title_html)
  # remove all space and new lines
  #title <- str_replace_all(title, '[\r\n]' ,' ')
  title <- str_trim(title)
  head(title)
  
  # scrape the price of the product>  This is a compressed version of the transformation 
  price <- html_nodes(page_html, 'div#quote-header-info') %>% html_nodes(., 'span') %>% .[4] %>% html_text(.) 
  price
  # scrape the difference in price of the product  absolute and percentage 
  price_diff_abs <- html_nodes(page_html, 'div#quote-header-info') %>% html_nodes(., 'span') %>% .[5] %>% html_text(.)  %>%  str_split(., boundary("line_break"), simplify = T) %>% .[1]
  price_diff_abs
  price_diff_pct <- html_nodes(page_html, 'div#quote-header-info') %>% html_nodes(., 'span') %>% .[5] %>% html_text(.)  %>%  str_split(., boundary("line_break"), simplify = T) %>% .[2] 
  price_diff_pct
  
  # Scraping the time as I intend this to run every hour 
  time <- html_nodes(page_html, 'div#quote-header-info') %>% html_nodes(., 'span') %>% .[6] %>% html_text(.)  %>%  str_split(., boundary("line_break"), simplify = T) %>% .[3]  
  time
  time_zone <- html_nodes(page_html, 'div#quote-header-info') %>% html_nodes(., 'span') %>% .[6] %>% html_text(.)  %>%  str_split(., boundary("line_break"), simplify = T) %>% .[4]  
  time_zone
  
  # Relative Index values
  index_html <- html_nodes(page_html, 'h3') %>% html_nodes(. , 'span') %>% html_text(.)
  index_html
  index <-  index_html[1]
  index
  index_diff_abs <- index_html[2]
  index_diff_abs
  index_diff_pct <- index_html[4]
  index_diff_pct
  
  index1 <- index_html[5]
  index1
  index1_diff_abs <- index_html[6]
  index1_diff_abs
  index1_diff_pct <- index_html[8]
  index1_diff_pct
  
  #Adding Date its not on the web page so adding it manually
  
  date = with_tz(Sys.time(), tz='EDT') %>% str_split(.,boundary("line_break"),simplify = T) %>% .[1]
  
  #Adding the index name autimatically 
  index_html_name <- html_nodes(page_html, 'h3') %>% html_nodes(. , 'a') %>% html_text(.) %>% .[1]
  index_html_name
  index1_html_name <- html_nodes(page_html, 'h3') %>% html_nodes(. , 'a') %>% html_text(.) %>% .[3]
  index1_html_name
  
  #Combining all the lists to form a data frame
  share_data <- data.frame(  Scriptname = title, 
                             Price = price,
                             Price_diff_abs = price_diff_abs, 
                             Price_diff_pct = price_diff_pct,
                             Date = date,
                             Time = time,
                             Time_zone = time_zone,
                             index = index,
                             index_diff_abs = index_diff_abs,
                             index_diff_pct = index_diff_pct,
                             index1 = index1,
                             index1_diff_abs = index1_diff_abs,
                             index1_diff_pct = index1_diff_pct
  )
  #Renaming the dataframe column name 
  colnames(share_data) <- c("Script name","Price","Absolute Price Difference",
                            "Percentage Price Difference","Date","Time","Time Zone",
                            index_html_name,
                            str_c(index_html_name, " Absolute Price Difference"),
                            str_c(index_html_name, " Percentage Price Difference"),
                            index_html_name,
                            str_c(index1_html_name, " Absolute Price Difference"),
                            str_c(index1_html_name, " Percentage Price Difference")
  )
  
  #Structure of the data frame
  str(share_data)
  path='/cloud/project/web_scraping_using_r/csv_output/'
  
  write.table(share_data, str_c(path,scriptname,'.csv'), 
              sep = ",", 
              col.names = !file.exists(str_c(path,scriptname,'.csv')),
              row.names = F ,
              append = T)
  
  
  #Sending Emial
  send.mail(from="demo.user.cgi.halifax@gmail.com",
            to=c("harsh.parikh@cgi.com","demo.user.cgi.halifax@gmail.com"),
            subject=str_c("Moneycontrol webscraing for script",scriptname),
            body="PFA the desired document",
            html=T,
            smtp=list(host.name = "smtp.gmail.com",
                      port = 465,
                      user.name = "demo.user.cgi.halifax@gmail.com",
                      passwd = "Demouser@cgi",
                      ssl = T),
            authenticate=T,
            attach.files=str_c(path,scriptname,'.csv'))
}

#function(script , country)
#Example yahoo_fin('AAPL' , 'ca')

