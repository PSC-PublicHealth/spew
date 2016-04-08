#' Generic sampling locations function 
#' 
#' @param method character vector either "uniform" or "roads" determining 
#' how we are sampling locations 
#' @param place_id numeric specifiying the ID of the region we are 
#' subsampling  
#' @param n_house numeric indicating the number of households
#' @param shapefile sp class with all of the locations for each place id. Note 
#' that this is a list with two shapefiles if me
#' @param noise the standard deviation of how much 
#' we jitter the road locations in each direction (only if method is "roads")
#' @return SpatialPoints object with coordinates for the n households
sample_locations <- function(method, place_id, n_house, shapefile, noise = .0001) {
  # Call the appropriate location sampling function based on
  # the input sampling method  
  if (method == "uniform") {
    print("Sampling Uniformly!")
    locs <- sample_locations_uniform(place_id, n_house, shapefile)
  } else if (method == "roads") {
    print("Sampling from Roads!")
    locs <- sample_locations_from_roads(place_id, n_house, shapefile, noise = .0001)
  } else {
    stop("location sampling method must be uniform or roads")
  }
  
  return(locs)
}

#' Sample from a particular polygon shapefile 
#' 
#' @param place_id numeric specifiying the ID of the region we are 
#' subsampling  
#' @param n_house numeric indicating the number of households
#' @param shapefile sp class with all of the locations for each place id
#' @return SpatialPoints object with coordinates for the n households
sample_locations_uniform <- function(place_id, n_house, shapefile) {
  # Subset the shapefile to the polygon 
  # specified by the place_id argument 
  slots <- methods::slot(shapefile, "polygons")
  region <- which(shapefile$place_id == place_id)
  poly <- slots[[region]]
  
  # Remove holes from polygon if any are found 
  is_hole <- lapply(poly@Polygons, function(p) p@hole)
  if (any(unlist(is_hole)) == TRUE) {
    poly <- remove_holes(poly)
  }
  
  # Obtain a Uniform, simple random sample of size n_house
  locs <- sp::spsample(poly, n = n_house, offset = c(0, 0), 
                       type = "random", iter = 50)
  return(locs)
}

#' Remove holes from an object of class Polygon 
#' 
#' @param polygon object of class Polygon or Polygons 
#' 
#' @note Borrowed the idea from the wild1 package, which 
#' I wasn't able to load for R 3.2.2, so I found the source code here:
#' https://github.com/cran/wild1/blob/master/R/remove.holes.r
#' @return polygon without and Polygons with holes 
remove_holes <- function(polygon) {
  is_hole <- lapply(polygon@Polygons, function(p) p@hole)
  is_hole <- unlist(is_hole)
  polys <- polygon@Polygons[!is_hole]
  polygon <- Polygons(polys, ID = polygon@ID)
  return(polygon)
}

#' Sample coordinates from roads
#'
#' @param place_id numeric specifiying the ID of the region we are 
#' subsampling  
#' @param n_house numeric indicating the number of households
#' @param shapefile sp class with all of the locations for each place id.  
#' In addition, we must have road shapefiles so shapefile is a list with both 
#' the tracts and the roads, tracts is the first object and roads the second.
#' @param noise the standard deviation of how much we jitter the road locations in each direction
#' @return SpatialPoints object with coordinates for the n households
sample_locations_from_roads <- function(place_id, n_house, shapefile, noise = .0001) {
  stopifnot(any(names(shapefile) == "roads"))
  
  new_shp <- subset_shapes_roads(place_id, shapefile)
  locs <- samp_roads(n_house, new_shp, noise)
  return(locs)
}

#' Subset the shapefile and road lines to proper roads within specified tract
#'
#' @param place_id numeric specifiying the ID of the region we are 
#' subsampling  
#' @param shapefile sp class with all of the locations for each place id.  
#' In addition, we must have road shapefiles so shapefile is a list with both the 
#' tracts and the roads, tracts is the first object and roads the second.
#' @return newShp - roads within the tract, a SpatialLines object
subset_shapes_roads <- function(place_id, shapefile) {
  stopifnot(class(shapefile) == "list")
  stopifnot(length(shapefile) == 2)
  
  # Subset the regions to the place_id polygon
  regions <- shapefile[[1]]
  poly <- regions[regions@data$place_id == place_id, ]
  
  # Add the roads in to make a SpatialLines Object
  roads_sub <- shapefile[[2]][poly,]
  new_shp <- rgeos::gIntersection(roads_sub, poly)
  return(new_shp)
}

#' Sample the locations from the liens of a SpatialLines object
#'
#' @param n_house number of households
#' @param newShp SpatialLines object
#' @param noise std deviation of Gaussian noise added to coordinates, default is .001
#' @return SpatialPoints object with coordinates for the n_house households
samp_roads <- function(n_house, newShp, noise){
  if ("lineobj" %in% slotNames(lines)) {
    pts <- sp::spsample(newShp@lineobj, n = n_house, type = "random", iter = 50)
  } else {
    pts <- sp::spsample(newShp, n = n_house, type = "random", iter = 50)
  }
  
  # Sometimes sampling fails.  If so, we resample from already 
  # selected points to fill in the rest.
  if (n_house != length(pts)) {
    resampled_pts <- n_house - length(pts)
    inds <- sample(1:length(pts), resampled_pts)
    pts <- pts[c(1:length(pts), inds),]
  }
  
  err_x <- rnorm(length(pts), 0, noise)
  err_y <- rnorm(length(pts), 0, noise)
  pts@coords[,1] <- pts@coords[,1] + err_x
  pts@coords[,2] <- pts@coords[,2] + err_y
  
  stopifnot(n_house == length(pts))
  return(pts)
}