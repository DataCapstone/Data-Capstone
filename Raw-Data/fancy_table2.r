    
    
    
    
    
    
    # edit fancy table 2
    gra16.4 <- filter(gra16.3, county %in% input$your_county, assistance_type == "04: Project grant", fed_funding_amount > 0, recip_cat_type == input$recipient, maj_agency_cat == input$maj) 
    
   #gra16.5 <- gra16.4[c("county" , "fed_funding_amount" , "assistance_type", "agency_name",  "recipient_name", "recip_cat_type", "cfda_program_title")]

   #colnames(gra16.5) <- c("County", "Total Federal Funding", "Assistance Type", "Agency Name", "Recipient Name", "Recipient Type", "CFDA Program Title")

   #gra16.5  %>% formatCurrency(columns = "fed_funding_amount")
    gra16.4
