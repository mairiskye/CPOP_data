library(httr)
library(dplyr)
library(phsopendata)

res_id <- "e9f8d10c-9c06-4e77-a0f5-70ff14af25a4"
BMI_dataset <- phsopendata::get_resource(res_id = res_id)
healthy_BMI <- BMI_dataset[c("SchoolYear", "CA", "EpiHealthyWeight")]

