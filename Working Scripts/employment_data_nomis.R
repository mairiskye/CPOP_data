library(renv)
library(httr)
library(magrittr)
library(readr)
library(zoo)
library(tidyr)
library(stringr)
library(utils)

#controls package dependencies - automatically updated
renv::init()

#STEP 1: REQUEST annual population survey DATA FROM NOMIS API----------------------------------

#obtains 'Aged 16-64 in Employment - All : All People' dataset for all years for all Scottish councils
employed_raw <- httr::GET("https://www.nomisweb.co.uk/api/v01/dataset/NM_17_1.data.csv?geography=2013265931TYPE432&cell=403843841&measures=20100&select=geography_name,geography_code,date_name,obs_value")

#obtains 'Aged 16-64 - All : All People' dataset for all years for all Scottish councils
population_raw <- httr::GET("https://www.nomisweb.co.uk/api/v01/dataset/NM_17_1.data.csv?geography=2013265931TYPE432&cell=402720769&measures=20100&select=geography_name,geography_code,date_name,obs_value")

#STEP 2: PARSE RESPONSE TO OBTAIN DATAFRAMES-------------------------------------------------

employed_data <- content(employed_raw, as = "parsed", type = "text/csv") %>%
  as_tibble() %>%
  rename("in_employment" = OBS_VALUE) #count of employed in 16-64 age group

population_data <- content(population_raw, as = "parsed", type = "text/csv") %>%
  as_tibble() %>%
  rename("population" = OBS_VALUE) #16-64 year old working age population

#STEP 3: MERGE AND CLEAN DATAFRAMES---------------------------------------------------

#strings to replace longer geographical and date variable names
variable_names <- c("council", "s_code", "year")

clean_merge <- left_join(employed_data,population_data) %>% #match all from employed and missing from population
  rename_with(~variable_names, .cols = 1:3) %>% #feature renaming
  filter(grepl("Apr",year)) %>% #filters only the required Apr-Mar periods 
  dplyr::mutate(year = str_replace_all(year, "Apr ", "")) %>%
  dplyr::mutate(year = str_replace_all(year, "Mar " , "")) #trims year data: 'Apr 2010 - Mar 2011' becomes 2010-2011

#STEP 4: RATE CALCULATION---------------------------------------------------------------

#creates employment rate ('rate') and percentage employed ('percent') columns
rate_calulation <- clean_merge %>%
  mutate(rate = in_employment/population, 
         percent = round((rate * 100),1))

#STEP 5: CALCULATE THREE YEAR ROLLED AVERAGES---------------------------------------------------

#sorts and groups by council, then creates three year rolled averages column
#this object can be written to csv to obtain numerator and denominator data
rolled_avg <- rate_calulation %>%
  dplyr::arrange(desc(council)) %>% 
  dplyr::group_by(council) %>% 
  dplyr::mutate("3ya" = zoo::rollmean(percent, k = 3, fill = NA)) %>% 
  dplyr::ungroup()

#STEP 6: SELECT DATA AND WRITE TO CSV FILE-------------------------------------------------

#filters out NA in averages column (first and last year of data)
final_data <- rolled_avg %>%
  arrange(council) %>%
  drop_na("3ya") %>%
  select(c("council", "s_code", "year", "3ya"))

#writes final data to csv file in cloud directory for exporting
write.csv(final_data,file="employment_data.csv", row.names = FALSE)
