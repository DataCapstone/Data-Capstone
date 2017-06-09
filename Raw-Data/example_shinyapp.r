#
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

# import county overview 
co_url <- "https://raw.githubusercontent.com/DataCapstone/Data-Capstone/master/Raw-Data/county_comparison_sw.r"
source_github(co_url)

# load the donutzz function using the RAW link
source_github("https://raw.githubusercontent.com/icps86/Functions/master/krzycensuz.r")

# normalized census
NYcen_norm <- readRDS( gzcon(url("https://github.com/DataCapstone/Data-Capstone/blob/master/Raw-Data/NYcen_norm.RDS?raw=true")))

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
        , fluidPage(
          selectizeInput(
            inputId='your_county', 
            label='Select up to 4 counties to compare:', 
            choices= sort(unique(gra16.3$county)),
            selected=c("Onondaga"), 
            multiple = TRUE, 
            options = list(maxItems = 4)
            )# finish selectize input
          ,  radioButtons(
            inputId = 'recipient',
            label='Select a recipient:',
            choices = c( sort(unique(as.character(gra16.3$recip_cat_type))))
            )
          , shiny::plotOutput("percapPlot")
          , shiny::plotOutput("censusPlot")
          , shiny::plotOutput("recipientPlot")
          , shiny::plotOutput("agencyPlot")
          , DT::dataTableOutput("cfdaTable")
        ) # end of fluid page
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
      ggtitle("Per Capita Federal Funding by County") +
      scale_y_continuous(labels = scales::comma) + 
      scale_fill_manual(values = cols) +   
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
            panel.background = element_blank(), axis.line = element_blank() , legend.title = element_blank())
    
    
  }) # end of per capita plot

  #
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
    
    })
    
  #Bar agency plot 
  output$agencyPlot <- shiny::renderPlot({
    
    
    recipient.filter <- filter(gra16.3, recip_cat_type == input$recipient, assistance_type == "04: Project grant" , fed_funding_amount > 0)
    
    agency.agg <- aggregate (recipient.filter$fed_funding_amount, by=list(recipient.filter$agency_name, recipient.filter$county), FUN=sum, na.rm=TRUE)
    colnames(agency.agg)<- c("Agency", "County_Name", "Federal_Funding")
    
    agg.pop <- merge(agency.agg , population, by.x = "County_Name", by.y = "county.name", all.x=TRUE)
    
    agg.pop.percap <- mutate(agg.pop , percap =  Federal_Funding / Pop )
    
    county.filter <- filter(agg.pop.percap, County_Name %in% input$your_county)
    county.filter.small <- subset (county.filter, select=c("County_Name", "Agency", "percap"))
    
    counties.percap.ordered<- county.filter.small[order(county.filter.small$percap), ]
    
    selected<-counties.percap.ordered[unlist(tapply(row.names(counties.percap.ordered), counties.percap.ordered$County_Name, tail, n = 3)), ] 
    
    ggplot(selected, aes(Agency, percap)) + geom_bar(aes(fill = County_Name), 
                                                     position = position_dodge(), stat="identity") +  facet_wrap(~County_Name, ncol = 4)+
      theme(legend.position="right", legend.title = 
              element_blank(),axis.title.x=element_blank(), 
            axis.title.y= element_blank()) + coord_flip()
    
    
    
  })
  
  #Donut recipient plot 
  output$recipientPlot <- shiny::renderPlot({
    
    
    gra16.4 <- filter(gra16.3 , county %in% input$your_county , assistance_type == "04: Project grant" , fed_funding_amount > 0) #just care about incoming funds for project grants
    
    agg.per <- agg.county(gra16.4, gra16.4$recip_cat_type)
    
    krzydonutzz(x= agg.per, values = "fund", labels = "var", multiple = "county", main = "Federal Project Grant Funding by Recipient", percent.cex = 3, columns = 4)
    
    
  })
  
  
  output$cfdaTable <- DT::renderDataTable({
    
    gra16.4 <- filter(gra16.3 , county %in% input$your_county , assistance_type == "04: Project grant", fed_funding_amount > 0, recip_cat_type == input$recipient) 
    
    gra16.5 <- gra16.4[c("county" , "agency_name",  "recipient_name", "recip_cat_type", "cfda_program_title", "fed_funding_amount")]
    
    colnames(gra16.5) <- c("County", "Agency", "Recipient", "Recipient Type", "Program Title", "Funding Recieved")
    
    gra16.5
    
  })
  
  
} # end of server

## call the Shiny App ##
shinyApp(ui, server)
