source('/cloud/project/web_scraping_using_r/code/scraper_function.R')

for (i in 1:10)
{
  yahoo_fin(script='AAPL' ,country='ca',from_email="demo.user.cgi.halifax@gmail.com",from_password="xxxxxxx",to_email="demo.user.cgi.halifax@gmail.com")
  Sys.sleep(360)
}

yahoo_fin(script='AAPL' ,country='ca',from_email="demo.user.cgi.halifax@gmail.com",from_password="xxxxxxxx",to_email="demo.user.cgi.halifax@gmail.com") #CGI Inc. code
#yahoo_fin('ICICIBANK.BO','in')
