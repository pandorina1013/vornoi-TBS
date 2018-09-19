load.packages <- c(
  "tidyverse",
  "geojsonio",
  "deldir",
  "maptools")
new.packages <- load.packages[!(load.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, dependencies = T)
lapply(load.packages, require, character.only = TRUE)

points.df <- geojson_read("data/TBS.geojson", what = "sp") %>% 
  data.frame()
tl <- deldir(
  points.df$coords.x1, 
  points.df$coords.x2, 
  rw=c(min(points.df$coords.x1), 
       max(points.df$coords.x1), 
       min(points.df$coords.x2), 
       max(points.df$coords.x2))
  ) %>% 
  tile.list()
polys <- vector(mode='list', length = length(tl))
for (i in seq(along=polys)) {
  polys[[i]] <- cbind(tl[[i]]$x, tl[[i]]$y) %>% 
    rbind(.[1,]) %>% 
    Polygon() %>% 
    list() %>% 
    Polygons(ID=as.character(i))
}
voronoi <- polys %>% 
  SpatialPolygons() %>% 
  SpatialPolygonsDataFrame(data.frame(x=points.df$coords.x1,y=points.df$coords.x2))
writeSpatialShape(voronoi, fn = "data/vornoi-TBS")