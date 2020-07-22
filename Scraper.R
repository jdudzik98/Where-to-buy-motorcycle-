install.packages("rvest")
install.packages("xml2")
library(rvest)
library(xml2)


base_site = "https://www.otomoto.pl/motocykle-i-quady/chopper--krosowy--motorower--sportowy--turystyczny--typ-cruiser--typ-enduro--typ-naked/?search%5Bfilter_float_engine_capacity%3Afrom%5D=125&search%5Bfilter_float_engine_capacity%3Ato%5D=125&search%5Border%5D=created_at%3Adesc&search%5Bcountry%5D=&page=1"

#Scraper for single page
scrap <- function(site){
  link <- xml2::read_html(site)
  
  motorcycle_model <- link %>%
    html_nodes(xpath='//*[@id="body-container"]/div[2]/div[1]/div/div[1]/div[5]/article[@data-variation="a"]/div[2]/div[1]/h2/a') %>%
   html_text()

  price <- link %>%
    html_nodes(xpath='//*[@id="body-container"]/div[2]/div[1]/div/div[1]/div[5]/article[@data-variation="a"]/div[2]/div[2]/div/div/span/span[1]') %>%
    html_text()

  city_name <- link %>%
    html_nodes(xpath='//*[@id="body-container"]/div[2]/div[1]/div/div[1]/div[5]/article[@data-variation="a"]/div[2]/h4/span[2]') %>%
    html_text()

  voivodeship <- link %>%
    html_nodes(xpath='//*[@id="body-container"]/div[2]/div[1]/div/div[1]/div[5]/article[@data-variation="a"]/div[2]/h4/span[3]') %>%
    html_text()

  year_of_production <- link %>%
    html_nodes(xpath='//*[@id="body-container"]/div[2]/div[1]/div/div[1]/div[5]/article[@data-variation="a"]/div[2]/ul/li[1]/span') %>%
    html_text()

  mileage <- link %>%
    html_nodes(xpath='//*[@id="body-container"]/div[2]/div[1]/div/div[1]/div[5]/article[@data-variation="a"]/div[2]/ul/li[2]/span') %>%
    html_text()

  site_data <- cbind(price,city_name,voivodeship,year_of_production,mileage)
  return(site_data)
}

#Scraper for all pages
get_data <- function(site){
  link <- xml2::read_html(site)
  
  num_of_sites <- link %>%
    html_nodes(xpath='//*[@id="body-container"]/div[2]/div[2]/ul/li[6]/a/span') %>%
    html_text()
  
  data <- as.data.frame(scrap(site))
  
  for(i in 2:num_of_sites){
    print(paste("Scrapped", i-1, "pages of", num_of_sites))
    data <- rbind(data, scrap(paste(substr(site, 1, nchar(site)-1), i, sep = "")))
    Sys.sleep(1)
  }
  print("Finished")
  return(data)
}

#Data manipulation
data <- data2
data <- get_data(base_site)
data$price <- as.integer(gsub(" ","", data$price))
data$voivodeship <- substr(data$voivodeship,2,nchar(data$voivodeship)-1)
data$mileage <- gsub(" ","", data$mileage)
data$mileage <- as.integer(gsub("km","", data$mileage))
data$age <- 2020-as.integer(data$year_of_production)

write.csv(data, file="data_otomoto.csv")

