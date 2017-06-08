#
# Date:     June 8, 2017
# Purpose:  Draft Dashboard
#
# Load necessary packages
library( shiny )
library( shinydashboard )

# Import data from github function
source_github <- function( url ) {
  # load package
  require(RCurl)
  
  # read script lines from website and evaluate
  script <- getURL(url, ssl.verifypeer = FALSE)
  eval(parse(text = script), envir=.GlobalEnv)
} 
# Import leaflet
leaflet_url <- "https://raw.githubusercontent.com/DataCapstone/Data-Capstone/master/Raw-Data/leaflet_ny.r"
source_github( leaflet_url )
# Import table
fancy_table_url <- "https://raw.githubusercontent.com/DataCapstone/Data-Capstone/master/Raw-Data/fancy_table.r"
source_github( fancy_table_url )
# A dashboard has three parts: a header, a sidebar, and a body. 
# Here’s the most minimal possible UI for a dashboard page.

## customize header ##
header <- dashboardHeader(title = "FY16 New York"
                          #, titleWidth = 200
                  # ,  # Dropdown menu for messages
                  # dropdownMenu(type = "messages", badgeStatus = "success",
                  #              messageItem("Support Team",
                  #                          "This is the content of a message.",
                  #                          time = "5 mins"
                  #              )
                  # )
  )
## customize sidebar ##
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("State Overview", tabName = "State", icon = icon("dashboard")),
    menuItem("County Overview", tabName = "County", icon = icon("th"))
)
)

## customize body ##
body <- dashboardBody(
  # initialize tabs
  tabItems(
  # First tab content
  tabItem(tabName = "State"
  , fluidRow(
    column(width = 4
           , DT::dataTableOutput('tbl')
           )
    , column( width = 8
              , leafletOutput('mymap', height=600)
              )
) )
, # Second tab content
tabItem(tabName = "County"
        , h2("Hello!")
)
) # end of Tab Items
) # end of dasboard body

## Shiny UI ##
ui <- dashboardPage(
  header
  , sidebar
  , body
)

## server ##
server <- function(input, output) {
  
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
    
  }) # end of render map
  
  # Create the data table
  output$tbl <- DT::renderDataTable({
    fancy_table
    
  }) # end of render datatable


} # end of server

## call the Shiny App ##
shinyApp(ui, server)
