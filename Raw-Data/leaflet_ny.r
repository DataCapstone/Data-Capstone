#
# Author:   Cristian Nuno
# Date:     June 6, 2017
# Purpose:  Making a leaflet map for New York state
#
# Load necessary packages
library( leaflet )
library( magrittr )
library( htmltools )
library( htmlwidgets )
library( geojsonio )
# Load necessary data frames
rds_url <- "https://github.com/DataCapstone/Data-Capstone/blob/master/Raw-Data/NYgra16.rds?raw=true"
fy16_ny_grants <- readRDS( gzcon( url( rds_url ) ) ) # 5 seconds
geojson_url <- "https://raw.githubusercontent.com/DataCapstone/Data-Capstone/master/Raw-Data/NY_counties.geojson"
ny_counties <- geojson_read( geojson_url, what = "sp" )

# create a county code id from the geoid
# inside the geojson file
county_code <- as.character( ny_counties$geoid )
length( county_code ) # 62 county codes
county_code <- unlist( strsplit( county_code
                 , split = "05000US36"
                 , fixed = TRUE
                 )
)
length( county_code ) # 124..looks like the odds are blank
# extract evens
county_code <- county_code[ seq( from = 2, to = length(county_code), by = 2 )]
# class 
class( county_code )
county_code <- as.numeric( county_code )
# save to geojson
ny_counties$county_code <- county_code
# We might want just the county name
# not the " County, NY"
county_name <- unlist( strsplit( as.character(ny_counties$name)
                          , split = " County, NY"
                          , fixed = TRUE
                          )
                )
# add to geojson file
ny_counties$county_name <- county_name
# save as geojson
geojson_write( ny_counties
               , file = "/Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_export/ny_county_code.geojson"
               )
# import revised geojson
update_url <- "https://raw.githubusercontent.com/DataCapstone/Data-Capstone/master/Raw-Data/ny_county_code.geojson"
update_map <- geojson_read( update_url, what = "sp")
# make map
ny_map <- leaflet() %>%
  # set view to cover the state of New York
  fitBounds( lng1 = -72, lat1 = 46
             , lng2 = -80, lat2 = 40  ) %>% 
  # add Polygons
  addPolygons( data = update_map
              , smoothFactor = 0.2
              , fillOpacity = 0.7
              # Whenever someone hovers their mouse above a polygon,
              # make sure they know which community they are in
              , popup = as.character(update_map$county_code)
              , label = update_map$county_name
              , labelOptions = labelOptions( textsize = "25px"
                                             , textOnly = TRUE
                                             )
              , highlightOptions = highlightOptions( color = "orange"
                                                     , weight = 6
                                                     , bringToFront = TRUE
              )
              ) %>%
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
# view map
ny_map

