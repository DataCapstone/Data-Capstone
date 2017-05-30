# 
# Author: Cristian Nuno
# Date:   May 25, 2017
# Purpose: To obtain the field choices of each endpoint for the
#          USA spending API. See here for a list of endpoints:
#          https://api.usaspending.gov/docs/endpoints
#
# Data frames of Endpoints
account.awards.df <- data.frame( endpoint = "/api/v1/accounts/awards/"
                         , brief.summary = "Financial Accounts By Award"
                         , detail.summary = "Returns a list of financial account data by treasury account symbol, program activity, object class, and award"
                         , method = "GET, POST"
                         , full.url = "https://api.usaspending.gov/api/v1/accounts/awards/"
                         , stringsAsFactors = FALSE
)
account.awards.agg.df <- data.frame( endpoint = "/api/v1/accounts/awards/total/"
                             , brief.summary = "Financial Accounts By Award Aggregate"
                             , detail.summary = "Supports aggregation on treasury account symbol/program activity/object class/award records"
                             , method = "POST"
                             , full.url = "https://api.usaspending.gov/api/v1/accounts/awards/total/"
                             , stringsAsFactors = FALSE
                             )
awards.df <- data.frame( endpoint = "/api/v1/awards/"
                             , brief.summary = "Spending data by Award (i.e. a grant, contract, loan, etc)"
                             , detail.summary = "This endpoint allows you to search and filter by almost any attribute of an award object."
                             , method = "GET, POST"
                             , full.url = "https://api.usaspending.gov/api/v1/awards/"
                             , stringsAsFactors = FALSE
)
awards.autocomplete.df <- data.frame( endpoint = "/api/v1/awards/autocomplete/"
                                      , brief.summary = "Autocomplete support for award summary objects"
                                      , detail.summary = "Supports autocomplete on award records"
                                      , method = "POST"
                                      , full.url = "https://api.usaspending.gov/api/v1/awards/autocomplete/"
                                      , stringsAsFactors = FALSE
)
awards.total.df <- data.frame( endpoint = "/api/v1/awards/total/"
                                      , brief.summary = "Award Aggregate"
                                      , detail.summary = "Supports aggregation on award records"
                                      , method = "POST"
                                      , full.url = "https://api.usaspending.gov/api/v1/awards/total/"
                                      , stringsAsFactors = FALSE
)
federal.accounts.df <- data.frame( endpoint = "/api/v1/federal_accounts/"
                               , brief.summary = "Federal Account"
                               , detail.summary = "Returns a list of federal accounts"
                               , method = "GET, POST"
                               , full.url = "https://api.usaspending.gov/api/v1/federal_accounts/"
                               , stringsAsFactors = FALSE
)
federal.accounts.autocomplete.df <- data.frame( endpoint = "/api/v1/federal_accounts/autocomplete/"
                                   , brief.summary = "Federal Account Autocomplete"
                                   , detail.summary = "Supports autocomplete on federal account records"
                                   , method = "POST"
                                   , full.url = "https://api.usaspending.gov/api/v1/federal_accounts/autocomplete/"
                                   , stringsAsFactors = FALSE
)
tas.df <- data.frame( endpoint = "/api/v1/tas/"
                      , brief.summary = "Treasury Appropriation Account"
                      , detail.summary = "Returns a list of treasury appropriation accounts (TAS)"
                      , method = "GET, POST"
                      , full.url = "https://api.usaspending.gov/api/v1/tas/"
                      , stringsAsFactors = FALSE
)
tas.autocomplete.df <- data.frame( endpoint = "/api/v1/tas/autocomplete/"
                               , brief.summary = "Treasury Appropriation Account Autocomplete"
                               , detail.summary = "Supports autocomplete on TAS records"
                               , method = "POST"
                               , full.url = "https://api.usaspending.gov/api/v1/tas/autocomplete/"
                               , stringsAsFactors = FALSE
)
tas.balances.df <- data.frame( endpoint = "/api/v1/tas/balances/"
                      , brief.summary = "Treasury Appropriation Account Balances"
                      , detail.summary = "Returns a list of appropriation account balances by fiscal year"
                      , method = "GET, POST"
                      , full.url = "https://api.usaspending.gov/api/v1/tas/balances/"
                      , stringsAsFactors = FALSE
)
tas.balances.total.df <- data.frame( endpoint = "/api/v1/tas/balances/total/"
                               , brief.summary = "Treasury Appropriation Account Balances Aggregate"
                               , detail.summary = "Supports aggregation on appropriation account records"
                               , method = "POST"
                               , full.url = "https://api.usaspending.gov/api/v1/tas/balances/total/"
                               , stringsAsFactors = FALSE
)
tas.balances.quarters.df <- data.frame( endpoint = "/api/v1/tas/balances/quarters/"
                                     , brief.summary = "Treasury Appropriation Account Balances Quarter List"
                                     , detail.summary = "Returns a list of appropriation account balances by fiscal quarter"
                                     , method = "GET, POST"
                                     , full.url = "https://api.usaspending.gov/api/v1/tas/balances/quarters/"
                                     , stringsAsFactors = FALSE
)
tas.balances.quarters.total.df <- data.frame( endpoint = "/api/v1/tas/balances/quarters/total/"
                                        , brief.summary = "Treasury Appropriation Account Balances Quarter Aggregate"
                                        , detail.summary = "Supports aggregation on quarterly appropriation account records"
                                        , method = "POST"
                                        , full.url = "https://api.usaspending.gov/api/v1/tas/balances/quarters/total/"
                                        , stringsAsFactors = FALSE
)
tas.categories.df <- data.frame( endpoint = "/api/v1/tas/categories/"
                                              , brief.summary = "Treasury Appropriation Account Category List"
                                              , detail.summary = "Returns a list of appropriation account balances by fiscal year broken up by program activities and object class"
                                              , method = "GET, POST"
                                              , full.url = "https://api.usaspending.gov/api/v1/tas/categories/"
                                              , stringsAsFactors = FALSE
)
tas.categories.total.df <- data.frame( endpoint = "/api/v1/tas/categories/total/"
                                 , brief.summary = "Treasury Appropriation Account Category Aggregate"
                                 , detail.summary = "Supports aggregation on appropriation account (by category) records"
                                 , method = "POST"
                                 , full.url = "https://api.usaspending.gov/api/v1/tas/categories/total/"
                                 , stringsAsFactors = FALSE
)
tas.categories.quarters.df <- data.frame( endpoint = "/api/v1/tas/categories/quarters/"
                                       , brief.summary = "Treasury Appropriation Account Category Quarter List"
                                       , detail.summary = "Returns a list of appropriation account balances by fiscal quarter broken up by program activities and object class"
                                       , method = "GET, POST"
                                       , full.url = "https://api.usaspending.gov/api/v1/tas/categories/quarters/"
                                       , stringsAsFactors = FALSE
)
tas.categories.quarters.total.df <- data.frame( endpoint = "/api/v1/tas/categories/quarters/total/"
                                          , brief.summary = "Treasury Appropriation Account Category Quarter Aggregate"
                                          , detail.summary = "Supports aggregation on quarterly appropriation account (by category) records"
                                          , method = "POST"
                                          , full.url = "https://api.usaspending.gov/api/v1/tas/categories/quarters/total/"
                                          , stringsAsFactors = FALSE
)
subawards.df <- data.frame( endpoint = "/api/v1/subawards/"
                                                , brief.summary = "Spending Data by Subaward"
                                                , detail.summary = "Returns a list of subaward records"
                                                , method = "GET, POST"
                                                , full.url = "https://api.usaspending.gov/api/v1/subawards/"
                                                , stringsAsFactors = FALSE
)
subawards.autocomplete.df <- data.frame( endpoint = "/api/v1/subawards/autocomplete/"
                            , brief.summary = "Spending Data by Subaward Autocomplete"
                            , detail.summary = "Supports autocomplete on subawards"
                            , method = "POST"
                            , full.url = "https://api.usaspending.gov/api/v1/subawards/autocomplete/"
                            , stringsAsFactors = FALSE
)
subawards.total.df <- data.frame( endpoint = "/api/v1/subawards/total/"
                                         , brief.summary = "Subaward Aggregate"
                                         , detail.summary = "Supports aggregation on subawards"
                                         , method = "POST"
                                         , full.url = "https://api.usaspending.gov/api/v1/subawards/total/"
                                         , stringsAsFactors = FALSE
)
transactions.df <- data.frame( endpoint = "/api/v1/transactions/"
                                  , brief.summary = "Transaction Viewset"
                                  , detail.summary = "Returns a list of transactions - contracts, grants, loans, etc."
                                  , method = "GET, POST"
                                  , full.url = "https://api.usaspending.gov/api/v1/transactions/"
                                  , stringsAsFactors = FALSE
)
transactions.total.df <- data.frame( endpoint = "/api/v1/transactions/total/"
                               , brief.summary = "Transaction Viewset Aggregate"
                               , detail.summary = "Supports aggregation on transaction records"
                               , method = "POST"
                               , full.url = "https://api.usaspending.gov/api/v1/transactions/total/"
                               , stringsAsFactors = FALSE
)
references.agency.df <- data.frame( endpoint = "/api/v1/references/agency/"
                                     , brief.summary = "Agency Endpoint"
                                     , detail.summary = "Returns a list of agency records"
                                     , method = "GET, POST"
                                     , full.url = "https://api.usaspending.gov/api/v1/references/agency/"
                                     , stringsAsFactors = FALSE
)
references.agency.autocomplete.df <- data.frame( endpoint = "/api/v1/references/agency/autocomplete/"
                                    , brief.summary = "Agency Autocomplete"
                                    , detail.summary = "Supports autocomplete on agency records"
                                    , method = "POST"
                                    , full.url = "https://api.usaspending.gov/api/v1/references/agency/autocomplete/"
                                    , stringsAsFactors = FALSE
)
references.cfda.df <- data.frame( endpoint = "/api/v1/references/cfda/"
                                                 , brief.summary = "Catalog of Federal Domestic Assistance (CFDA) Endpoint"
                                                 , detail.summary = "Returns a list of CFDA Programs"
                                                 , method = "GET, POST"
                                                 , full.url = "https://api.usaspending.gov/api/v1/references/cfda/"
                                                 , stringsAsFactors = FALSE
)
references.locations.df <- data.frame( endpoint = "/api/v1/references/locations/"
                                  , brief.summary = "Location Endpoint"
                                  , detail.summary = "Returns a list of locations - places of performance or vendor locations"
                                  , method = "POST"
                                  , full.url = "https://api.usaspending.gov/api/v1/references/locations/"
                                  , stringsAsFactors = FALSE
)
references.locations.geocomplete.df <- data.frame( endpoint = "/api/v1/references/locations/geocomplete/"
                                       , brief.summary = "Location Geo Complete Endpoint"
                                       , detail.summary = "Supports geocomplete queries, see Using the API (https://api.usaspending.gov/docs/using-the-api)"
                                       , method = "POST"
                                       , full.url = "https://api.usaspending.gov/api/v1/references/locations/geocomplete/"
                                       , stringsAsFactors = FALSE
)
references.recipients.autocomplete.df <- data.frame( endpoint = "/api/v1/references/recipients/autocomplete/"
                                                   , brief.summary = "Autocomplete support for legal entity (recipient) objects"
                                                   , detail.summary = "Supports autocomplete on recipient records"
                                                   , method = "POST"
                                                   , full.url = "https://api.usaspending.gov/api/v1/references/recipients/autocomplete/"
                                                   , stringsAsFactors = FALSE
)
submissions.df <- data.frame( endpoint = "/api/v1/submissions/"
                                                     , brief.summary = "Submission Attributes"
                                                     , detail.summary = "Returns a list of submissions"
                                                     , method = "GET, POST"
                                                     , full.url = "https://api.usaspending.gov/api/v1/submissions/"
                                                     , stringsAsFactors = FALSE
)
# 11:15am
# Now that all the endpoint information is collected
# it is time to combine them all into one big data frame
usa_spending_endpoints <- rbind.data.frame( account.awards.df
                                            , account.awards.agg.df
                                            , awards.df
                                            , awards.autocomplete.df
                                            , awards.total.df
                                            , federal.accounts.df
                                            , federal.accounts.autocomplete.df
                                            , tas.df
                                            , tas.autocomplete.df
                                            , tas.balances.df
                                            , tas.balances.total.df
                                            , tas.balances.quarters.df
                                            , tas.balances.quarters.total.df
                                            , tas.categories.df
                                            , tas.categories.total.df
                                            , tas.categories.quarters.df
                                            , tas.categories.quarters.total.df
                                            , subawards.df
                                            , subawards.autocomplete.df
                                            , subawards.total.df
                                            , transactions.df
                                            , transactions.total.df
                                            , references.agency.df
                                            , references.agency.autocomplete.df
                                            , references.cfda.df
                                            , references.locations.df
                                            , references.locations.geocomplete.df
                                            , references.recipients.autocomplete.df
                                            , submissions.df
                                            , stringsAsFactors = FALSE
                                     )
View( usa_spending_endpoints ) # View results
# Congratulations
# Now time for the real work
# 11:32am
# These endpoints are only useful if the team knows which field choices (variable names)
# are available for them to structure their queries.
#
# Let's begin!
# Creating a function that pull down field choices for each 
# USA spending endpoint
get_field_choices <- function( endpoint ) {
  # GET a url with an invalid field choice
  # Here I made up the field choice "invalid_choice" as an example
  df <- GET( url = "https://api.usaspending.gov"
             , path = endpoint
             , query = list( invalid_choice = "1234")
  )
  
  # content(): extract the content from the query
  df <- content( df )
  
  # save the message as a character vector
  df <- df$message
  
  # now for some string manipulation to get the field choices into a vector
  # Replace first few words with nothing 
  df <- gsub( pattern = "Cannot resolve keyword 'invalid_choice' into field. Choices are: "
              , replacement = ""
              , x = df
  )
  
  # split strings based on ", " into individual elements within one vector
  df <- strsplit( x = df
                  , split = ", "
                  , fixed = TRUE
  )
  
  # unlist
  df <- unlist( df )
  
  # Create a data frame which contains the unique endpoint
  # and its individual field choices AKA variables
  final.df <- data.frame( endpoint = endpoint
                          , field.choices = df
                          , stringsAsFactors = FALSE
                          )

} # end
# Success!
# 12:29pm
# Use the function to extract all the field choices
# for each unique endpoint
# The only reason I am doing this manually is because
# the repition of field choices is unknown to me at this time

account.awards.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[1] )
account.awards.total.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[2] )
awards.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[3] )
# Endpoint 4 is producing an error
awards.autocomplete.choices <- get_field_choices( usa_spending_endpoints$endpoint[4] )
######
awards.total.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[5] )
federal.accounts.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[6] )
# Endpoint 7 is producing an error
federal.accounts.autocomplete.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[7] )
#####
tas.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[8] )
# Endpoint 9 is producing an error
tas.autocomplete.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[9] )
##### I think this because the URL can only be read via POST and not GET
tas.balances.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[10] )
tas.balances.total.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[11] )
tas.balances.quarters.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[12] )
tas.balances.quarters.total.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[13] )
tas.categories.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[14] )
tas.categories.total.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[15] )
tas.categories.quarters.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[16] )
tas.categories.quarters.total.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[17] )
subwards.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[18] )
# Endpoint 19 is producing an error
subawards.autocomplete.awards.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[19] )
######
subawards.total.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[20] )
transactions.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[21] )
transactions.total.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[22] )
references.agency.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[23] )
# Endpoint 24 is producing an error
references.agency.autocomplete.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[24] )
#####
references.cfda.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[25] )
references.locations.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[26] )
# Endpoint 27 is producing an error
references.locations.geocomplete.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[27] )
####
# Endpoint 28 is producing an error
references.recipients.autocomplete.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[28] )
#####
submissions.field.choices <- get_field_choices( usa_spending_endpoints$endpoint[29] )

# 12:47pm
# The same error popped up multiple times
# It reads
# Error in data.frame(endpoint = endpoint, field.choices = df, stringsAsFactors = FALSE) : 
# arguments imply differing number of rows: 1, 0 
# The endpoints were #4, 7, 9, 19, 24, 27 28
# Going to produce a function that creates a list of field choices
# whose endpoints can only be read via the POST function
post_field_choices <- function( endpoint ) {
  # POST a url with an invalid field choice
  # Here I made up the field choice "invalid_choice" as an example
  df <- POST( url = "https://api.usaspending.gov"
             , path = endpoint
             , query = list( invalid_choice = "1234")
  )
  
  # content(): extract the content from the query
  df <- content( df )
  
  # save the message as a character vector
  df <- df$message
  
  # now for some string manipulation to get the field choices into a vector
  # Replace first few words with nothing 
  df <- gsub( pattern = "Cannot resolve keyword 'invalid_choice' into field. Choices are: "
              , replacement = ""
              , x = df
  )
  
  # split strings based on ", " into individual elements within one vector
  df <- strsplit( x = df
                  , split = ", "
                  , fixed = TRUE
  )
  
  # unlist
  df <- unlist( df )
  
  # Create a data frame which contains the unique endpoint
  # and its individual field choices AKA variables
  final.df <- data.frame( endpoint = endpoint
                          , field.choices = df
                          , stringsAsFactors = FALSE
  )
} # end function
# going to try out the new function on one of the "get_field_choices" that
# produced an error
# Endpoint 4 is up first
awards.autocomplete.field.choices <- post_field_choices( usa_spending_endpoints$endpoint[4] )
# Success! Let's repeat for the other endpoints which were producing an error
# Endpoint 7
federal.accounts.autocomplete.field.choices <- post_field_choices( usa_spending_endpoints$endpoint[7] )
#####
# Endpoint 9
tas.autocomplete.field.choices <- post_field_choices( usa_spending_endpoints$endpoint[9] )
#####
# Endpoint 19
subawards.autocomplete.field.choices <- post_field_choices( usa_spending_endpoints$endpoint[19] )
######
# Endpoint 24
references.agency.autocomplete.field.choices <- post_field_choices( usa_spending_endpoints$endpoint[24] )
#####
# Endpoint 27
references.locations.geocomplete.field.choices <- post_field_choices( usa_spending_endpoints$endpoint[27] )
####
# Endpoint 28
references.recipients.autocomplete.field.choices <- post_field_choices( usa_spending_endpoints$endpoint[28] )
#####
# Let's go ahead and try to do combine all these!
usa_spending_endpoint_field_choices <- rbind.data.frame( account.awards.field.choices
                                                         , account.awards.total.field.choices
                                                         , awards.field.choices
                                                         , awards.autocomplete.field.choices
                                                         , awards.total.field.choices
                                                         , federal.accounts.field.choices
                                                         , federal.accounts.autocomplete.field.choices
                                                         , tas.field.choices
                                                         , tas.autocomplete.field.choices
                                                         , tas.balances.field.choices
                                                         , tas.balances.total.field.choices
                                                         , tas.balances.quarters.field.choices
                                                         , tas.balances.quarters.total.field.choices
                                                         , tas.categories.field.choices
                                                         , tas.categories.total.field.choices
                                                         , tas.categories.quarters.field.choices
                                                         , tas.categories.quarters.total.field.choices
                                                         , subwards.field.choices
                                                         , subawards.autocomplete.field.choices
                                                         , subawards.total.field.choices
                                                         , transactions.field.choices
                                                         , transactions.total.field.choices
                                                         , references.agency.field.choices
                                                         , references.agency.autocomplete.field.choices
                                                         , references.cfda.field.choices
                                                         , references.locations.field.choices
                                                         , references.locations.geocomplete.field.choices
                                                         , references.recipients.autocomplete.field.choices
                                                         , submissions.field.choices
                                                         , stringsAsFactors = FALSE
)
# View the results of each endpoint's field choices
View( usa_spending_endpoint_field_choices )

# export as CSV
write.csv( usa_spending_endpoint_field_choices
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/usa_spending_endpoint_fieldchoices.csv"
           )

# it would be nice to have a description of each field choice
# Let's try!
data_dictionary <- GET( url = "https://api.usaspending.gov/docs/data-dictionary")
data_dictionary <- content( data_dictionary)
# not working!
library( rvest )
#
data_dictionary <- read_html( x = "https://api.usaspending.gov/docs/data-dictionary" )
field_description <- html_nodes( x = data_dictionary
                                 , "tr td"
                                 )
# One big 'ol character of length 1877
field_description_text <- html_text( field_description )
# Let's break this up into a dataframe of 2 variables
# One for Field Name and one for Field Description
head_fdt <- head( field_description_text )
# extract odds
odd <- head_fdt[ seq( from = 1, to = length(head_fdt), by = 2 )]
even <- head_fdt[ seq( from = 2, to = length(head_fdt), by = 2 )]
# that method works great
# But unfortunately doing that would be a disservice as not every
# html node is in a table with 3 columns
# 
# First 14 elements belong to "Type Description"
type_description <- field_description_text[1:14]
# Extract the "Type" column
td_type <- type_description[ seq( from = 1
                                  , to = length( type_description )
                                  , by = 2 )
                             ]
# Extract the "Description" column 
td_description <- type_description[ seq( from = 2
                                         , to = length( type_description )
                                         , by = 2 )
                                    ]
# make a dataframe
type_description_df <- data.frame( type = td_type
                                   , description = td_description
                                   , stringsAsFactors = FALSE
                                   )
# export as CSV
write.csv( type_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/type_description.csv"
)
# API USA Spending Data Dictionary Web Scrape to DF function
webscrape_df <- function( webscrape_vector ) {
  # extract the "field.choices" column
  field_choices_column <- webscrape_vector[ seq( from = 1
                                                 , to = length( webscrape_vector )
                                                 , by = 3
  )
  ]
  # Extract the "Type" column
  type_column <- webscrape_vector[ seq( from = 2
                                        , to = length( webscrape_vector )
                                        , by = 3
  )
  ]
  # Extract the "Description" column 
  description_column <- webscrape_vector[ seq( from = 3
                                               , to = length( webscrape_vector )
                                               , by = 3
  )
  ]
  # make data frame
  combined_df <- data.frame( field.choices = field_choices_column
                             , type = type_column
                             , description = description_column
                             , stringsAsFactors = FALSE
  )
  
} # end function
# use the function over all the vectors created to create 
# data frames related to each endpoint's data dictionary

# 15 - 98 for Awards Endpoint
awards_description <- field_description_text[15:98]
awards_description_df <- webscrape_df( awards_description )
# export as CSV
write.csv( awards_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/awards_description.csv"
)

# 99 - 182  for Transactions Endpoint
transactions_description <- field_description_text[99:182]
transactions_description_df <- webscrape_df( transactions_description )
# export as CSV
write.csv( transactions_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/transactions_description.csv"
)

# 183 - 425 for Transactions Contract data
t_contracts_description <- field_description_text[183:425]
t_contracts_description_df <- webscrape_df( t_contracts_description )
# export as CSV
write.csv( t_contracts_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/t_contracts.csv"
)

# 426 - 509 for Transactions Assistance data
t_assis_description <- field_description_text[426:509]
t_assis_description_df <- webscrape_df( t_assis_description )
# export as CSV
write.csv( t_assis_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/t_assistance.csv"
)

# 510 - 596 for Appropriation Account Balances
app_account_description <- field_description_text[510:596]
app_account_description_df <- webscrape_df( app_account_description )
# export as CSV
write.csv( app_account_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/app_account.csv"
)

# 597 - 791 for Appropriation Account by Category
app_account_category_description <- field_description_text[597:791]
app_account_category_description_df <- webscrape_df( app_account_category_description )
# export as CSV
write.csv( app_account_category_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/app_account_category.csv"
)

# 792 - 911 for Appropriation Account by Category Quarterly
app_account_category_quarterly_description <- field_description_text[792:911]
app_account_category_quarterly_description_df <- webscrape_df( app_account_category_quarterly_description )
# export as CSV
write.csv( app_account_category_quarterly_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/app_account_category_quarterly.csv"
)

# 912 - 923 for Federal Account
fed_account_description <- field_description_text[912:923]
fed_account_description_df <- webscrape_df( fed_account_description )
# export as CSV
write.csv( fed_account_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/fed_account.csv"
)

# 924 - 1010 for Treasury Account Symbol
tas_description <- field_description_text[924:1010]
tas_description_df <- webscrape_df( tas_description )
# export as CSV
write.csv( tas_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/tas.csv"
)

# 1011 - 1172 for Accounts by Award
account_awards_description <- field_description_text[1011:1172]
account_awards_description_df <- webscrape_df( account_awards_description )
# export as CSV
write.csv( account_awards_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/account_awards.csv"
)

# 1173 - 1277 for Locations
locations_description <- field_description_text[1173:1277]
locations_description_df <- webscrape_df( locations_description )
# export as CSV
write.csv( locations_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/locations.csv"
)

# 1278 - 1301 for Agency
agency_descriptions <- field_description_text[1278:1301]
agency_descriptions_df <- webscrape_df( agency_descriptions )
# export as CSV
write.csv( agency_descriptions_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/agencies.csv"
)

# 1302 - 1322 for Toptier Agency
toptier_agency_description <- field_description_text[1302:1322]
toptier_agency_description_df <- webscrape_df( toptier_agency_description )
# export as CSV
write.csv( toptier_agency_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/toptier_agency.csv"
)

# 1323 - 1340 for Subtier Agency
subtier_agency_description <- field_description_text[1323:1340]
subtier_agency_description_df <- webscrape_df( subtier_agency )
# export as CSV
write.csv( subtier_agency_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/subtier_agency.csv"
)

# 1341 - 1355 for Agency Office
agency_office_description <- field_description_text[1341:1355]
agency_office_description_df <- webscrape_df( agency_office_description )
# export as CSV
write.csv( agency_office_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/agency_office.csv"
)

# 1356 - 1484 for CFDA programs
cfda_description <- field_description_text[1356:1484]
cfda_description_df <- webscrape_df( cfda_description )
# export as CSV
write.csv( cfda_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/cfda.csv"
)

# 1485 - 1820 for Recipients 
recipients_description <- field_description_text[1485:1820]
recipients_description_df <- webscrape_df( recipients_description )
# export as CSV
write.csv( recipients_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/recipients.csv"
)

# 1821 - 1862 for Submission
submission_description <- field_description_text[1821:1862]
submission_description_df <- webscrape_df( submission_description )
# export as CSV
write.csv( submission_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/submission.csv"
)

# 1863 - 1877 for Definition
definition_description <- field_description_text[1863:1877]
definition_description_df <- webscrape_df( definition_description )
# export as CSV
write.csv( definition_description_df
           , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_dictionary/definition.csv"
)

# 21 data dictionary data frames were created
