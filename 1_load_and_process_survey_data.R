"This script loads and processes the survey data."

library(zipcodeR)
download_zip_data()


# -- Load in survey data
# More details and data dictionary here: https://osf.io/6nak7/
survey <- readRDS("input_data/data_processed_deidentified.rds")

# Subset to only US
survey <- survey[survey$country_EN == "the United States",]

# Subset to only first response
survey <- survey[survey$first_complete == 1, ]


# -- Inspect and prepare variables
# SEX
table(survey$gender)
survey$female <- ifelse(survey$gender == "Female", 1, 0)


# AGE
table(survey$age_binned)


# RACE
# Note: this oversimplifies race as some people indicated multiple races
table(survey$race_1)
table(survey$race_2)
table(survey$race_5)
table(survey$hispanic)

survey$race <- "Other"
survey$race <- ifelse(survey$race_1 == "White" & !is.na(survey$race_1), "White", survey$race)
survey$race <- ifelse(survey$race_2 == "Black or African American" & !is.na(survey$race_2), "Black", survey$race)
survey$race <- ifelse(survey$race_5 == "Asian" & !is.na(survey$race_5), "Asian", survey$race)
survey$race <- ifelse(survey$hispanic == "Yes" & !is.na(survey$hispanic), "Hispanic", survey$race)

table(survey$race)


# EDUCATION
table(survey$education)


# INCOME
table(survey$income_brackets)

# STATE
table(survey$live_zipcode)
head(zip_code_db)
# Merge state abbreviation into survey df based on zipcode
survey <- merge(survey, zip_code_db[,c("zipcode", "state")], by.x="live_zipcode", by.y="zipcode")
survey$state
