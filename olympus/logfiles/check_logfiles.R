# Load in the SPEW logfile functions 
devtools::load_all("/mnt/beegfs1/data/shared_group_data/syneco/spew")

# Read in the log-file data 
all_logfiles <- list.files("/mnt/beegfs1/data/shared_group_data/syneco/spew/olympus/logfiles/logfiles_1.3.0", 
							full.names = TRUE)

# Extract the country name from the log-file...
logfile_names <- unlist(lapply(strsplit(all_logfiles, "\\."), function(x) x[5]))

# Check the logfiles to see which locations executed correctly 
count <- 0
complete_locations <- c()
incomplete_locations <- c()

for (log in seq_along(all_logfiles)) {
  # Read in the logfile and run the check function 
  logfile_path <- all_logfiles[log]
  current_logfile <- readLines(logfile_path)
  current_name <- logfile_names[log]
 
  # Print out the results of the check function 
  result <- spew:::check_logfile(current_logfile)
  
  if (result == "Complete!") {
    count <- count + 1
    complete_locations <- c(complete_locations, current_name)
  } else {
    incomplete_locations <- c(incomplete_locations, current_name)
  }
}

# Print out the number of complete and incomplete logfiles 
print("Complete: ")
print(complete_locations) 

print("Incomplete: ")
print(incomplete_locations)
