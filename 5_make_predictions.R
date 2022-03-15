library(readr)

# Load in freq tables if needed
freq_table_puma <- read_csv("output_data/freq_table_pumalevel.zip")
freq_table_state <- read_csv("output_data/freq_table_statelevel.zip")

#Generate predictions for each cell
freq_table_puma$prediction <-
  predict(individual.model, newdata=freq_table_puma)

freq_table_state$prediction <-
  predict(individual.model, newdata=freq_table_state)

# For binary outcomes:
#The predictions are still in logits so we need
#to transform them back to probabilities:
# library(boot)
# freq_table_puma$predictions <- inv.logit(cell_count$predictions)