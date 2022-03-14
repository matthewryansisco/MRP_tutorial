#Generate predictions for each cell
freq_table_state$prediction <-
  predict(individual.model, newdata=freq_table_state)

freq_table_puma$prediction <-
  predict(individual.model, newdata=freq_table_puma)


# For binary outcomes:
#The predictions are still in logits so we need
#to transform them back to probabilities:
# library(boot)
# cell_count$predictions <- inv.logit(cell_count$predictions)