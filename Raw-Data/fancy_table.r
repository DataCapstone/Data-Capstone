#
# Author:   Cristian Nuno
# Date:     June 7, 2017
# Purpose:  Datatable Creative
#
#
# Load necessary packages
library( DT )
library( magrittr )
library( dplyr )

# Create the data table
fancy_table <- datatable( select( ny_counties@data
                                  , county_name
                                  , federal_funding
                                  , funding_per_capita
)
  , rownames = FALSE
  , caption = "FY16 New York County Total Federal Grant Funding"
  , colnames = c("County Name", "Total Federal Grant Funding Received", "Total Per Capita Federal Grant Funding Received")
  , options = list(lengthChange = FALSE)
  ) %>% # end of creating datatable
   formatCurrency(columns = c("federal_funding", "funding_per_capita"))
