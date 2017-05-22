#
# Author: Cristian Nuno
# Purpose: Using APIs in R
# Date: May 21, 2017
#
# Summary: Trying to delve into fetching data via APIs. 
#          For more information, please see these two links:
#          "Accessing APIs from R" - https://www.r-bloggers.com/accessing-apis-from-r-and-a-little-r-programming/
#          "USA Spending API endpoints" - https://api.usaspending.gov/docs/endpoints
#
# load necessary packages
library( httr )
library( jsonlite )
library( lubridate )
library( rgdal )

# fetch url
url <- "https://api.usaspending.gov/"
path <- "api/v1/accounts/awards/"

# Executing an API call with the GET flavor 
# is done using the GET() function.
raw.result <- GET(   url = url
                  , path = path
                  )
# Ensure a status code of 200 is attained
# In general, status codes returned are as follows:
# 200 if successful
# 400 if the request is malformed
# 500 for server-side errors
# For more information, see this WikiPedia page on the 
# list of HTTP codes: https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
raw.result$status_code # 200

# Let’s look at the actual answer or data payload we’ve got back. 
# Let’s just look at the first few elements:
head( raw.result$content ) # unicode 

# Let’s translate that into text.
this.raw.content <- rawToChar(raw.result$content)

# Let’s see how large that is in terms of characters:
nchar(this.raw.content) #98,334

# That’s rather large. Let’s look at the first 100 characters:
substr(this.raw.content, 1, 100) # json format

# So the result is a single character string that contains a JSON file.
# Let’s tell R to parse it into something R can work with.
this.content <- fromJSON(this.raw.content)

# What did R make out of it?
class(this.content) #it's a list
length( this.content ) # length of 3

# Peak inside each element within the list
this.content[[1]] # page
this.content[[2]] # unique page identifier
this.content[[3]] # financial information 

# So, essentially, the result is a list of lists. 
# Lists are not (always) very nice to work with, and 
# lists of lists are usally despicable. 
#
# Let’s turn it into a data frame:
this.content.df.main <- as.data.frame( this.content[[3]] )
this.content.df.main$treasury_account <- NULL # delete treasury account df
this.content.df.main$object_class <- NULL # delete object class df

this.content.treasury.account <- as.data.frame( this.content[[3]]$treasury_account )
this.content.object.class <- as.data.frame( this.content[[3]]$object_class )


# This is very nested and very complicated dealing with JSON format
dod.fy17 <- read.csv( file = "/Users/cristiannuno/Python_All/dod_example_fy17.csv"
                      , header = TRUE
                      , stringsAsFactors = FALSE
)
# install.packages("tidyjson")
library( tidyjson)
library( dplyr )
library( jsonlite )
# after doing str(dod.fy17), the following JSON formats have been identified as variables
# $ awarding_agency
dod.fy17$awarding_agency[1]
# "{'office_agency': None, 
#                   'subtier_agency': {'abbreviation': '', 'subtier_code': '97AS', 'name': 'Defense Logistics Agency'}, 
# 'toptier_flag': False, 'id': 1180, 'toptier_agency': {'cgac_code': '097', 'fpds_code': '9700', 'abbreviation': 'DOD', 'name': 'Department of Defense'}
# }"
clean_award_agency <- fromJSON( readLines( dod.fy17$awarding_agency)
                                , simplifyVector = TRUE
                                )
# Continue to get an error!
library(devtools)
install_github("jeroenooms/jsonlite")
lol <- as.data.frame( dod.fy17$awarding_agency )
lol.v2 <- fromJSON( lol, simp)
# $ funding_agency
dod.fy17$funding_agency[1]
# "{'office_agency': None, 'subtier_agency': {'abbreviation': '', 'subtier_code': '97AS', 'name': 'Defense Logistics Agency'}
# , 'toptier_flag': False, 'id': 1180, 'toptier_agency': {'cgac_code': '097', 'fpds_code': '9700', 'abbreviation': 'DOD', 'name': 'Department of Defense'}}
#
# $ place_of_performance
dod.fy17$place_of_performance[1]
# "{'state_name': None, 'foreign_province': None, 'location_country_code': 'USA'
# , 'address_line3': None, 'foreign_city_name': None, 'state_code': 'NJ', 'zip5': None, 'country_name': 'UNITED STATES', 'foreign_postal_code': None, 'address_line1': None, 'address_line2': None, 'city_name': None}"
# $ recipient
dod.fy17$recipient[1]
# "{'legal_entity_id': 871, 'parent_recipient_unique_id': None, 'recipient_name': 'LOCKHEED MARTIN CORPORATION'
# , 'business_types_description': 'Unknown Types', 'business_types': None
# , 'location': {'state_name': None, 'foreign_province': 'BC', 'location_country_code': 'USA'
# , 'address_line3': None, 'foreign_city_name': None, 'state_code': 'NJ'
# , 'zip5': None, 'country_name': 'UNITED STATES', 'foreign_postal_code': None
# , 'address_line1': '199 BORTON LANDING RD', 'address_line2': None, 'city_name': 'MOORESTOWN'}}"

purch_json <- '
[
  {
  "name": "bob", 
  "purchases": [
  {
  "date": "2014/09/13",
  "items": [
  {"name": "shoes", "price": 187},
  {"name": "belt", "price": 35}
  ]
  }
  ]
  },
  {
  "name": "susan", 
  "purchases": [
  {
  "date": "2014/10/01",
  "items": [
  {"name": "dress", "price": 58},
  {"name": "bag", "price": 118}
  ]
  },
  {
  "date": "2015/01/03",
  "items": [
  {"name": "shoes", "price": 115}
  ]
  }
  ]
  }
  ]'