library(lme4) # This package allows us to run multi-level models

# Choose a DV to predict
survey$cur_DV <- as.numeric(survey$outdoor_activities_running)
survey$cur_DV <- as.numeric(survey$climate_worry)


# Note if we had good coverage over US states we could add state as a predictor too
individual.model <- lmer(cur_DV ~
                           (1|age_binned) + (1|education) + (1|income_brackets) + 
                           (1|race) + (1|female) + commute + urban_transport + only_english
                           # + (1|state)
                           , data=survey
                        )

# For binary outcome:
# individual.model <- glmer(approve_POTUS ~ (1|AGE) + (1|EDUC) +
#                             (1|RACE) + (1|SEX) + (1|STATE),
#                           data=survey, family=binomial(link="logit"))

#Some commands to inspect the model results:
library(arm)
display(individual.model)
fixef(individual.model)
ranef(individual.model)


# Fit OLS to check r squared
summary(lm(cur_DV ~
                  age_binned + education + income_brackets +
                  race + female + commute + urban_transport + only_english
                  # + (1|state)
                  , data=survey
        ))

