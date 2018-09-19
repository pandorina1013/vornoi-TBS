load.packages <- c(
  "tidyverse",
  "magrittr",
  "leaflet",
  "geojsonio")
new.packages <- load.packages[!(load.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, dependencies = T)
lapply(load.packages, require, character.only = TRUE)

vornoi <- geojson_read("data/vornoi-TBS.geojson", what = "sp")
points <- geojson_read("data/TBS.geojson", what = "sp")

vornoi.map <- leaflet(vornoi) %>%
  addTiles() %>%
  setView(lng=139.7320, lat=35.6590, zoom = 12) %>%
  addPolygons(weight = 1)

points.map <- leaflet(points) %>%
  addTiles() %>%
  setView(lng=139.7320, lat=35.6590, zoom = 12) %>%
  addMarkers(label = ~Name)
  