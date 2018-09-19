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
w <- deldir(points.df$coords.x1, points.df$coords.x2, rw=c(min(points.df$coords.x1), max(points.df$coords.x1), min(points.df$coords.x2), max(points.df$coords.x2))) %>% 
  tile.list()
polys <- vector(mode='list', length = length(w))

for (i in seq(along=polys)) {
  pcrds<-cbind(w[[i]]$x, w[[i]]$y)
  pcrds<-rbind(pcrds, pcrds[1,])
  polys[[i]]<-Polygons(list(Polygon(pcrds)), ID=as.character(i))
}

voronoi <- polys %>% 
  SpatialPolygons %>% 
  SpatialPolygonsDataFrame(data = data.frame(x=points.df$coords.x1,y=points.df$coords.x2,storename=points.df$Name,
                                                     row.names=sapply(slot(., 'polygons'),function(x) slot(x, 'ID'))))
writeSpatialShape(voronoi, fn = "data/vornoi-TBS")