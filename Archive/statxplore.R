library(httr)
library(jsonlite)
library(tidyr)
library(dplyr)
library(tibble)
library(tidyjson)
library(purrr)
library(magrittr)

table_endpoint <- 'https://stat-xplore.dwp.gov.uk/webapi/rest/v1/table'
APIKEY <- ("65794a30655841694f694a4b563151694c434a68624763694f694a49557a49314e694a392e65794a7063334d694f694a7a644849756333526c6247786863694973496e4e3159694936496d316861584a704c6d316859325276626d46735a4542706258427962335a6c6257567564484e6c636e5a705932557562334a6e4c6e56724969776961574630496a6f784e6a51314d5445324f54417a4c434a68645751694f694a7a6448497562325268496e302e75733344326f444449667663655274786f754e764d7673554733557056576376614e46704f495a4539336b")

data_iz <- POST(
  url = table_endpoint, 
  add_headers(c("Content-Type"="application/json", "APIKey" = APIKEY)), 
  body = upload_file("Archive/JSON/childpovertydata_iz.json"))

data_la <- POST(
  url = table_endpoint, 
  add_headers(c("Content-Type"="application/json", "APIKey" = APIKEY)), 
  body = upload_file("Archive/JSON/childpovertydata_la.json"))

la_parse <- content(data_la, as = "parsed")

x<- content(datar, as = "parsed")
y <- x %>% as.tbl_json()

fields <- x$fields

data_parsed <- content(datar, as = "text")%>%fromJSON(flatten = TRUE)
#raw_json_list <- parse_json(data, simplifyVector = FALSE)
#raw_json_list$query$recodes$`str:field:CILIF_REL:V_F_CILIF_REL:GB_COA`$map %>% str(max.level=2)
#igz_names <- pluck(raw_json_list,"fields",1, "items",1,"labels" )

datafromjson <- content(datar, as="text", encoding="UTF-8")%>%fromJSON()
#cubes <- datafromjson$cubes$`str:count:CILIF_REL:V_F_CILIF_REL`$values


#view(cubes)
#cubetibble <- as_tibble(cubes)
#head(cubetibble)
#results <- child_pov_res$cubes$`str:count:CILIF_REL:V_F_CILIF_REL`$value

#fj2 <- Filter(Negate(purrr::is_empty),results) %>% as.tibble()
#enframe(unlist(results)) #should unnest and then form tibble but forms two columns
#as.tbl_json(data_from_JSON) %>% json_types() %>% 
# enter_object("str:count:CILIF_REL:V_F_CILIF_REL")
