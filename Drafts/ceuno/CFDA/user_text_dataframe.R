#
# Author:     Cristian Nuno
# Date:       June 4, 2017
# Purpose:    User-input text to
#             customize data frame

# Load necessary packages
library( DT )
rds_url <- "https://github.com/DataCapstone/Data-Capstone/blob/master/Drafts/ceuno/CFDA/cfda_keywords.rds?raw=true"
cfda <- readRDS( gzcon(url( rds_url ) ) ) # three seconds to upload
###

# Make a shiny app where a user can filter the data frame
# based on the amount of string matches
# that relate to their user-input text
datatable(data = cfda
          , caption = "Catalog of Federal Domestic Assistance (CFDA) Programs"
          , rownames = FALSE
          , extensions = c("Buttons"
                           , "Responsive"
                           , "KeyTable"
                           , "FixedHeader"
                           , "ColReorder"
                           )
          , options = list( keys = TRUE
                            , fixedHeader = TRUE
                            , dom = "Bfrtip"
                            , buttons = c("copy", "csv"
                                          , "excel", "pdf"
                                          , "print"
                                          )
                            , colReorder = list( realtime = FALSE )
                            )
           )
# # Define url
other_rds_url <- "https://github.com/DataCapstone/Data-Capstone/blob/master/Drafts/ceuno/cfda_program_info.rds?raw=true"
# Import .rds url
cfda_program_simple <- readRDS( gzcon(url( other_rds_url ) ) )
datatable(data = cfda_program_simple
          , caption = "Catalog of Federal Domestic Assistance (CFDA) Programs"
          , rownames = FALSE
          , extensions = c("Buttons"
                           , "Responsive"
                           , "KeyTable"
                           , "FixedHeader"
                           , "ColReorder"
          )
          , options = list( keys = TRUE
                            , fixedHeader = TRUE
                            , dom = "Bfrtip"
                            , buttons = c("copy", "csv"
                                          , "excel", "pdf"
                                          , "print"
                            )
                            , colReorder = list( realtime = FALSE )
          )
)
# server side processing Example
employee = data.frame(
  `First name` = character(), `Last name` = character(), Position = character(),
  Office = character(), `Start date` = character(), Salary = numeric(),
  check.names = FALSE
)
datatable(employee, rownames = FALSE, options = list(
  ajax = list(
    serverSide = TRUE, processing = TRUE,
    url = 'http://datatables.net/examples/server_side/scripts/jsonp.php',
    dataType = 'jsonp'
  )
))
# server side processing My Turn
keywords <- data.frame( `Program Name` = character()
                        , `Program Title` = character()
                        , `Popular Name` = character()
                        , Objectives = character()
                        , `Website Address` = character()
                        , Keyword = character()
                        , check.names = FALSE
                        , stringsAsFactors = FALSE
                        )
datatable( keywords, rownames = FALSE, options = list(
  ajax = list(
    serverSide = TRUE
    , processing = TRUE
    , url = "https://github.com/DataCapstone/Data-Capstone/blob/master/Drafts/ceuno/CFDA/cfda_keywords.rds?raw=true"
    , dataType = "rds"
  )
)) # Error! No such thing as rds server side processing :/ 
