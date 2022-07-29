library(statxplorer)
library(magrittr)
library(dplyr)

statxplorer::load_api_key("txt/statxpl_apikey.txt")

#query statXplore api fo LA level relative low income child poverty data (from json file)
results <- statxplorer::fetch_table(filename = "json/child_poverty_la.json")
#extract datafram from response
data <- results$dfs$`Relative Low Income`
#rename variables
names(data) <- c("CPP", "Year", "Age", "value")
#extract data for ages 0-15
extract_age <- data %>%
  dplyr::filter(Age == c("0-4", "5-10", "11-15"))
#count total children in poverty by aggregating age
final_child_pov_data <- extract_age %>%
  group_by(CPP, Year) %>%
  summarise(value = sum(value))

write.csv(final_child_pov_data, "data/child_poverty_cpp.csv")
