#
# Author:   Linnea Powell, Stephanie Wilcoxen, 
#           Ignacio Pezo, and Cristian Nuno
# Purpose:  Draft Dashboard
#

# Load necessary packages
# library( Cairo )
library( shiny )
library( shinydashboard )
library(ggthemes)

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

# import county overview 
co_url <- "https://raw.githubusercontent.com/DataCapstone/Data-Capstone/master/Raw-Data/county_comparison_2.R"
source_github(co_url)

# load the donutzz function using the RAW link
census_url <- "https://raw.githubusercontent.com/icps86/Functions/master/krzycensuz.r"
source_github( census_url )

# normalized census
NYcen_norm <- readRDS( gzcon(url("https://github.com/DataCapstone/Data-Capstone/blob/master/Raw-Data/NYcen_norm.RDS?raw=true")))

# import small multiples aggregated data
agg_url <- "https://raw.githubusercontent.com/DataCapstone/Data-Capstone/master/Linnea/small%20multiples%20aggregated%20data.R"
source_github(agg_url)

############ Building the Dashboard##################

# A dashboard has 2 parts: a user-interface (ui) and a server

# The UI consists of a header, a sidebar, and a body.

# The server consists of functions that produce any objects
# that are called inside the UI

## customize header ##
header <- dashboardHeader(title = "FY16 New York"
                          , tags$li( a( href = "https://www.maxwell.syr.edu/deans/"
                                        , img( src = "https://www.maxwell.syr.edu/uploadedimages/deans/branding/SUMaxSigWM.allW.png"
                                               , title = "Maxwell School Homepage", height = "30px")
                                        , style = "padding-top:10px; padding-bottom:10px;")
                                     , class = "dropdown"
                          ) # end of Maxwell Logo
                          , tags$li(a(href = "https://github.com/DataCapstone/Data-Capstone"
                                      , img( src = "https://github.com/DataCapstone/Data-Capstone/raw/10b7bdc7876d446aba3ddf6dd8dc080744fd4309/Raw-Data/GitHub_Logo.png"
                                             , title = "Fork Me on GitHub", height = "30px")
                                      , style = "padding-top:10px; padding-bottom:10px;")
                                    , class = "dropdown"
                          ) # end of GitHub logo
) # end of header
## customize sidebar ##
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Use Case", tabName = "Use", icon = icon("briefcase"))
    , menuItem("State Overview", tabName = "State", icon = icon("search"))
    , menuItem("County Overview", tabName = "County", icon = icon("bar-chart"))
  )
)

## customize body ##
body <- dashboardBody(
  # initialize tabs
  tabItems(
    # First tab content
    tabItem( tabName = "Use"
             , h1("Welcome to the Use Case")
             , h2("User:")
             , shiny::p("State-level official creating a report of federal funding received by county.")
             , h2("Interest:")
             , shiny::p("An employee in the New York state economic development office wants to generate a report of federal spending in New York state broken down by per capita spending in each county. Their goal is to better understand federal funding structure and come up with insights about why funding patterns vary across counties. Specifically, the user will focus on project grant activity within each county with the long term goal of helping counties compete more successfully for additional federal funding, which means winning more project grants. The user will generate a dashboard to display their analysis and use it as a tool for their continuing research.")
             , h2("Steps:")
             , h3("1. Gather Data")
             , shiny::p("The user begins by", a(" downloading data"
                                         , href = "https://www.usaspending.gov/DownloadCenter/Pages/DataDownload.aspx"
             ) # end of hyperlink
             , " on FY2016 grants in New York state with the following selections:"
             , br()
             , img( src = "https://github.com/DataCapstone/Data-Capstone/raw/35fa7a046b52fd7204a2b87ed38f79e207cdac90/Raw-Data/Screen%20Shot%202017-06-09%20at%202.13.57%20PM.png"
                    , height = 400, width = 700
             ) # end of screenshot
             ) # end of long paragraph
             , h3("2. Use Data")
             , h4(em("General Picture of NY Federal Funding"))
             , shiny::p("Initially, the user wants to develop a general picture of federal funding in New York state - both in terms of total funding and per capita funding in each county. To do this, they create a data table and map. They exclude all funding going to the New York state government because those funds will likely be redistributed to localities by the state. They then aggregate federal funding amount by county. Finally, they bring in population data on each county using the Census API in order to generate per capita funding. From this map they are able to identify counties they would be interested in comparing. Additionally, the user wants to understand where is funding coming from and who is receiving for the State of NY. To have a better idea of this, they create two donut charts by aggregating the money by funding agency and recipient type.")
             , h4(em("Examine Federal Grants"))
             , shiny::p("After establishing a general picture of funding in New York, the user hopes to compare what kind of federal funding exists within each county. They choose counties based on their own knowledge or county demographics. First, they examine how much of the federal funding going to each county is in the form of project grants (because these awards are assigned through an open competitive process). They use the variable assistance type to hone in on spending from project grants versus spending from other types of grants such as block or formula grants. They assume that counties who have a large amount of their funding coming from project grants are successfully finding and applying for competitive opportunities while counties with low project grant funding may be missing out on potential awards. The next step is to drill down the analysis for a better understanding of these awards.")
             , h4(em("Examine Recipients of Federal Funding"))
             , shiny::p("Next, they compare the recipients of project grants within each county and determine which agencies are funding those recipients. For this part of their analysis they only look at positive outlays of funding because they are primarily interested in counties which are bringing in funds. To consider project grants going to different sectors within each county, the user works with the variable recipient category type. They focus on recipients because a county may appear to have much of its funding coming from project grants, but those grants may be going almost exclusively to one type of institution.")
             , h4(em("Examine Agencies Spending Federal Funds"))
             , shiny::p("The user next identifies the primary agencies funding project grants for each recipient within the counties of interest. To do this they use the agency identifier. They now have a much fuller picture of what kinds of institutions are successfully winning federal funding within each county, and can thus tailor any further action to the particular deficiencies or strengths of each county’s federal funding portfolio. The user generates a dashboard report to display their analysis.")
    ) # end of first tab customization
    
    # second tab content
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
                column( width = 2
                        , box( title = "County Exploration", status = "primary"
                               , solidHeader = TRUE, collapsible = FALSE, width = NULL
                               , selectizeInput(
                                 inputId='county',
                                 label='Select a county:',
                                 choices= sort(unique(gra16.3$county)),
                                 selected=c("Onondaga")
                               ) ) # end of box 1
                ) # end of column 1
                , column( width = 10
                          , box( title = "Flow of Funds from the Top 10 Agencies in County", status = "primary",
                                 solidHeader = TRUE, collapsible = FALSE, width = NULL
                                 , sankeyNetworkOutput( "sankey" ) ) # end of box 2
                ) # end of column 2
                
              ) # end of row 2
              
    ) # end of second tab
    , # Third tab content
    tabItem(tabName = "County"
            , h1("Welcome to the County Overview")
            , h2("County Overview tab content")
            , fluidRow(
              column( width = 2
                      , box( title = "County Comparison", status = "primary"
                             , solidHeader = TRUE, collapsible = FALSE, width = NULL
                             , selectizeInput(
                               inputId='your_county', 
                               label='Select up to 4 counties to compare:', 
                               choices= sort(unique(gra16.3$county)),
                               selected=c("Onondaga"), 
                               multiple = TRUE, 
                               options = list(maxItems = 4)
                             ) ) # end of box 1
              ) # end of column 1
              , column( width = 5
                        , box( title = "Per Capita Plot", status = "primary"
                               , solidHeader = TRUE, collapse = FALSE, width = NULL
                               , shiny::plotOutput("percapPlot")
                        ) # end of box 2
              ) # end of column 2
              , column( width = 5
                        , box( title = "County Demographics (2015 ACS 5-Year Estimates)"
                               , status = "primary"
                               , solidHeader = TRUE, collapse = FALSE, width = NULL
                               , shiny::plotOutput("censusPlot")
                        ) # end of box 3
              ) # end of column 3
            ) # end of row 1
            , fluidRow(
              column( width = 12
                      , box( title = "Federal Project Grant Funding by County, Agency, and Recipient"
                             , status = "primary", solidHeader = TRUE, collapse = FALSE
                             , width = NULL
                             , shiny::plotOutput("smallMultiples")
                      ) # end of box 4
              ) # end of column 4
            ) # end of row 2
            , fluidRow(
              column( width = 12
                      , box( title = "Federal Spending Details", status = "primary"
                             , solidHeader = TRUE, collapsible = FALSE, width = NULL
                             , DT::dataTableOutput("cfdaTable")
                      ) # end of box 7
              ) # end of column 7
            ) # end of row 4
    ) # end of Tab Item
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
  
  
  
  output$sankey <- renderSankeyNetwork({
    
    
    df <- dplyr::filter( gra16.3, county == input$county )
    
    df.2 <- sankeyPrep(df)
    
    sanktify( df.2 )
    
  })
  #######################################
  #### County Overview Shiny Elements####
  #######################################
  
  #Percapita bar plot  
  output$percapPlot <- shiny::renderPlot({
    
    
    gra16.4 <- filter(gra16.3 , county %in% input$your_county )
    
    pop.filtered <- filter(population , county.name %in% input$your_county )
    
    gra16.4.2 <- mutate(gra16.4 , assistance_type.2 = ifelse( assistance_type == "04: Project grant", "Project Grants" , "Other Grants" ) )
    
    gra16.agg <- agg.county.percap(gra16.4.2 , pop.filtered, gra16.4.2$assistance_type.2) #Function
    
    colnames(gra16.agg)[1] <- "assistance_type.2"
    
    gra16.agg.2 <- gra16.agg[c("assistance_type.2", "fund", "percap", "county")]
    
    gra16.agg.3 <- rbind(gra16.agg.2 , ny.per.2)
    
    cols <- c("#00CCFF","#3333FF")
    
    ggplot(gra16.agg.3, aes(x = county, y = percap, fill = assistance_type.2)) + 
      geom_bar(stat = "identity") + 
      labs(x="County", y="Per Capita Funding") +
      # ggtitle("Per Capita Federal Funding by County") +
      scale_y_continuous(labels = scales::comma) + 
      scale_fill_manual(values = cols) +   
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank(), axis.line = element_blank() , legend.title = element_blank())
    
    
  }) # end of per capita plot
  
  # Render census plot
  output$censusPlot <- shiny::renderPlot({
    
    #################FORMATTING THE DF##########################
    #only working with four comparatos and NY state
    #"Matches for Onondaga: 1.Broome, 2.St. Lawrence, 3.Orange, 4.Sullivan, 5.Monroe"
    x <- NYcen_norm$county.name %in% input$your_county
    NYcen_norm_filter <- NYcen_norm[x,]
    NYcen_norm_filter$county.name <- factor(NYcen_norm_filter$county.name, ordered= TRUE)
    rownames(NYcen_norm_filter) <- 1:nrow(NYcen_norm_filter)
    
    #################### MAKING THE BARPLOT #######################
    
    krzycensuz(NYcen_norm_filter)
    
  }) # end of census plot
  
output$smallMultiples <- renderPlot({

  
  #filter by county
  county.filter <- filter(agg.pop.percap, County %in% input$your_county)
  
  
  ggplot(county.filter, aes(x=County, y= percap)) + geom_bar( aes(fill=County), stat="identity")  + facet_grid(Agency ~ Recipient_Type, switch="y")+
    labs(title="Federal Project Grant Funding by County, Agency, and Recipient", 
         subtitle="Per Capita Funding, FY 2016")+ theme_minimal() + theme (strip.text.y = element_text(size=12, angle = 180), strip.text.x = element_text(size=12), plot.title = element_text(size=16), plot.subtitle = element_text(size=13), legend.position="top", legend.title = element_blank(), axis.title.x=element_blank(), legend.key.size = unit(.5, "line"), legend.text=element_text(size=12),
                                                                           axis.title.y= element_blank(), axis.ticks=element_blank(), axis.text.x= element_blank(),  axis.text.y= element_blank(), panel.background = element_rect(colour = 'gray80'),panel.grid.minor = element_blank(), panel.grid.major =element_blank())

  
})
  
  
  
  
  
  
  
  output$cfdaTable <- DT::renderDataTable({
    # edit fancy table 2
    gra16.4 <- filter(gra16.3 , county %in% input$your_county , assistance_type == "04: Project grant", fed_funding_amount > 0, recip_cat_type == input$recipient) 
    
    gra16.5 <- gra16.4[c("county" , "agency_name",  "recipient_name", "recip_cat_type", "cfda_program_title", "fed_funding_amount")]
    
    colnames(gra16.5) <- c("County", "Agency", "Recipient", "Recipient Type", "Program Title", "Funding Recieved")
    
    gra16.5
  })
  
  
} # end of server

## call the Shiny App ##
shinyApp(ui, server)
