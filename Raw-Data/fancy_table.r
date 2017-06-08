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
  , colnames = c("County Name", "Total Federal Funding Received", "Total Per Capita Federal Funding")
  , options = list(lengthChange = FALSE)
  ) %>% # end of creating datatable
   formatCurrency(columns = c("federal_funding", "funding_per_capita"))
