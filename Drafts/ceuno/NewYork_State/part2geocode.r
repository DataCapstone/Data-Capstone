#
# Author:   Cristian Nuno
# Date:     June 5, 2017
# Purpose:  Finish the remainder of my New York state geo code
#
# Load necessary packages
library(ggmap)
# import data sets
rds_url <- "https://github.com/DataCapstone/Data-Capstone/blob/master/Drafts/ceuno/NewYork_State/newyork_state_fy17.rds?raw=true"
newyork_state <- readRDS( gzcon( url( rds_url ) ) )
geo_rds_url <- "https://github.com/DataCapstone/Data-Capstone/blob/master/Drafts/ceuno/NewYork_State/ny_geocode_partial.rds?raw=true"
geocode_results <- readRDS( gzcon( url( geo_rds_url ) ) )
# Check geoquery
geocodeQueryCheck() # 2500 remaining!
### Create full address function
full.address <- function( address, city_name, state_code, zip_code ) {
  paste0( address
          , ", "
          , city_name
          , ", "
          , state_code
          , ifelse( test = is.na( zip_code )
                    , yes = ""
                    , no = paste0( " ", zip_code )
          )
  )
} # end of function
### Create full address
newyork_state$recipient.full.address <- full.address( address = newyork_state$recipient.location.address_line1
                                                      , city_name = newyork_state$recipient.location.city_name
                                                      , state_code = newyork_state$recipient.location.state_code
                                                      , zip_code = newyork_state$recipient.location.zip5
)
# Extract unique full addresses
length( newyork_state$recipient.full.address ) # 13991
unique.ny.addresses <- unique( newyork_state$recipient.full.address)
length( unique.ny.addresses ) # 2615
# start geo coding
# Run the geocode query!
# this means I'll manually have to find the remaining 115 geocodes
# 2500 - 2615
geocode_results2 <- geocode( location = unique.ny.addresses[2500:2615]
                            , output = "latlon" 
) # now we wait...116 queries...should take around 2 minutes
# done!
geocodeQueryCheck() # 2384 geocode query remaining
# Add unique full address to geocode results
geocode_results2$recipient.full.address <- unique.ny.addresses[2500:2615]
# save as rds
saveRDS( geocode_results2
         , file = "C://Users/cenuno//IST_659//truman//ny_geocode_partial2.rds"
)
