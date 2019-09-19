source('/cloud/project/web_scraping_using_r/code/scraper_function.R')

for (i in 1:10)
{
  yahoo_fin('GIB-A.TO','ca')
  Sys.sleep(360)
}

yahoo_fin('GIB-A.TO','ca') #CGI Inc. code
yahoo_fin('ICICIBANK.BO','in')
