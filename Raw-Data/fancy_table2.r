#
# Author:   Cristian Nuno
# Date:     June 13, 2017
# Purpose:  Datatable Creative, Part II
#
#
# Load necessary packages
library( DT )
library( magrittr )
library( dplyr )

# Create the data table
fancy_table2 <- datatable( gra16.4
                         , rownames = FALSE
                         , caption = "FY16 Federal Spending Project Details"
  , colnames = c("County Name", "Total Federal Grant Funding Received"
                 , "Assistance Type" , "Agency Name"
                 , "Recipient Name", "Recipient Type"
                , "CFDA Program Title"
                )
  , filter = 'top'
  , escape = FALSE
  , selection = 'none'
  , rownames = FALSE
  , extensions = c("FixedHeader", "Buttons")
  , options = list(lengthChange = FALSE
                       , searchHighlight = TRUE
                       , scrollX = TRUE
                       , autoWidth = TRUE
                       , dom = "Blfrtip"
                       , buttons = list('copy'
                                         , list(extend = 'collection',
                                                buttons = c('csv', 'excel', 'pdf'),
                                                 text = 'Export Data'
                                                  )
                                       )
                       , colReorder = list( realtime = FALSE )
                       , scrollY = TRUE
                       , pageLength = 50
  ) %>% # end of creating datatable
   formatCurrency(columns = "federal_funding" )
    
    
    
    
    
    # edit fancy table 2
    #gra16.4 <- filter(gra16.3, county %in% input$your_county, assistance_type == "04: Project grant", fed_funding_amount > 0, recip_cat_type == input$recipient, maj_agency_cat == input$maj) 
    
   #gra16.5 <- gra16.4[c("county" , "fed_funding_amount" , "assistance_type", "agency_name",  "recipient_name", "recip_cat_type", "cfda_program_title")]

   #colnames(gra16.5) <- c("County", "Total Federal Funding", "Assistance Type", "Agency Name", "Recipient Name", "Recipient Type", "CFDA Program Title")

   #gra16.5  %>% formatCurrency(columns = "fed_funding_amount")
   # gra16.4
