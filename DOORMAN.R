#15/10/19

library(httr)
library(rjson)

test_url <- "https://iss.moex.com/iss/securities/EUR_RUB__TOM.jsonp?iss.only=boards&iss.meta=off&iss.json=extended&_=1571120711667"

response <- GET(test_url)

response$status_code

http_status(response)
http_error(response)
response_body <- content(response, as = "text")
json_parsed <- fromJSON(response_body)

api_key <- "25f36cd78ef503359041a3c7d6b56686"

datasets_url <- "https://apidata.mos.ru/v1/datasets?api_key="
datasets_url <- paste0(datasets_url, api_key)
response <- GET(datasets_url)

datasets <- content(response, as = "text")
datasets <- fromJSON(datasets)

precinct_url <- "https://apidata.mos.ru/v1/datasets/961/rows?api_key="
precinct_url <- paste0(precinct_url, api_key)
response2 <- GET(precinct_url)

precincts <- content(response2, as = "text")
precincts <- fromJSON(precincts)

clean_data <- sapply(
  precincts,
  function(x) {x$Cells$geoData$coordinates}
)

clean_data <- t(clean_data)
clean_data <- data.frame(clean_data)
colnames(clean_data) <- c('lon', 'lat')

library(ggplot2)

axes <- ggplot(data = clean_data, mapping = aes(x = lon, y = lat))

axes + geom_point() 

library(OpenStreetMap)

library(ggplot2)
