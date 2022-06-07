#querying Educational Attainment data from statistics.gov.scot with a POST method

library(httr)

resp <- httr::POST(
  url = "https://statistics.gov.scot/sparql.csv",
  body = list(query = "select  ?score ?years ?DZCode ?DZName ?IZName ?councilName 
           where { 
             ?data <http://purl.org/linked-data/cube#dataSet> <http://statistics.gov.scot/data/educational-attainment-of-school-leavers>. 
             ?refPeriod <http://www.w3.org/2000/01/rdf-schema#label> ?years.
             ?data <http://purl.org/linked-data/sdmx/2009/dimension#refArea> ?refArea.
             ?data <http://purl.org/linked-data/sdmx/2009/dimension#refPeriod> ?refPeriod.
             ?refArea <http://www.w3.org/2004/02/skos/core#notation> ?DZCode.
  			 ?data <http://purl.org/linked-data/cube#measureType> ?measureType.
  			 ?refArea <http://www.w3.org/2000/01/rdf-schema#label> ?DZName.
  			 ?refArea <http://statistics.data.gov.uk/def/statistical-geography#parentcode> ?IZparentCode.
  			 ?IZparentCode <http://www.w3.org/2000/01/rdf-schema#label> ?IZName.
 			 ?IZparentCode <http://statistics.data.gov.uk/def/statistical-geography#parentcode> ?council.
  			 ?council <http://www.w3.org/2000/01/rdf-schema#label> ?councilName.
             ?data ?measureType ?score.}"))

edu_data <- content(resp, as = "parsed")
