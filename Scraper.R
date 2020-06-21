install.packages("rvest")
install.packages("xml2")
library(rvest)
library(xml2)

#Creating scraper for single page
site <- xml2::read_html("https://www.otomoto.pl/motocykle-i-quady/chopper--krosowy--motorower--sportowy--turystyczny--typ-cruiser--typ-enduro--typ-naked/?search%5Bfilter_float_engine_capacity%3Afrom%5D=125&search%5Bfilter_float_engine_capacity%3Ato%5D=125&search%5Border%5D=created_at%3Adesc&search%5Bcountry%5D=&page=1")
motorcycle_model <- site %>%
  html_nodes(xpath='//*[@id="body-container"]/div[2]/div[1]/div/div[1]/div[5]/article[@data-variation="a"]/div[2]/div[1]/h2/a') %>%
  html_text()

price <- site %>%
  html_nodes(xpath='//*[@id="body-container"]/div[2]/div[1]/div/div[1]/div[5]/article[@data-variation="a"]/div[2]/div[2]/div/div/span/span[1]') %>%
  html_text()

city_name <- site %>%
  html_nodes(xpath='//*[@id="body-container"]/div[2]/div[1]/div/div[1]/div[5]/article[@data-variation="a"]/div[2]/h4/span[2]') %>%
  html_text()

voivodeship <- site %>%
  html_nodes(xpath='//*[@id="body-container"]/div[2]/div[1]/div/div[1]/div[5]/article[@data-variation="a"]/div[2]/h4/span[3]') %>%
  html_text()

year_of_production <- site %>%
  html_nodes(xpath='//*[@id="body-container"]/div[2]/div[1]/div/div[1]/div[5]/article[@data-variation="a"]/div[2]/ul/li[1]/span') %>%
  html_text()

mileage <- site %>%
  html_nodes(xpath='//*[@id="body-container"]/div[2]/div[1]/div/div[1]/div[5]/article[@data-variation="a"]/div[2]/ul/li[2]/span') %>%
  html_text()

data <- cbind(price,city_name,voivodeship,year_of_production,mileage)



