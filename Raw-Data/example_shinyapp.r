#
# Author:   Cristian Nuno
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
    menuItem("Introduction", tabName = "Introduction", icon = icon("home"))
    , menuItem("Use Case", tabName = "Use", icon = icon("briefcase"))
    , menuItem("State Overview", tabName = "State", icon = icon("search"))
    , menuItem("County Overview", tabName = "County", icon = icon("bar-chart"))
)
)

## customize body ##
body <- dashboardBody(
  # initialize tabs
  tabItems(
  # First tab content
    tabItem( tabName = "Introduction"
             , h1("Welcome to the Introduction")
             , h2("Introduction tab content")
             )
    # second tab content
    , tabItem( tabName = "Use"
             , h1("Welcome to the Use Case")
             , h2("Use Case tab content")
             )
    # third tab content
  , tabItem(tabName = "State"
            , h1("Welcome to the State Overview")
            , h2("State Overview tab content")
            , fluidRow(
              column(width = 4
              , DT::dataTableOutput('tbl')
                        ) # end of column 1
              , column( width = 8
                        , leafletOutput('mymap', height=600)
                        ) # end of column 2
              ) # end of row 1
            
            ) # end of third tab
, # Fourth tab content
tabItem(tabName = "County"
        , h1("Welcome to the County Overview")
        , h2("County Overview tab content")
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
