library(sf)
library(tidyverse)
library(raster)

setwd("D:/GITHUB_CEREMA/insee_carroyage_2010_2015/")
source("script_fxns.R")

# READ DATA
carr_1km_2010 <- st_read("in/carr_corse_1km_2010_crs3035.gpkg") %>% st_set_crs(3035)
carr_1km_2015 <- st_read("in/carr_corse_1km_2015_crs3035.gpkg") %>% st_set_crs(3035)
# save(list=c("carr_1km_2010", "carr_1km_2015"), file="data.rda")

f <- make_grid_with_data(carr_1km_2010, 
                         carr_1km_2015, 
                         resolution = 1000, 
                         tolerance = 100)

# EXPORT
st_write(f, "grille_1km_corse_pop2010-2015.gpkg", delete_dsn = TRUE)