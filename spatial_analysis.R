library(spdep)
library(rgdal)
library(maptools)
library(sp)
library(RColorBrewer)
library(classInt)
library(GISTools)
library(maps)
library(readr)
library(rvest)
library(xml2)

# Maps setup
pl<-readOGR(".", "Panstwo") # 1 jedn. 
voi<-readOGR(".", "wojewodztwa") # 16 jedn. 
pov<-readOGR(".", "powiaty") # 380 

pl<-readOGR(".", "Panstwo") # 1 jedn. 
voi<-readOGR(".", "wojewodztwa") # 16 jedn.

plot(voi)

# Spatial weight matrix
voi.df<-as.data.frame(voi)

crds<-coordinates(voi)

cont.nb<-poly2nb(as(voi, "SpatialPolygons"))
cont.listw<-nb2listw(cont.nb, style="W")

# Data manipulation
# Data scrapped with Scraper.R file
data_otomoto <- read_csv("data_otomoto.csv")

order <- c("Opolskie","Świętokrzyskie","Kujawsko-pomorskie","Mazowieckie","Pomorskie","Śląskie", "Warmińsko-mazurskie","Zachodniopomorskie","Dolnośląskie","Wielkopolskie","Łódzkie","Podlaskie","Małopolskie","Lubuskie","Podkarpackie","Lubelskie")

data_agg <- aggregate(list(data_otomoto$price, data_otomoto$mileage, data_otomoto$age), by = list(data_otomoto$voivodeship), FUN = mean)
colnames(data_agg) = c("voi","mean_price", "mean_mileage","mean_age")

data_agg <- data_agg[match(order,data_agg$voi),]

# Models estimation

form <- mean_price~mean_mileage+mean_age

#OLS Model
OLS_1<-lm(form, data=data_agg)

# Manski model (full specification) 
GNS_1<- sacsarlm(form, data = data_agg, listw=cont.listw, type="sacmixed")

# SAC / SARAR model 
SAC_1<-sacsarlm(form, data = data_agg, listw=cont.listw)

SDEM_1 <- errorsarlm(form, data = data_agg, listw=cont.listw, etype="emixed")

# no spatial lags of X (SEM)
SEM_1 <- errorsarlm(form, data = data_agg, listw=cont.listw)

# SAR / SDM - spatial lag model
# with spatial lags of X (SDM)
SDM_1 <- lagsarlm(form, data = data_agg, listw=cont.listw, type="mixed") 

# no spatial lags of X (SAR)
SAR_1 <- lagsarlm(form, data = data_agg, listw=cont.listw) 

# from errorsarlm() library
SLX_1 <- lmSLX(form, data = data_agg, listw=cont.listw)


#Model comparison
AIC(GNS_1, SDM_1, SDEM_1, SAC_1, SAR_1, SEM_1, SLX_1, OLS_1)
moran.test(OLS_1$residuals, cont.listw)

#Outcomes visualisation
res <- OLS_1$residuals
brks<-c(min(res)-1, mean(res)-sd(res), mean(res), mean(res)+sd(res), max(res)+1)
cols<-c("steelblue4","lightskyblue","thistle1","plum3")

plot(voi, col=cols[findInterval(res,brks)])
title(main="Residuals from spatial model")
legend("bottomleft", legend=c("<mean-sd", "(mean-sd, mean)", "(mean, mean+sd)", ">mean+sd"), leglabs(brks1), fill=cols, bty="n")

voi.df<-as.data.frame(voi)
voi.df$names <- order
text(coordinates(voi), label=voi.df$names, cex=0.7, font=2)


plot(voi, col=cols[findInterval(res,brks)])
title(main="Prices of 125 cc motorcycles in voivodeships in Poland")
legend("bottomleft", legend=c("Less than average+sd", "less than average", "more than average", "More than average+sd"), leglabs(brks1), fill=cols, bty="n")
voi.df<-as.data.frame(voi)
voi.df$names <- order
text(coordinates(voi), label=voi.df$names, cex=0.7, font=2)
