install.packages("devtools")
devtools::install_github("UrbanInstitute/urbnmapr")

library(tidyverse)
library(urbnmapr)
library(sf)
library(ggplot2)
library(dplyr)

states_sf <- get_urbn_map("states", sf = TRUE)
# new_crs <- st_crs(2163)
states_sf_crs <- st_transform(states_sf, crs = 4326)

states_sf %>% 
  ggplot(aes()) +
  geom_sf(fill = "grey", color = "#ffffff")

setwd("C:/Users/19397/Documents/GitHub/MUSA_550/24fall-python-assignments/24fall-python-final-luming_xu_proposal/analysis")
st_write(states_sf_crs, "C:/Users/19397/Documents/GitHub/MUSA_550/24fall-python-assignments/24fall-python-final-luming_xu_proposal/analysis/data/us_states.geojson", driver = "GeoJSON")


st_crs(states_sf)
my_polygons <- st_read("data/NPS_Land_Resources_Division_Boundary_and_Tract_Data_Service.geojson")
transformed_polygons <- st_transform(my_polygons, st_crs(states_sf))


ggplot() +
  geom_sf(data = states_sf, fill = "lightblue") +
  geom_sf(data = transformed_polygons, fill = "orange", alpha = 0.5)

alaska_adjusted <- transformed_polygons %>%
  filter(STATE == "AK") %>%
  mutate(
    geometry = st_geometry(.) * 0.35 + c(2100000, -2200000) # Adjust scaling and position
  )
st_crs(alaska_adjusted) <- st_crs(states_sf)

hawaii_adjusted <- transformed_polygons %>%
  filter(STATE == "HI") %>%
  mutate(
    geometry = st_geometry(.) * 0.6 + c(5200000, -1400000) # Scale and shift
  )
st_crs(hawaii_adjusted) <- st_crs(states_sf)

polygons_remained <- transformed_polygons %>%
  filter(!STATE %in% c("AK","HI","PR","GU","VI"))

polygons_adjusted <- rbind(alaska_adjusted,hawaii_adjusted,polygons_remained)

ggplot() +
  # geom_sf(data = states_sf, fill = "transparent") +
  geom_sf(data = polygons_adjusted, fill = "orange", alpha = 0.5)
