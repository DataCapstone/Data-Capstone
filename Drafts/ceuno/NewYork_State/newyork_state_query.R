#
# Author:   Cristian Nuno
# Date:     June 5, 2017
# Purpose:  Create a New York state awards search tool
#           with USA spending API data
################## Load Necessary Packages ###################
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

################### General Purpose GET Function ############################################
#############################################################################################
GET_all_pages <- function( PATH, QUERY ) {
  # Create empty list
  pages <- list()
  # Create initial API url
  url <- modify_url("https://api.usaspending.gov"
                    , path = PATH
                    , query = QUERY
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
################### Create State API Function #####################################
state_api <- function( STATE_NAME ) {
  api_data <- GET_all_pages( PATH = "/api/v1/awards/"
                             , QUERY = list(place_of_performance__state_name = STATE_NAME
                             )
  )
  # check if column "funding_agency"
  if( "funding_agency" %in% names(api_data) == TRUE ) {
    # delete the column "funding_agency"
    api_data <- subset( x = api_data, select = -funding_agency )
  }
  return( api_data )
}
################### Call State API Function ####################
newyork_state <- state_api("NEW YORK")
# this is taking awhile...20 seconds and counting
# called at 10:30am...now 10:32am...
# I'll wait 5 minutes...then I'm saving it as an RDS file
# 10:36am! It ran! Success!
# Save as RDS
saveRDS( newyork_state
         , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_export/newyork_state_fy17.rds"
         )
