# Where-to-buy-motorcycle

Final project for Spatial Econometrics in R class at Faculty of Economic Sciences, University of Warsaw

FULL REPORT IN "rmd.md" FILE
ORIGINAL CODE IN "spatial_analysis.R" FILE

IDEA: 
Idea of this project is to determine in which of Poland's voivodeships 125cc class motorcycles are over and underpriced basing on real auction's data.

METHODS:
-Data scraping with rvest
-Spatial econometrics models using weights matrix based on spatial polygons
-Akaike Information Cryterion to compare models accuracy
-Moran test of autocorrelation

OUTCOMES:
Basing on auctions from OTOMOTO website, there are no spatial lag dependencies in estimation of prices of 125cc motorcycles in Poland. Therefore, basing on
linear regression model, voivodeships with overpriced and underpriced motorcycles were shown in report.
