"This script adds context level variable(s) to the survey dataset."

library(dplyr)

# Pull in zipcode to puma crosswalk table
# This crosswalk generated here: 
# https://mcdc.missouri.edu/applications/geocorr2018.html
puma_zipcode_crosswalk <- read.csv("input_data/puma_to_zipcode_crosswalk.csv", 
                                   stringsAsFactors = F,
                                   colClasses = c("character"))
puma_zipcode_crosswalk <- puma_zipcode_crosswalk[-1, ]
names(puma_zipcode_crosswalk)
head(puma_zipcode_crosswalk)
# Note: 'afact' is the (population weighted) proportion of the zip in each puma

puma_level_avgs <- acs %>% group_by(PUMA) %>% 
  summarize(commute = mean(commute, na.rm=T),
            urban_transport = mean(urban_transport, na.rm=T),
            only_english = mean(only_english, na.rm=T)
            )
head(puma_level_avgs)

temp = merge(puma_level_avgs, puma_zipcode_crosswalk, 
             by.x="PUMA", by.y="puma12", all.x=T)
head(temp)

# Fill in missing afact values
# This will make it so zips across multiple pumas will equally weight the pumas 
# where weights are missing
temp$afact[is.na(temp$afact)] <- 1
temp$afact <- as.numeric(temp$afact)

zip_level_avgs <- temp %>% group_by(zcta5) %>% 
  summarize(commute = weighted.mean(commute, afact),
            urban_transport = weighted.mean(urban_transport, afact),
            only_english = weighted.mean(only_english, afact))
head(zip_level_avgs)

survey <- merge(survey, zip_level_avgs, 
                by.x="live_zipcode", by.y="zcta5", all.x=T)
# Just a few cannot be matched  
names(survey)
