library(dplyr)

# -- Create all combinations of demogr variables and get count for each
##### PUMA level
freq_table_puma <- acs %>% 
  group_by(age_binned, PUMA, female, race, education, income_brackets) %>% 
  summarize(count=n()
        # , cognitive_difficulty = mean(cognitive_difficulty)
        # , age = mean(AGEP)
           )

head(freq_table_puma)

# Add in context-level variables
head(puma_level_avgs)
freq_table_puma <- merge(freq_table_puma, puma_level_avgs, by="PUMA")
head(freq_table_puma)

sum(freq_table_puma$count)#should be equal or about equal to the number of rows in ACS

#Create a proportion column
#This represents our estimate of the proportion of people
#with each demographic combination in the target population.
freq_table_puma$proportion <- freq_table_puma$count / sum(freq_table_puma$count)
sum(freq_table_puma$proportion)#should be 1

# write.csv(freq_table_puma, "output_data/freq_table_pumalevel.csv", row.names = F)


##### State level
freq_table_state <- acs %>% 
  group_by(age_binned, state, female, race, education, income_brackets) %>% 
  summarize(count=n()
            # , cognitive_difficulty = mean(cognitive_difficulty)
            # , age = mean(AGEP)
  )

head(freq_table_state)


state_level_avgs <- acs %>% group_by(state) %>% 
  summarize(commute = mean(JWMNP, na.rm=T),
            urban_transport = mean(urban_transport, na.rm=T),
            only_english = mean(only_english, na.rm=T)
            )

head(state_level_avgs)
freq_table_state <- merge(freq_table_state, state_level_avgs, by="state")

sum(freq_table_state$count)#should be equal or about equal to the number of rows in ACS
head(freq_table_state)

#Create a proportion column
#This represents our estimate of the proportion of people
#with each demographic combination in the target population.
freq_table_state$proportion <- freq_table_state$count / sum(freq_table_state$count)
sum(freq_table_state$proportion)#should be 1

# write.csv(freq_table_state, "output_data/freq_table_statelevel.csv", row.names = F)
