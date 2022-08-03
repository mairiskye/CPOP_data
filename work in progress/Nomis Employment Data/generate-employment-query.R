library(renv)
library(nomisr)
library(tidyr)
library(dplyr)
library(jsonlite)
library(magrittr)

#obtain master dataset code------------------------------------------------------------

#search all NOMIS datasets for keyword = "employment" and parse response
search <- httr::GET("https://www.nomisweb.co.uk/api/v01/dataset/def.sdmx.json?search=keywords-employment*")
resp <- jsonlite::fromJSON(txt="https://www.nomisweb.co.uk/api/v01/dataset/def.sdmx.json?search=keywords-employment*")

#extract dataframe
search_df <- resp$structure$keyfamilies$keyfamily

#extract master dataset code
code <- search_df %>%
  dplyr::filter(name$value == "annual population survey") %>%
  dplyr::pull(id)

#obtain master dataset metadata
aps_metadata <- nomisr::nomis_get_metadata(code)

#obtain cell code----------------------------------------------------- 

cell_metadata <- nomisr::nomis_get_metadata(code, concept = "CELL")

#multiple key phrases filter down datasets to relevant population
#then employed and population datasets extracted
cell_id_search <- cell_metadata %>%
  dplyr::filter(grepl("16-64",description.en)) %>%
  dplyr::filter(grepl("All People",description.en)) %>%
  dplyr::filter(grepl("All : All People",description.en))

employed_data_id <- dplyr::filter(cell_id_search,grepl("in Employment",description.en)) %>%
  dplyr::pull(id)

population_data_id <- dplyr::filter(cell_id_search, grepl("T01:22", description.en)) %>%
  dplyr::pull(id)

#obtain geography codes-----------------------------------------------------

#need geography type (local authorities), and area parent code (Scotland)
geo_metadata <- nomisr::nomis_get_metadata(code, concept = "GEOGRAPHY")

geo_metadata_type <- nomisr::nomis_get_metadata(code, concept = "GEOGRAPHY", type = "type")
geo_type_id <- geo_metadata_type %>%
  filter(grepl("local authorities: district",description.en)) %>%
  filter(grepl("2021",description.en)) %>%
  pull(id)

geo_metadata_area <- nomis_get_metadata("NM_17_1", concept = "geography", type = geo_type_id) 
geo_area_id <- geo_metadata_area %>%
  filter(label.en == "Aberdeen City") %>% 
  pull(var = "parentCode")

#generate URIs-----------------------------------------------------------------------------

employed_data_uri <- paste("https://www.nomisweb.co.uk/api/v01/dataset/",code,".data.csv?geography=",
                           geo_area_id,geo_type_id,"&cell=", employed_data_id, sep="")

population_data_uri <- paste("https://www.nomisweb.co.uk/api/v01/dataset/",code,".data.csv?geography=",
                             geo_area_id,geo_type_id,"&cell=", population_data_id, sep="")
print(employed_data_id)