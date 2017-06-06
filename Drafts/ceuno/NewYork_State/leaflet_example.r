#
# Author:   Cristian Nuno
# Date:     June 5, 2017
# Purpose:  Plot FY17 Award Recipients in New York State
#
# Load necessary packages
library(leaflet)
library(htmltools)
library(htmlwidgets)
library(stringi)
library( magrittr )
library(dplyr)
library(scales)
# Import data
rds_url <- "https://github.com/DataCapstone/Data-Capstone/blob/master/Drafts/ceuno/NewYork_State/fy17_ny_awards_geocoded.rds?raw=true"
newyork_state_geo <- readRDS( gzcon( url( rds_url ) ) ) # took three seconds
# unique award type
unique.awards <- unique( newyork_state_geo$type_description )
# how many unique award types?
length( unique.awards ) # 10
# 10 colors by award type
col.schema <- c("red", "beige", "cadetblue"
                , "white", "green"
                , "pink", "orange", "blue"
                , "black", "lightblue"
)
# Make data frame assigning colors to unique award types
award_colors <- data.frame( type_description = unique.awards
                              , color = col.schema
                              , stringsAsFactors = FALSE
)
# check dimensions
dim(award_colors) # 10 by 2
dim( newyork_state_geo ) # 13991 by 77
# merge this data frame onto the original data frame
newyork_state_geo <- left_join( x = award_colors
                           , y = newyork_state_geo
                           , by = "type_description"
)
# check dims should be 13991 by 78
dim( newyork_state_geo ) # 13991 by 78

# attempting to split
type.split <- split( newyork_state_geo
                           , newyork_state_geo$type_description
)

# edit map
map <- leaflet() %>%
  # set view to cover the state of New York
  fitBounds( lng1 = -72, lat1 = 46
             , lng2 = -80, lat2 = 40  ) %>% 
  # add background to map
  addProviderTiles(providers$Esri.WorldStreetMap) %>%
  # add mini map
  addMiniMap(
    tiles = providers$Esri.WorldStreetMap
    , toggleDisplay = TRUE
    , minimized = TRUE
    ) %>%
  # add zoom out button
  addEasyButton( easyButton(
    icon = "ion-android-globe", title = "Zoom Back Out"
    , onClick = JS("function(btn, map){ map.setZoom(6); }")
  ) )
# obtain each data frame within the list
names( type.split ) %>%
  purrr::walk( function( df ){
    map <<- map %>%
      addAwesomeMarkers( data = type.split[[df]]
                         , lng = ~lon
                         , lat = ~lat
                         # Add useful information onto the popup
                         , popup = paste0( "<b>Recipient Name: </b>"
                                           , stri_trans_totitle( type.split[[df]]$recipient.recipient_name )
                                           , "<br>"
                                           , "<b>Business Type: </b>"
                                           , type.split[[df]]$recipient.business_types_description
                                           , "<br>"
                                           , "<b>Total Obligation ($): </b>"
                                           , dollar( type.split[[df]]$total_obligation )
                                           , "<br>"
                                           , "<b>Awarding Agency Name: </b>"
                                           , type.split[[df]]$awarding_agency.toptier_agency.name
                                           , "<br>"
                                           , "<b>Award Type: </b>"
                                           , type.split[[df]]$type_description
                                           , "<br>"
                                           , "<b>Date Signed: </b>"
                                           , type.split[[df]]$date_signed
                         )
                         , icon = awesomeIcons( icon = "ion-social-usd"
                                                , iconColor = "#eefef7"
                                                , library = "ion"
                                                , markerColor = type.split[[df]]$color
                         )
                         , group = df
                         , clusterOptions = markerClusterOptions()
                         , labelOptions = labelOptions( noHide = FALSE
                                                        , direction = "auto"))
  }) # end of combing through the list
map <- map %>%
  # Add widget to allow user to click which department
  # they would like to view
  addLayersControl(
    overlayGroups = names(type.split)
    , options = layersControlOptions( collapsed = TRUE )
  )
# View map
map
