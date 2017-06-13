

library(dplyr)
library(igraph)
library(rCharts)
library(networkD3)
library(shiny)


# Download the data, clean
gra16.named <- readRDS(gzcon(url("https://github.com/DataCapstone/Data-Capstone/blob/master/Raw-Data/NYgra16_counties_named.rds?raw=true")))

#codes <- read.csv("https://raw.githubusercontent.com/DataCapstone/Data-Capstone/master/Raw-Data/countycodesNY.csv")

#exclude money going to state government and choose only project grants
gra16.without.state <- dplyr::filter( gra16.named , recipient_type != "00: State government" )

gra16.2 <- mutate(gra16.without.state, county = as.character(Name))

#note, changed from agency_name with 72 options to maj_agency_cat with 26!, also dropped columns I didn't need
gra16.3 <- gra16.2[ c("recip_cat_type", "county" , "fed_funding_amount" ,  "maj_agency_cat", "assistance_type" ) ]

x <- gra16.3$recip_cat_type == "i: Private agencies"
gra16.3$recip_cat_type[x] <- "f: Private agencies"

y <- gra16.3$recip_cat_type == "h: Government"
gra16.3$recip_cat_type[y] <- "h: Private agencies"

#making recip_cat_type into a factor and changing the levels into more friendly ones
gra16.3$recip_cat_type <- factor(x= gra16.3$recip_cat_type)

levels(gra16.3$recip_cat_type) <- c("Private firms",
                                    "Government",
                                    "Higher Ed",
                                    "Nonprofit agencies",
                                    "Other")

# clean agency names a bit to be more consistent
simpleCap <- function(x) {
  s <- tolower(x)
  s <- strsplit(s, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}

gra16.3$maj_agency_cat <-sapply(gra16.3$maj_agency_cat, simpleCap)

gra16.3$maj_agency_cat<-gsub( "Department Of ", "", as.character(gra16.3$maj_agency_cat), n)

gra16.3$maj_agency_cat<-(substring(gra16.3$maj_agency_cat, 7, nchar(gra16.3$maj_agency_cat)))




#Function for ordering data into usable form for sankey plots, returns data frame which can be used in sanktifyPlot
#Labels all agencies below the top 10 funders as other
sankeyPrep = function( df ){
  
  # choose desired columns, filter for postive outlays only
  gra16.sankey <- df[c("maj_agency_cat", "recip_cat_type", "fed_funding_amount")]
  
  gra16.sankey <- dplyr::filter(gra16.sankey, fed_funding_amount > 0)
  
  # create a vector of the 10 most common 
  gra16.sankey.agencies.1 <- aggregate(gra16.sankey$fed_funding_amount, by= list( gra16.sankey$maj_agency_cat ), FUN = sum  )
  gra16.sankey.agencies.2 <- arrange(gra16.sankey.agencies.1, desc(x))[1:10, ]$Group.1
  
  #aggregate by agency and recipient
  gra16.sankey.2 <- aggregate(gra16.sankey$fed_funding_amount, by= list( gra16.sankey$maj_agency_cat , gra16.sankey$recip_cat_type ), FUN = sum  )
  colnames(gra16.sankey.2) <- c("maj_agency_cat", "recip_cat_type", "fed_funding_amount")
  
  #label agencies not in top 10 as other, reaggregate to collapse other category
  gra16.sankey.3 <- mutate(gra16.sankey.2 , maj_agency_cat = ifelse( maj_agency_cat %in% gra16.sankey.agencies.2 , maj_agency_cat, "Other Agencies" ) )
  gra16.sankey.4 <- aggregate(gra16.sankey.3$fed_funding_amount, by= list( gra16.sankey.3$maj_agency_cat , gra16.sankey.3$recip_cat_type ), FUN = sum  )
  
  #rename for sankey function
  colnames(gra16.sankey.4) <- c("source", "target", "value")
  
  return(gra16.sankey.4)
  
}



# The function used to create the plots
sanktify <- function(x) {
  
  x$source <- as.character( x$source )
  x$target <- as.character( x$target )
  
  # Create nodes DF with the unique sources & targets from input
  
  nodes <- data.frame(unique(c(x$source,x$target)),stringsAsFactors=FALSE)
  
  nodes$ID <- as.numeric(rownames(nodes)) - 1 # sankeyNetwork requires IDs to be zero-indexed
  names(nodes) <- c("name", "ID")
  
  # use dplyr join over merge since much better; in this case not big enough to matter
  # Replace source & target in links DF with IDs
  links <- inner_join(x, nodes, by = c("source"="name")) %>%
    rename(source_ID = ID) %>%
    inner_join(nodes, by = c("target"="name")) %>%
    rename(target_ID = ID) 
  
  # Create Sankey Plot
  sank <- sankeyNetwork(
    Links = links,
    Nodes = nodes,
    Source = "source_ID",
    Target = "target_ID",
    Value = "value",
    NodeID = "name",
    units = "USD",
    fontSize = 12,
    nodeWidth = 30
  )
  
  return(sank)
  
}







ui <- fluidPage(
  
  selectInput( inputId='your_county', 
               label = "Pick a county",
               choices= sort(unique(gra16.3$county)),
               selected=c("Onondaga")
  ),
  
  sankeyNetworkOutput( "sankey" )
  
) # end of ui



server <- function( input, output ) {
  
  
  
  output$sankey <- renderSankeyNetwork({
    
    
    df <- dplyr::filter( gra16.3, county == input$your_county )
    
    df.2 <- sankeyPrep(df)
    
    sanktify( df.2 )
    
  })
  
}

shinyApp(ui= ui , server = server)


