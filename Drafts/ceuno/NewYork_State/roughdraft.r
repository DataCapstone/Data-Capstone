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
# View file
View( newyork_state )
###################### Faster way #########
# import url
rds_url <- "https://github.com/DataCapstone/Data-Capstone/blob/master/Drafts/ceuno/NewYork_State/newyork_state_fy17.rds?raw=true"
# read .rds url
newyork_state <- readRDS( gzcon( url( rds_url ) ) ) # three seconds
# Create some summary statistics
# Convert from char to numeric
newyork_state$total_obligation <- as.numeric(newyork_state$total_obligation)
# summary
options( scipen = 20 )
summary( newyork_state$total_obligation )
hist(newyork_state$total_obligation)
max( newyork_state$total_obligation
     , na.rm = TRUE
     ) # this returns the value 10056536000
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
}
######
practice <- full.address( address = newyork_state$recipient.location.address_line1
                          , city_name = newyork_state$recipient.location.city_name
                          , state_code = newyork_state$recipient.location.state_code
                          , zip_code = newyork_state$recipient.location.zip5
                          )


### Create full address
newyork_state$recipient.full.address <- paste0( newyork_state$recipient.location.address_line1
                                       , ", "
                                       , newyork_state$recipient.location.city_name
                                       , ", "
                                       , newyork_state$recipient.location.state_code
                                       , ifelse( test = is.na( newyork_state$recipient.location.zip5 )
                                                 , yes = ""
                                                 , no = paste0(" "
                                                               , newyork_state$recipient.location.zip5
                                                 )
                                       )
) 
####
library(DT)
library(dplyr)
library(stringi)
library( lettercase)
library( lucr )
## What are the most important columns
# type description, date signed, total_obligation
# description, awarding_agency.toptier_agency.name
# recipient.recipient_name, recipient.business_types_description
# recipient.full.address
# Fast table
datatable( data = select( .data = newyork_state
                          , type_description, date_signed, total_obligation
                          , description, awarding_agency.toptier_agency.name
                          , recipient.recipient_name, recipient.business_types_description
                          , recipient.full.address
                          )
           )
# which award type_description is most popular in FY17 NY?
table( as.factor( newyork_state$type_description ) )
# ten types!
# Block Grant                           Cooperative Agreement 
# 34                                    759 
# Direct Loan                           Direct Payment for Specified Use 
# 456                                   1948 
# Direct Payment with Unrestricted Use  Formula Grant 
# 2440                                  1490 
# Guaranteed/Insured Loan               Insurance 
# 1150                                  809 
# Other Financial Assistance            Project Grant 
# 1810                                  3095 
# plot
par( mar = c(5, 15, 4, 4))
barplot( height = sort( table( as.factor( newyork_state$type_description ) ) )
         , horiz = TRUE
         , las = 1
         , main = "FY17 Award Types in New York State"
         , xlim = c(0, 4000)
         , xlab = "Award Type Frequency"
         )
# draw vertical lines
# Add vertical lines to separate the years
abline( v = c(1000, 2000, 3000, 4000)
        , col = "gray"
        , lty = 2
        )
dev.off()
##### Let's Examine Each Type of Award ####
unique.award <- sort( unique(newyork_state$type_description) )
# [1] "Block Grant"                          "Cooperative Agreement"               
# [3] "Direct Loan"                          "Direct Payment for Specified Use"    
# [5] "Direct Payment with Unrestricted Use" "Formula Grant"                       
# [7] "Guaranteed/Insured Loan"              "Insurance"                           
# [9] "Other Financial Assistance"           "Project Grant"
# 
# Create new data frames examining each type of award
#
ny_blockgrant <- newyork_state[ newyork_state$type_description == "Block Grant", ]
ny_coop_agrmt <- newyork_state[ newyork_state$type_description == "Cooperative Agreement", ]
ny_direct_loan <- newyork_state[ newyork_state$type_description == "Direct Loan", ]
ny_dpay_specif <- newyork_state[ newyork_state$type_description == "Direct Payment for Specified Use", ]
ny_dpay_unrest <- newyork_state[ newyork_state$type_description == "Direct Payment with Unrestricted Use", ]
ny_form_grant <- newyork_state[ newyork_state$type_description == "Formula Grant", ]
ny_grt_ins_loan <- newyork_state[ newyork_state$type_description == "Guaranteed/Insured Loan", ]
ny_insurance <- newyork_state[ newyork_state$type_description == "Insurance", ]
ny_oth_finaid <- newyork_state[ newyork_state$type_description == "Other Financial Assistance", ]
ny_projectgrant <- newyork_state[ newyork_state$type_description == "Project Grant", ]
  
datatable( data = select( .data = ny_blockgrant
                          , type_description, date_signed, total_obligation
                          , description, awarding_agency.toptier_agency.name
                          , recipient.recipient_name, recipient.business_types_description
                          , recipient.full.address
)
)
  
##   
  
# New York obligation
hist( newyork_state$total_obligation)
hist( newyork_state$total_obligation[ newyork_state$total_obligation >= 0])
summary(newyork_state$total_obligation[ newyork_state$total_obligation >= 0])

# Extract unique full addresses
length( newyork_state$recipient.full.address ) # 13991
unique.ny.addresses <- unique( newyork_state$recipient.full.address)
length( unique.ny.addresses ) # 2615
# start geo coding
library(ggmap)
geocodeQueryCheck() # On June 5, 1:39pm, I have 2500 queries left
# Run the geocode query!
# this means I'll manually have to find the remaining 115 geocodes
# 2500 - 2615
geocode_results <- geocode( location = unique.ny.addresses[1:2499]
                            , output = "latlon" 
) # this running...going to take a crap ton of time
# ETA 42 minutes..1:43pm - 2:25pm
# Done!
geocodeQueryCheck() # 1 geocode query remaining :0
# Add unique full address to geocode results
geocode_results$recipient.full.address <- unique.ny.addresses[1:2499]
# save as rds
saveRDS( geocode_results
         , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_export/ny_geocode_partial.rds"
         )
### Define an action button -> create a subset of whatever remains
# instead of filtering with data table
# have a sider bar that has the columns
# filter 
# Returned a search box; generate a list of chechboxes
# give me these three filters
# Make a chexk box froma  list of names...
# then use the names
# 
### Get Texas ###
texas_state <- state_api("TEXAS")
# Called at 3:25pm....let's wait....
# it is now 3:33pm...gonna wait 10 more minutes...
### Save RDS
saveRDS(texas_state
        , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_export/texas_awards_fy17.rds"
        )
#### What about Illinois!
illinois_state <- state_api("ILLINOIS")
# called at 3:43pm...waiting 3 minutes! 
# Save RDS
saveRDS( illinois_state
         , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_export/illinois_awards_fy17.rds"
         )
