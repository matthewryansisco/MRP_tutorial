library(dplyr)

# -- Create all combinations of demogr variables and get count for each
# State level
freq_table_state <- acs %>% group_by(age_binned, state, female, race, education, income_brackets) %>% summarize(count=n()
                                                                               , cognitive_difficulty = mean(cognitive_difficulty)
                                                                               , age = mean(AGEP)
                                                                               )
head(freq_table_state)

sum(freq_table_state$count)#should be equal or about equal to the number of rows in ACS

#Create a proportion column
#This represents our estimate of the proportion of people
#with each demographic combination in the target population.
freq_table_state$proportion <- freq_table_state$count / sum(freq_table_state$count)
sum(freq_table_state$proportion)#should be 1

write.csv(freq_table_state, "output_data/freq_table_statelevel.csv", row.names = F)


# PUMA level
freq_table_puma <- acs %>% group_by(age_binned, PUMA, female, race, education, income_brackets) %>% summarize(count=n()
                                                                              , cognitive_difficulty = mean(cognitive_difficulty)
                                                                              , age = mean(AGEP)
                                                                              )
head(freq_table_puma)

sum(freq_table_puma$count)#should be equal or about equal to the number of rows in ACS

#Create a proportion column
#This represents our estimate of the proportion of people
#with each demographic combination in the target population.
freq_table_puma$proportion <- freq_table_puma$count / sum(freq_table_puma$count)
sum(freq_table_puma$proportion)#should be 1

write.csv(freq_table_puma, "output_data/freq_table_pumalevel.csv", row.names = F)
