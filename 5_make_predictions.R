"This script uses the predictive model previously fitted to generate predictions
on the frequency tables."

library(readr)

# Load in freq tables if needed
freq_table_puma <- read_csv("output_data/freq_table_pumalevel.csv.gz")
freq_table_state <- read_csv("output_data/freq_table_statelevel.csv.gz")

#Generate predictions for each cell
freq_table_puma$prediction <-
  predict(individual.model, newdata=freq_table_puma, allow.new.levels=T)

freq_table_state$prediction <-
  predict(individual.model, newdata=freq_table_state, allow.new.levels=T)

# For binary outcomes:
#The predictions are still in logits so we need
#to transform them back to probabilities:
# library(boot)
# freq_table_puma$predictions <- inv.logit(freq_table_puma$predictions)