#
# Author:     Cristian Nuno
# Date:       June 2, 2017
# Purpose:    Testing API Functions for City, State
#             County, State and Congressional District, State pairs.
#
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

################### General Purpose GET Function #####################################
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
################### City, State API Function #####################################
city_state <- function( CITY_NAME, STATE_NAME ) {
  api_data <- GET_all_pages( PATH = "/api/v1/awards/"
                            , QUERY = list(place_of_performance__city_name = CITY_NAME
                                   , place_of_performance__state_name = STATE_NAME
                            )
  )
  # check if column "funding_agency"
  if( "funding_agency" %in% names(api_data) == TRUE ) {
    # delete the column "funding_agency"
    api_data <- subset( x = api_data, select = -funding_agency )
  }
  return( api_data )
}
####### Call City, State GET ALL pages function
ks_mo <- city_state("KANSAS CITY", "MISSOURI")
dim(ks_mo) # 171 by 74
chi_il <- city_state("CHICAGO", "ILLINOIS")
dim(chi_il) # 1201 by 75
la_ca <- city_state("LOS ANGELES", "CALIFORNIA") 
dim(la_ca) # 928 by 74
st_wa <- city_state("SEATTLE", "WASHINGTON")
dim(st_wa) # 64 by 74
syr_ny <- city_state("SYRACUSE", "NEW YORK")
dim(syr_ny) # 125 by 74
############### County, State API Function ###########
county_state <- function( COUNTY_NAME, STATE_NAME ) {
  api_data <- GET_all_pages( PATH = "/api/v1/awards/"
                            , QUERY = list(place_of_performance__county_name = COUNTY_NAME
                                   , place_of_performance__state_name = STATE_NAME
                            )
  )
  # check if column "funding_agency"
  if( "funding_agency" %in% names(api_data) == TRUE ) {
    # delete the column "funding_agency"
    api_data <- subset( x = api_data, select = -funding_agency )
  }
  return( api_data )
}
############### Call function ################
cook.il <- county_state("COOK", "ILLINOIS")
dim(cook.il) # 840 by 74
king.wa <- county_state("KING", "WASHINGTON")
dim(king.wa) # 1119 by 74
ond.ny <- county_state("ONONDAGA", "NEW YORK")
dim(ond.ny) # 176
############# Congressional District, State Name API Function #####
con_district_state <- function( CONGRESS_DIST, STATE_NAME ) {
  api_data <- GET_all_pages( PATH = "/api/v1/awards/"
                             , QUERY = list(place_of_performance__congressional_code = CONGRESS_DIST
                                            , place_of_performance__state_name = STATE_NAME
                             )
  )
  # check if column "funding_agency"
  if( "funding_agency" %in% names(api_data) == TRUE ) {
    # delete the column "funding_agency"
    api_data <- subset( x = api_data, select = -funding_agency )
  }
  return( api_data )
}
############# Call the Function ########
ny.24 <- con_district_state("24", "NEW YORK")
dim(ny.24) # 505 by 74
ia.1 <- con_district_state("01", "IOWA")
dim(ia.1) # 1395 by 74
il.06 <- con_district_state("06", "ILLINOIS")
dim(il.06) # 171 by 74
mo.02 <- con_district_state("02", "MISSOURI")
dim(mo.02) # 148 by 74
