library(phsopendata)
library(magrittr)
library(dplyr)

#id obtained by locating dataset in opendata phs site and copying id from url in browser
appro_bweight_id <- "a5d4de3f-e340-455f-b4e4-e26321d09207"

#obtain dataset using phsopendata package (not on CRAN)
appro_bweight_dtaset <- phsopendata::get_resource(res_id = appro_bweight_id)

#clean and trim dataset
clean_bweight_data <- appro_bweight_dtaset[grep("S12", appro_bweight_dtaset$CA),] %>%
  dplyr::filter(FinancialYear >= "2008/09") %>%
  dplyr::select(FinancialYear, CA, BirthweightForGestationalAge, Livebirths) %>%
  dplyr::group_by(FinancialYear, CA, BirthweightForGestationalAge) %>%
  dplyr::summarise(Births = sum(Livebirths))

#calculate total live births
all_births <- clean_bweight_data %>%
  dplyr::group_by(FinancialYear, CA) %>%
  summarise(AllLiveBirths = sum(Births))

#extract birth of appropriate weight
approp_births <- clean_bweight_data %>%
  dplyr::filter(BirthweightForGestationalAge == "Appropriate") %>%
  dplyr::select(FinancialYear, CA, Births)
names(approp_births)[3] <- "AppropriateWeightCount"

#join birth totals and 'Appropiate weight' aggregate and calculate proportions
all_bweight_data <- dplyr::left_join(all_births, approp_births) %>%
  mutate(AppropriateWeightProportion = AppropriateWeightCount/AllLiveBirths * 100) %>%
  select(FinancialYear, CA, AppropriateWeightProportion)

names(all_bweight_data)
#extract only council area codes and names from lookup table
code_lookup <- read.csv("code_lookup.csv") %>%
  select(CPP, CA, FG) %>%
  distinct()

#match council names to council codes
final_bweight_data <- left_join(all_bweight_data, code_lookup, "CA")

#reformat for readiness to merge with other indicator data to create master data
final_bweight_data$Indicator <- "Healthy Birthweight"
final_bweight_data$Type <- "Raw"
names(final_bweight_data)[names(final_bweight_data) == "FinancialYear"] <- "Year"
names(final_bweight_data)[names(final_bweight_data) == "AppropriateWeightProportion"] <- "Value"

#save dataframe as csv in "data" folder
write.csv(final_bweight_data, "data/birthweight_data.csv")
