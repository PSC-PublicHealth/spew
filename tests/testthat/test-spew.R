context("SPEW")

test_that("SPEW algorithm runs as expected", {
  data("delaware")
  data("uruguay")
  
  # sp for shapefiles, rgeos specifically for roads 
  library(sp)
  library(rgeos)
  
  # Make sure the 0 household places are caught
  test_ind <- 100
  delaware$pop_table[test_ind, "n_house"] <- 0
  
  expect_output(spew_place(index = test_ind, 
                 pop_table = delaware$pop_table, shapefile = delaware$shapefiles, 
                 pums_h = delaware$pums$pums_h, pums_p = delaware$pums$pums_p, 
                 schools = delaware$schools, workplaces = delaware$workplaces, 
                 marginals = delaware$marginals, output_type = "console", 
                 sampling_method = "uniform", locations_method = "uniform", 
                 convert_count = FALSE), "Place has 0 Households!")

  # Verify SPEW algorithm ---
  places <- 1:4
  delaware_small <- spew(pop_table = delaware$pop_table[places, ], 
                         shapefile = delaware$shapefiles,
                         pums_h = delaware$pums$pums_h, 
                         pums_p = delaware$pums$pums_p, 
                         verbose = FALSE)
  
  expect_true(length(delaware_small) == length(places))
  expect_true(delaware$pop_table[1, "place_id"] == delaware_small[[1]]$place_id)

  # Run the SPEW algorithm for Uruguay 
  uruguay_region <- spew_place(index = 1, 
                               pop_table = uruguay$pop_table, 
                               shapefile = uruguay$shapefiles, 
                               pums_h = uruguay$pums$pums_h, 
                               pums_p = uruguay$pums$pums_p, 
                               convert_count = TRUE)
  
  expect_true(uruguay_region$place_id == uruguay$pop_table[1, "place_id"])
  expect_true(uruguay_region$puma_id == uruguay$pop_table[1, "puma_id"])
  
  expect_true("SYNTHETIC_HID" %in% names(uruguay_region$households))
  expect_true("SYNTHETIC_PID" %in% names(uruguay_region$people))
  expect_true(max(table(uruguay_region$people$SYNTHETIC_PID)) 
              < max(table(uruguay_region$people$SERIALNO)))
  
  # Make sure the convert_count works 
  original_nhouse <- uruguay$pop_table[1, "n_house"]  
  expect_false(nrow(uruguay_region$households) == original_nhouse)
  expect_true(abs((nrow(uruguay_region$people) / original_nhouse) - 1) < .2)
  })
