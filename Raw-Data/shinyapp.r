#
# Author:   Cristian Nuno
# Date:     June 7, 2017
# Purpose:  Using Shiny + Leaflet for FY16 NY Federal Spending
#
# Load necessary packages
library( leaflet )
library( magrittr )
library( htmltools )
library( htmlwidgets )
library( geojsonio )
library( scales )
library( shiny )

# Import data from github function
source_github <- function( url ) {
  # load package
  require(RCurl)
  
  # read script lines from website and evaluate
  script <- getURL(url, ssl.verifypeer = FALSE)
  eval(parse(text = script), envir=.GlobalEnv)
} 

# Import data!
leaflet_url <- "https://raw.githubusercontent.com/DataCapstone/Data-Capstone/master/Raw-Data/leaflet_ny.r"
source_github( leaflet_url )

# Make the shiny app!
ui <- fluidPage( 
  h1("FY16 New York Federal Awards Received by County", align = "center")
  , h2("At first glance, it appears that counties with universities receive the most federal awards.\n
       However, accounting for population, the trend changes"
       )
  , leafletOutput('mymap', height=600)
  , h2("See more graphics, down below!")
)

server <- function(input, output, session) {
  
  observeEvent(input$mymap_groups,{
    
    mymap <- leafletProxy("mymap") %>% clearControls()
    
    if (input$mymap_groups == "Total Spending")
    {mymap <- mymap %>% addLegend("bottomleft"
                                      , pal = pal # use the same color palette we made earlier
                                      , values = ny_counties$federal_funding # assign values to the legend
                                      , title = "Total Federal Grant Spending"
                                      , labFormat = labelFormat(prefix = "$")
                                      , opacity = 1
    )} # end of if statement
    else if (input$mymap_groups == "Per Capita Spending")
    {mymap <- mymap %>% addLegend("bottomleft"
                                    , pal = pal_pc # use the same color palette we made earlier
                                    , values = ny_counties$funding_per_capita # assign values to the legend
                                    , title = "Per Capita Federal Grant Spending"
                                    , labFormat = labelFormat(prefix = "$")
                                    , opacity = 1
    ) } # end of else if statement
    }
    ) # end of observe event
  
  # Render the map
  output$mymap <- renderLeaflet({
    ny_map
  })
} # end of server

# run shiny app
shinyApp( ui, server)
