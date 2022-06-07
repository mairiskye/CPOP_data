library(httr)
library(jsonlite)
library(tidyr)
library(dplyr)
library(tibble)
library(tidyjson)
library(purrr)
library(magrittr)

table_endpoint <- 'https://stat-xplore.dwp.gov.uk/webapi/rest/v1/table'


data <- POST(
  url = table_endpoint, 
  add_headers(c("Content-Type"="application/json", "APIKey" = APIKEY)), 
  body =  '{
  "database" : "str:database:CILIF_REL",
  "measures" : [ "str:count:CILIF_REL:V_F_CILIF_REL" ],
  "recodes" : {
  "str:field:CILIF_REL:F_CILIF_DATE:DATE_NAME" : {
  "map" : [ [ "str:value:CILIF_REL:F_CILIF_DATE:DATE_NAME:C_CILIF_YEAR:2014" ], [ "str:value:CILIF_REL:F_CILIF_DATE:DATE_NAME:C_CILIF_YEAR:2015" ], [ "str:value:CILIF_REL:F_CILIF_DATE:DATE_NAME:C_CILIF_YEAR:2016" ], [ "str:value:CILIF_REL:F_CILIF_DATE:DATE_NAME:C_CILIF_YEAR:2017" ], [ "str:value:CILIF_REL:F_CILIF_DATE:DATE_NAME:C_CILIF_YEAR:2018" ], [ "str:value:CILIF_REL:F_CILIF_DATE:DATE_NAME:C_CILIF_YEAR:2019" ] ],
  "total" : false
  },
  "str:field:CILIF_REL:V_F_CILIF_REL:CHILD_AGE" : {
  "map" : [ [ "str:value:CILIF_REL:V_F_CILIF_REL:CHILD_AGE:C_CILIF_AGE_BAND:1" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:CHILD_AGE:C_CILIF_AGE_BAND:2" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:CHILD_AGE:C_CILIF_AGE_BAND:3" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:CHILD_AGE:C_CILIF_AGE_BAND:4" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:CHILD_AGE:C_CILIF_AGE_BAND:5" ] ],
  "total" : true
  },
  "str:field:CILIF_REL:V_F_CILIF_REL:COA" : {
  "map" : [ [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000033" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000034" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000041" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000035" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000036" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000005" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000006" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000042" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000008" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000045" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000010" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000011" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000014" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000047" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000049" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000017" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000018" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000019" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000020" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000013" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000021" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000050" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000023" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000048" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000038" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000026" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000027" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000028" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000029" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000030" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000039" ], [ "str:value:CILIF_REL:V_F_CILIF_REL:COA:V_C_MASTERGEOG11_LA_TO_UTLA_NI:S12000040" ] ],
  "total" : true
  }
  },
  "dimensions" : [ [ "str:field:CILIF_REL:V_F_CILIF_REL:COA" ], [ "str:field:CILIF_REL:F_CILIF_DATE:DATE_NAME" ], [ "str:field:CILIF_REL:V_F_CILIF_REL:CHILD_AGE" ] ]
  }')

data2 <- content(data, as="text", encoding="UTF-8") %>%
   fromJSON(flatten=TRUE, simplifyDataFrame = FALSE)

data3 <- data2$cubes$`str:count:CILIF_REL:V_F_CILIF_REL`$values %>% as_tibble()

#fj2 <- Filter(Negate(purrr::is_empty),fj) %>% as.tibble()

# enframe(unlist(data_from_JSON)) should unnest and then form tibble but forms two columns
#as.tbl_json(data_from_JSON) %>% json_types() %>% 
 # enter_object("str:count:CILIF_REL:V_F_CILIF_REL")
#view(as.tbl_json(data_from_JSON))