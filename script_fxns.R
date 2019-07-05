make_grid_with_data <- function(carr_1km_2010, carr_1km_2015, resolution = 1000, tolerance = 100) {
  
  # RENAME AND SELECT COLUMNS
  carr_1km_2010 <- carr_1km_2010 %>% mutate(id_carr_2010 = row_number()) %>% dplyr::select(id_carr_2010, pop_2010 = ind)
  carr_1km_2015 <- carr_1km_2015 %>% mutate(id_carr_2015 = Id_carr1km) %>% dplyr::select(id_carr_2015, pop_2015 = Ind)
  
  # CREATE RASTER AND POLYGONIZE IT
  f <- raster(extent(carr_1km_2010), res=resolution) %>% rasterToPolygons(r) %>% as("sf") %>% st_set_crs(3035)
  
  # SPATIAL JOIN
  ## 2010
  i_2010 <- st_intersects(f %>% st_centroid %>% st_buffer(tolerance), 
                          carr_1km_2010 %>% st_cast("POLYGON") %>% st_centroid)
  
  ## 2015
  i_2015 <- st_intersects(f %>% st_centroid %>% st_buffer(tolerance), 
                          carr_1km_2015 %>% st_centroid)
  
  ## JOIN VALUES
  f2 <- f %>% mutate(id_carr_2010 = carr_1km_2010$id_carr_2010[as.numeric(i_2010)],
                     id_carr_2015 = carr_1km_2015$id_carr_2015[as.numeric(i_2015)]) %>% 
    left_join(carr_1km_2010 %>% data.frame, by="id_carr_2010") %>%
    left_join(carr_1km_2015 %>% data.frame, by="id_carr_2015")
  
  return(f2)
  
}
