"This script compiles the necessary ACS data into a single dateset 'all_acs' and a subset of it 'subsample_acs'"

library(ggplot2)
library(readr)
library(tidycensus)
# tidycensus is for mapping state fips codes to abbreviations
data(fips_codes)
head(fips_codes)

# The ACS data used here are the 5-year data from 2015-2019
# They were downloaded via FTP (details here: https://www.census.gov/programs-surveys/acs/data/data-via-ftp.html)
# ftp2.census.gov/programs-surveys/acs/data/pums/5-year
# FAQ about ACS: 
# https://www.census.gov/programs-surveys/acs/about/top-questions-about-the-survey.html#:~:text=The%20American%20Community%20Survey%20is,of%20Columbia%2C%20and%20Puerto%20Rico.
# Data dictionary: 
# https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/PUMS_Data_Dictionary_2015-2019.pdf

files <- list.files("input_data/acs_raw_data")
files <- files[files != "csv_pus.zip"]  # Remove the full us file (too large to load in memory all at once)
files

# Specify the variables to keep
# The ones that are commented out are probably in the housing level data - could be interesting context-level variables to bring in
keep_vars <- c("SERIALNO", "ST", "REGION", "AGEP", "SEX", "HISP", 
               "PINCP", "PUMA", "SCHL", "RAC1P",
               "LANX", # Language other than English spoken at home
               "JWTRNS", # Means of transport to work
               # "HFL", # Heating fuel
               "DREM", # Cognitive difficulty
               "JWMNP", # Travel time to work
               # "INSP", # Fire/hazard/flood insurance (yearly amount, 
                # use ADJHSG to adjust INSP to constant dollars)
               # "ELEP", # Electricity cost (monthly cost, use ADJHSG to 
                # adjust ELEP to constant dollars)
               # "FULP", # Fuel cost (yearly cost for fuels other than gas and electricity, 
                # use ADJHSG to adjust FULP to const. dollars)
               # "GASP", # Gas cost (monthly cost, use ADJHSG to adjust to constant dollars)
               "ANC1P" # Ancestry
               )
keep_vars

# Note: this takes about 30 minutes
all_acs <- data.frame()
for(file in files)
{
  data_acs <- read_csv(paste0("input_data/acs_raw_data/", file))
  data_acs <- data_acs[,names(data_acs) %in% keep_vars]
  
  state <- fips_codes$state[fips_codes$state_code==data_acs$ST[1]]
  state
  data_acs$state <- state[1]
  head(data_acs)
  
  all_acs <- rbind(all_acs, data_acs)
  gc()
}


length(table(all_acs$state))
table(all_acs$state)
names(all_acs)

# Write compiled data to disk
write.csv(all_acs, "output_data/all_acs.csv", row.names=F)
saveRDS(all_acs, "output_data/all_acs.rds")

# Create smaller random subsample
subsample_acs <- all_acs[sample(1:nrow(all_acs), 2.5e5),]
write.csv(subsample_acs, "output_data/subsample_acs.csv", row.names=F)
saveRDS(subsample_acs, "output_data/subsample_acs.rds")

