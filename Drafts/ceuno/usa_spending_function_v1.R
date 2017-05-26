#
# Author: Cristian Nuno
# Date:   May 24, 2017
# Purpose: Updated notes on Accessing Data via APIs in R
#
# Summary: Trying to delve into fetching data via APIs. 
#          For more information, please see these two links:
#          "Accessing APIs from R" - https://www.r-bloggers.com/accessing-apis-from-r-and-a-little-r-programming/
#          "USA Spending API endpoints" - https://api.usaspending.gov/docs/endpoints
#
# Compiler is a base package in R
# "Calling the compiler a byte code compiler is actually a bit of a misnomer:
# the external representation of code objects currently uses int operands, 
# and when compiled with gcc the internal representation is actually
# threaded code rather than byte code."
# For information, click here: 
# https://stat.ethz.ch/R-manual/R-devel/library/compiler/DESCRIPTION
# R_COMPILE_PKGS = TRUE
# R_ENABLE_JIT = 3
# R_ENABLE_JIT = 3
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

### INCORPORATING API DATA PULL FROM JUSTIN/LECY ###
# PARSE THE RESPONSE v6
usa_spending_awards_cgac <- function(path, CGAC ) {
  # Create empty list
  pages <- list()
  # Create initial API url
  url <- modify_url("https://api.usaspending.gov"
                    , path = path
                    , query = list(awarding_agency__toptier_agency__cgac_code = CGAC
                                   , page = 1
                                   , limit = 470
                    )
  )
  # Get API url
  raw.resp <- GET(url)
  if (http_type(raw.resp) != "application/json") {
    stop("API did not return json", call. = FALSE)
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
      content = this.clean.resp,
      path = path,
      response = raw.resp
    ),
    class = "usa_spending_api"
  )
} # end of function

# Call function
dod.fy17 <- usa_spending_awards_cgac( path = "/api/v1/awards/"
                                            , CGAC = "097"
) # 3 seconds to execute!
dim( dod.fy17 ) # 3382 observations by 65 variables! dataframe

## Try to obtain field choices to help expand queries!
# I think you get it by stating a field choice that does not exist!
# In this case, let's use "api_key" as the invalid field choice!
# Create initial API url
url.bad <- modify_url("https://api.usaspending.gov/"
                  , path = "api/v1/awards/"
                  , query = list(awarding_agency__toptier_agency__cgac_code = "097"
                                 , page = 1
                                 , limit = 470
                                 , api_key = "12345"
                  )
)
# Get API url
raw.resp.bad <- GET(url)
# View results by converting raw to character
raw.resp.bad.char <- rawToChar( raw.resp.bad$content )
### This isn't working
### Trying something old
# Now use the GET function
get.data.bad <- GET( url = "https://api.usaspending.gov"
                 , path = "/api/v1/awards/"
                 , query = list(awarding_agency__toptier_agency__cgac_code = "097"
                                , api_key = "1234")
)
# content(): extract the content from the query
dod.data.bad <- content( get.data.bad )
class( dod.data.bad ) # it's a list object of 1 variable
dod.data.bad$message # display field choices message
field.choices.awards <- dod.data.bad$message
# now for some string manipulation to get the field choices into a vector

# Replace first few words with nothing 
field.choices.awards <- gsub( pattern = "Cannot resolve keyword 'api_key' into field. Choices are: "
                              , replacement = ""
                              , x = field.choices.awards
                              )
# split strings based on ", " into individual elements within one vector
field.choices.awards <- strsplit( x = field.choices.awards
                 , split = ", "
                 , fixed = TRUE
                 )
# unlist
field.choices.awards <- unlist( field.choices.awards )
# a vector of 36 unique field choices based on the "awards" endpoints


