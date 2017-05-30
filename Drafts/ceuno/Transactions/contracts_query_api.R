#
# Author:   Cristian Nuno
# Date:     May 30, 2017
# Purpose:  Create a function that extracts contracts data
#           using USA Spending API
#
# Example:  https://api.usaspending.gov/api/v1/transactions/?place_of_performance__state_code=NY
# Summary:  Request transaction data that takes place in NY
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

# Create function
state_transaction <- function( STATE_NAME ) {
  # Create empty list
  pages <- list()
  # Create initial API url
  url <- modify_url("https://api.usaspending.gov"
                    , path = "/api/v1/transactions/"
                    , query = list( place_of_performance__state_name = STATE_NAME
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
  #
  if( this.clean.resp$page_metadata$has_next_page == TRUE ) {
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
  
  } else {
    # if it doesn't have another page
    # , just return the URL in data frame format
    return( this.clean.resp$results )
    
  }
  
  
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
      , path = "/api/v1/transactions/"
      , response = raw.resp
    )
    , class = "usa_spending_api"
  )
} # end of function
#
# Call function for NY
ny_transactions <- state_transaction("NY")
# Only took 5 seconds!
View( ny_transactions)
# Save RDS
saveRDS( ny_transactions
         , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_export/ny_transactions"
         )







