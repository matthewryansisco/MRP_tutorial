"This script loads the American Community Survey dataset and processes it."

# Load in census data (in this case the American Community Survey data)
# (This can take a few minutes)
acs <- read.csv("output_data/subsample_acs.csv",
                stringsAsFactors = F,
                colClasses = c("character"))
# acs <- readRDS("output_data/all_acs.rds")

# Data dictionary: 
# https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/PUMS_Data_Dictionary_2015-2019.pdf


# -- Process
# We must remove people less than 18 to match the voting population
acs <- subset(acs, AGEP>=18)

# Now let's harmonize our variables to the survey data:

##########
#SEX
table(survey$female)#check what we have to harmonize to
table(acs$SEX)
# 1: male
# 2: female

#transform the ACS data to match the survey data
acs$female <- ifelse(acs$SEX == 2, 1, 0)
table(acs$female)#see the result


###########
#AGE
table(survey$age_binned)#check what we have to harmonize to
table(acs$AGEP)

#transform the ACS data to match the survey data
acs$age_binned <- NA
acs$age_binned[acs$AGEP<=34] <- "18-34"
acs$age_binned[acs$AGEP>=35 & acs$AGEP<=54] <- "35-54"
acs$age_binned[acs$AGEP>=55] <- "55+"
table(acs$age_binned)


###########
#RACE
table(survey$race)#check what we have to harmonize to
table(acs$RAC1P)

acs$race <- "Other"
acs$race[acs$RAC1P==1] <- "White"
acs$race[acs$RAC1P==6] <- "Asian"
acs$race[acs$RAC1P==2] <- "Black"
acs$race[as.numeric(acs$HISP)!=1] <- "Hispanic"
table(acs$race)


###########
#EDUCATION
table(survey$education)#check what we have to harmonize to
table(acs$SCHL)#see what we're starting with

acs$education <- NA
acs$education[acs$SCHL<=15] <- "Some schooling, but no diploma or degree"
acs$education[acs$SCHL %in% c(16, 17)] <- "High school diploma or GED"
acs$education[acs$SCHL %in% c(18, 19)] <- "Some college, but no degree"
acs$education[acs$SCHL %in% c(20)] <- "Associate's degree"
acs$education[acs$SCHL %in% c(21)] <- "Bachelor's degree"
acs$education[acs$SCHL %in% c(22)] <- "Master's degree"
acs$education[acs$SCHL %in% c(23)] <- 
  "Professional degree beyond bachelor's degree"
acs$education[acs$SCHL %in% c(24)] <- "Doctorate degree"
table(acs$education)


###########
#INCOME
table(survey$income_brackets)
table(acs$PINCP)

acs$income_brackets <-  cut(as.numeric(acs$PINCP), 
                            breaks=c(-Inf, 15e3, 30e3, 45e3, 60e3, 75e3, 90e3, 
                                     105e3, 120e3, 135e3, 150e3, Inf), 
                            labels=levels(survey$income_brackets))
table(acs$income_brackets)


###########
#STATE
table(survey$state)#check what we have to harmonize to
table(acs$state)#see what we're starting with
length(table(acs$state))

#convert abbreviation to full name:
# acs$STATE <- state.name[match(acs$state,state.abb)]
# table(acs$STATE)#see the result



########## Process possible context level variables
# Cognitive difficulty
# Note: not currently used as predictor variable but interesting to map
# "Because of a physical, mental, or emotional problem, difficulty remembering, 
# concentrating, or making decisions (DREM)."
table(acs$DREM)
acs$cognitive_difficulty <- ifelse(acs$DREM == 1, 1, 0)

# Language other than English spoken at home
table(acs$LANX)
acs$only_english <- ifelse(acs$LANX == 1, 0, 1)

# Mode of transportation to work
table(acs$JWTRNS)
acs$urban_transport <- ifelse(acs$JWTRNS == "01", 0, 1)
# 01 is taking a personal automobile
table(acs$urban_transport)

# Distance of commute
table(acs$JWMNP)
acs$commute <- as.numeric(acs$JWMNP)
