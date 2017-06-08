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
################# Importing External Objects ##############
# Import leaflet
leaflet_url <- "https://raw.githubusercontent.com/DataCapstone/Data-Capstone/master/Raw-Data/leaflet_ny.r"
source_github( leaflet_url )

# Import table
fancy_table_url <- "https://raw.githubusercontent.com/DataCapstone/Data-Capstone/master/Raw-Data/fancy_table.r"
source_github( fancy_table_url )

# import donuts
ig_url <- "https://raw.githubusercontent.com/DataCapstone/Data-Capstone/master/Ignacio/donutzz.R"
source_github(ig_url)

############ Building the Dashboard##################

# A dashboard has 2 parts: a user-interface (ui) and a server

# The UI consists of a header, a sidebar, and a body.

# The server consists of functions that produce any objects
# that are called inside the UI

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
                     , DT::dataTableOutput("tbl")
                        ) # end of column 1
              , column( width = 8
                        , leafletOutput("mymap", height=600)
                        ) # end of column 2
              ) # end of row 1
            , h3("Let's Examine Which Federal Agencies Are Distributing Funds\nand What Type of Organizations are Receiving these Funds.\n Please note that these funds do not include the federal grants which were awarded to the state government.") # blank space
            , fluidRow(
              column( width = 6
                , box( title = "Percentage of Total Federal Funds by Federal Agency", status = "primary",
                     solidHeader = TRUE, collapsible = FALSE, width = NULL
                     #, background = "fuchsia"
                     , shiny::plotOutput("donut1") ) # end of box 1
                      ) # end of column 1
              , column( width = 6
                        , box( title = "Percentage of Total Federal Funds by Recipient Type", status = "primary",
                               solidHeader = TRUE, collapsible = FALSE, width = NULL
                               #, background = "maroon"
                               , shiny::plotOutput("donut2") ) # end of box 2
                      ) # end of column 2
              
            ) # end of row 2
            
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
#################################################################
######################## Building the Server ####################
##########aka the Infrastructure of the User Interface ##########
#################################################################
server <- function(input, output) {
  ######################################
  #### State Overview Leaflet Output####
  ######################################
  
  #### If statement for Dynamic Leaflet Legend ####
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
  
  #### State Overview Datatable Output ####
  # Render the data table
  output$tbl <- DT::renderDataTable({
    fancy_table
    
  }) # end of render datatable
  
  #### State Overview Donut1 Plot Output ####
  # Render Donut1 Plot
  output$donut1 <- shiny::renderPlot(
    maj_agency_donut
  )
  #### State Overview Donut2 Plot Output ####
  # Render Donut2 Plot
  output$donut2 <- shiny::renderPlot(
    recipient_cat_donut
  )

} # end of server

## call the Shiny App ##
shinyApp(ui, server)
