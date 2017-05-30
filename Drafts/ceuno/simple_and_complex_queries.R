#
# Author:   Cristian Nuno
# Date:     May 29, 2017
# Purpose:  Simple and Advanced Queries in R using the USA Spending API
#

# I want data regarding the place of performance, which is...
# ...the principal place of business, where the majority of the work is performed. 
# For example, in a manufacturing contract, this would be the main plant where items are produced. 
# The nested object uses the fields from locations endpoint
# 
require(compiler)
# compilePKGS()
setCompilerOptions(suppressAll = TRUE )
# enableJIT enables or disables just-in-time (JIT) compilation. 
# JIT is disabled if the argument is 0. 
# If level is 1 then larger closures are compiled before their first use. 
# If level is 2, then some small closures are also compiled before their second use. 
# If level is 3 then in addition all top level loops are compiled before they are executed.
enableJIT(3) # 0 
# load necessary packages
library( httr )
library( jsonlite )
# Example URL = https://api.usaspending.gov/api/v1/awards/?place_of_performance__city_name=CHICAGO
awards_specific_city <- function( CITY_NAME ) {
  # Create empty list
  pages <- list()
  # Create initial API url
  url <- modify_url("https://api.usaspending.gov"
                    , path = "/api/v1/awards/"
                    , query = list(place_of_performance__city_name = CITY_NAME
                                   , page = 1
                                   , limit = 400
                    )
  )
  # Get API url
  raw.resp <- GET(url)
  if (http_type(raw.resp) != "application/json") {
    stop("API did not return json. Check 'status code = 200'"
         , call. = FALSE)
  }
  this.char.resp <- rawToChar( raw.resp$content) # convert from raw to char
  # convert JSON object into R object
  this.clean.resp <- fromJSON(this.char.resp
                              , flatten = TRUE
  ) 
  # identify a boolean operator
  # data_api$page_metadata$has_next_page = TRUE
  this.clean.resp$page_metadata$has_next_page = TRUE
  # while loop to grab and store data as long as the variable
  # this.clean.resp$page_metadata$has_next_page == TRUE
  
  # Set initial page number
  page_number <- 1
  
  # while loop with boolean condition
  while( this.clean.resp$page_metadata$has_next_page == TRUE ) {
    # identify current page url
    current.page.url <- this.clean.resp$page_metadata$current
    # subsitute "&page=XX" with "&page='page_number'"
    next.page.url <- gsub( pattern = "&page=[[:digit:]]+"
                           , replacement = paste0( "&page=", page_number)
                           , x = current.page.url
    )
    # Get new API url
    raw.resp <- GET( url = next.page.url )
    # Convert raw vector to character vector
    this.char.resp <- rawToChar( raw.resp$content )
    # Convert JSON object into R object
    this.clean.resp <- fromJSON( this.char.resp
                                 , flatten = TRUE
    )
    # For every page number (1, 2, 3...), insert that page's "results" inside the list
    pages[[ page_number ]] <- this.clean.resp$results
    # Add to the page number and restart the loop
    page_number <- page_number + 1
  }
  # once all the pages have been collected,
  data_api_data <- rbind.pages(pages)
  # return what we've collected
  return( data_api_data )
  
  
  # Turn API errors into R errors
  if (http_error( raw.resp )) {
    stop(
      sprintf(
        "USASpending.gov API request failed [%s]\n%s\n<%s>", 
        status_code( raw.resp),
        this.clean.resp$message,
        this.clean.resp$documentation_url
      ),
      call. = FALSE
    )
  }
  # add some structure stuff 
  structure(
    list(
      content = this.clean.resp
      , path = "/api/v1/awards/"
      , response = raw.resp
    )
    , class = "usa_spending_api"
  )
} # end of function

# Obtain awards data for where the place of performance takes place in the
# city of Chicago
chicago_awards <- awards_specific_city( "CHICAGO" ) # 3 seconds
str( chicago_awards ) # 1214 observations of 65 variables
# Take aways
# 1. unique( chicago_awards$piid )
#   , unique( chicago_awards$uri)
#   , and unique( chicago_awards$total_outlay ) = NA. 
#    piid = procurement instrument identifier.
# 2. unique( chicago_awards$date_signed__fy) = 2017
#
# Let's make longitude and latitude coordinates!
# ID interesting variables
# type; type_description; fain; total_obligation; description; 
# period_of_performance_start_date; period_of_performance_current_end_date;
# total_subaward_amount; subaward_amount; awarding_agency;
# library( dplyr )
chicago_awards$full.address <- paste0( chicago_awards$recipient.location.address_line1
                        , ", "
                        , chicago_awards$recipient.location.city_name
                        , ", "
                        , chicago_awards$recipient.location.state_code
                        , ifelse( test = is.na( chicago_awards$recipient.location.zip5 )
                                                     , yes = ""
                                                     , no = paste0(" "
                                                                      , chicago_awards$recipient.location.zip5
                                                                      )
                                                     )
                        ) 
# Check dimensions
dim( chicago_awards ) # 1214 by 66 variables
# Be mindful of character vector length
length( chicago_awards$full.address ) # 1214
# Ensure only unique addresses are geocoded
unique.full.address.chicago.awards <- unique( chicago_awards$full.address )
# now a shorter character vector length is guaranteed
length( unique.full.address.chicago.awards ) # 271
# Now let's geocode!
library( ggmap )
# Was just introduced to the wonderful world of API query limits
# Using the Google Maps API to perform geocoding is limited to 2,500 daily queries
geocodeQueryCheck() # 2499 geocoding queries remaining
# Run the geocode query!
geocode_results <- geocode( location = unique.full.address.chicago.awards
                                   , output = "latlon" 
                                   )
# painfully slow
# about 1 second per query/271 queries = 271 seconds = ~4.5 minutes of waiting
# Finish with some errors
# Would recommend we arrange the obligations from highest to least
# Take 500 records of the highest obligations
#
# WARNING!!!
# Google API has daily 2,500 limit on requests
# Be smart with your requests!
geocodeQueryCheck() # 2226 geocoding queries remaining
# Add unique full address to geocode results
geocode_results$full.address <- unique.full.address.chicago.awards
# Merge
# Just doing this the R way with Plyr package
# Left join on chicago_awards from chicago_awards_geocode
# using the "full.address" variable
# dim should be 1214 by 68 variables
library( plyr )
chicago_awards_geocode <- join( x = geocode_results
                           , y = chicago_awards
                           , by = "full.address"
                           , type = "left"
                           )
dim( chicago_awards ) # 1214 by 66 variables
dim( geocode_results ) # 271 by 3 variables
dim( chicago_awards_geocode ) # 1214 by 68 variables
# Export as RDS
saveRDS( chicago_awards_geocode
         , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/chicago_awards_fy17.rds"
         )
# View results
View( chicago_awards_geocode )

# Let's map this!
library( leaflet )
library( magrittr )
library(htmltools)
library(htmlwidgets)
# edit map
map <- leaflet( chicago_awards_geocode ) %>% # load data frame into leaflet map object
  # set view to cover all of Chicago
  setView( lng = -87.629798, lat = 41.878114, zoom = 10 ) %>% 
  # add background to map
  addTiles() %>%
  # cluster options
  addMarkers( lng = ~lon
              , lat = ~lat
              , popup = ~recipient.recipient_name
    , clusterOptions = markerClusterOptions()
  ) %>% # Error message about 7 missing records
  addEasyButton(easyButton(
    icon="fa-globe", title="Zoom Back Out",
    onClick=JS("function(btn, map){ map.setZoom(10); }")))

# View Map
map



