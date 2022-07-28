library(httr)
library(dplyr)
library(phsopendata)
library(tidyr)

res_id <- "e9f8d10c-9c06-4e77-a0f5-70ff14af25a4"
BMI_dataset <- phsopendata::get_resource(res_id = res_id)
healthy_BMI <- BMI_dataset[c("SchoolYear", "CA", "EpiHealthyWeight")]

rolled_avg_BMI <- healthy_BMI %>%
  dplyr::arrange(desc(CA)) %>% 
  dplyr::group_by(CA) %>% 
  dplyr::mutate("threeYrAvg" = 100*(zoo::rollmean(EpiHealthyWeight, k = 3, fill = NA))) %>% 
  dplyr::ungroup() %>%
  drop_na("threeYrAvg")

code_lookup_table <- read.csv("code_lookup.csv") %>%
  select(CA, CPP) %>%
  distinct()

p1_bmi_data <- left_join(rolled_avg_BMI, code_lookup_table, by = "CA") %>%
  arrange(CPP) %>%
  select(CPP, SchoolYear, threeYrAvg) %>%
  rename("Year" = SchoolYear, "value" = threeYrAvg) %>%
  mutate(Indicator = "Primary 1 Body Mass Index", Type = "Raw")

write.csv(p1_bmi_data, file = "data/p1_bmi_data.csv")
