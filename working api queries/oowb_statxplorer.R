library(statxplorer)
library(magrittr)
library(dplyr)

statxplorer::set_api_key("65794a30655841694f694a4b563151694c434a68624763694f694a49557a49314e694a392e65794a7063334d694f694a7a644849756333526c6247786863694973496e4e3159694936496d316861584a704c6d316859325276626d46735a4542706258427962335a6c6257567564484e6c636e5a705932557562334a6e4c6e56724969776961574630496a6f784e6a51314d5445324f54417a4c434a68645751694f694a7a6448497562325268496e302e75733344326f444449667663655274786f754e764d7673554733557056576376614e46704f495a4539336b")

#data from 2019 onwards :
results_recent <- statxplorer::fetch_table(filename = "json/oowb_la.json")
#data from 2013-2018:
results_historic <- statxplorer::fetch_table(filename = "json/oowb_historic.json")

recent_data <- results_recent$dfs$`Benefit Combinations New` %>%
  rename("Benefit Combinations" = `Benefit Combinations New`)

historic_data <- results_historic$dfs$`Benefit Combinations`

all_data <- rbind(recent_data, historic_data)

extract_and_reformat <- dplyr::filter(all_data, 
                                all_data[3] == "Total", 
                                grepl("May", Quarter)) %>%
  select(!`Benefit Combinations (Out of Work)`) %>%
  mutate(Indicator = "Out of Work Benefits") %>%
  mutate(Type = "Raw")

names(extract_and_reformat)[1:3] <- c("CPP", "Year", "value")

#convert year format e.g. from May-19 to 2019
extract_and_reformat$Year <- gsub("May-", "20", extract_and_reformat$Year)

extract_and_reformat$Year <- as.numeric(extract_and_reformat$Year)

oowb_data_final <- extract_and_reformat %>%
  arrange(CPP, Year)

write.csv(oowb_data_final, "data/oowb_data.csv")
