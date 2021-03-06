

## Slicer

library(lidR)
library(TreeLS)

veri <- readLAS("tree2.las")

## Ground/ground

las <- lasground(veri, csf(class_threshold = 0.1,rigidness = 3L))

## Thinning

las = tlsSample(las, voxelize(0.01))

plot(las,size=1.5)

dtm <- grid_terrain(las, res=0.2, algorithm = knnidw(k = 6L, p = 2))

las <- lasnormalize(las, dtm)

plot(dtm)
print(las@header)
export <- LAS(las@data)
writeLAS(export, "tree2normalized.las")

col <- terrain.colors(50)
plot(las, color="Classification", colorPalette=col,size=1.5)
min_z <- min(las@data$Z[las@data$Classification==2])
max_z <- max(las@data$Z[las@data$Classification==1])
thickness = 1L
interval <- seq(from=0, to=max_z, by=thickness)

for (i in interval) {
  
  data <- i^2
  filename <- paste("slice", i ,".las",sep = "-")
  slice <- las@data[las@data$Z >i & las@data$Z < i+1,]
  slice <- LAS(slice)
  col <- heat.colors(2)
 # plot(slice, color="Classification",colorPalette = col)
  writeLAS(slice, file = filename)
}







