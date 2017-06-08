#
# Author:   Cristian Nuno
# Date:     June 6, 2017
# Purpose:  Experimenting with Dorling Cartogram
#
# devtools::install_github("chxy/cartogram")
#  https://github.com/chxy/cartogram/blob/master/R/dorling.R
library( cartogram )
library( geojsonio )
library( rgeos )
library( maptools )
library( TeachingDemos )
#
# import data
geojson_url <- "https://raw.githubusercontent.com/DataCapstone/Data-Capstone/master/Raw-Data/ny_county_code.geojson"
ny_counties <- geojson_read( geojson_url, what = "sp")
#
# Find the center of each region and label lat and lon of centers
centroids <- gCentroid( ny_counties, byid = TRUE )
centroidLons <- coordinates(centroids)[,1] # obtain longitudinal coords
centroidLats <- coordinates(centroids)[,2] # obtain latitutde coords
# going to run this stuff now
dorling( name = ny_counties$county_name
         , name.text = FALSE
         , centroidx = centroidLons
         , centroidy = centroidLats
         , density = ny_counties$funding_per_capita
         # , nbr = county.list
         , color = "dodgerblue4"
         , main = "FY16 Per Capita Total\nFederal Award Spending in New York Counties"
         , ylab = ""
         , xlab = "Dorling Cartogram:\nThe bigger the bubble, the more federal money coming in"
         , bty = "n"
               )
# nbr seems important
# A list of the neighbors of every region. 
# Each element is a vector of all the neighbor names of a region.
# 
# make a list for each county 
# with a NULL vector

county.list <- as.list(
  as.character(ny_counties$county_name)
  )
names( county.list ) <- as.character(ny_counties$county_name)
# use this to navigate
# file:///Users/cristiannuno/Desktop/Syracuse/MPA_Portfolio/DATA_ACT/data_export/nymapv1.html
county.list$Hamilton <- c("Herkimer", "St. Lawrence"
                          , "Franklin", "Essex"
                          , "Warren", "Saratoga"
                          , "Fulton"
                          )
county.list$Chenango <- c("Broome", "Cortland"
                          , "Madison", "Otesgo"
                          , "Delaware"
                          )
county.list$Livingston <- c("Monroe", "Genesee"
                            , "Wyoming", "Allegany"
                            , "Steuben", "Ontario"
                            )
county.list$Schuyler <- c("Chemung", "Steuben"
                          , "Yates", "Seneca"
                          , "Tompkins"
                          )
county.list$Schoharie <- c( "Greene", "Albany"
                            , "Schenectady", "Montgomery"
                            , "Otesgo", "Delaware"
                            )
county.list$Rensselaer <- c("Columbia", "Greene"
                            , "Albanuy", "Saratoga"
                            , "Washington"
                            )
county.list$Oneida <- c("Herkimer", "Otesgo"
                        , "Madison", "Oswego"
                        , "Lewis"
                        )
county.list$Wayne <- c("Monroe", "Ontario"
                       , "Seneca", "Cayuga"
                       )
county.list$Suffolk <- "Nassau"
county.list$Tioga <- c("Chemung", "Broome"
                       , "Tompkins", "Cortland"
                       )
county.list$Rockland <- c("Orange", "Westchester"
                          , "Putnam"
                          )
county.list$Wyoming <- c( "Livingston", "Genesee"
                          , "Erie", "Cattaraugus"
                          , "Allegany"
                          )
county.list$Oswego <- c("Jefferson", "Cayuga"
                        , "Onondaga", "Madison"
                        , "Oneida", "Lewis"
                        )
county.list$Orleans <- c("Niagara", "Monroe"
                         , "Genesee"
                         )
county.list$Steuben <- c("Chemung", "Schuyler"
                         , "Yates", "Ontario"
                         , "Livingston", "Allegany"
                         )
county.list$Washington <- c("Warren", "Saratoga"
                            , "Rensselaer", "Essex"
                            )
county.list$`St. Lawrence` <- c("Franklin", "Hamilton"
                                , "Herkimer", "Lewis"
                                , "Jefferson"
                                )
county.list$Warren <- c("Washington", "Essex"
                        , "Hamilton", "Saratoga"
                        )
county.list$Westchester <- c("Bronx", "Nassau"
                             , "Rockland", "Putnam"
                             , "Orange"
                             )
county.list$Tompkins <- c("Tioga", "Cortland"
                          , "Cayuga", "Seneca"
                          , "Schuyler", "Chemung"
                          )
county.list$Otsego <- c("Chenango", "Delaware"
                        , "Madison", "Oneida"
                        , "Schoharie", "Montgomery"
                        , "Herkimer"
                        )
county.list$Chautauqua <- c("Cattaraugus", "Erie")
county.list$Seneca <- c("Wayne", "Cayuga"
                        , "Tompkins", "Ontario"
                        , "Yates", "Schuyler"
                        )
county.list$Cayuga <- c("Wayne", "Oswego"
                        , "Jefferson", "Onondaga"
                        , "Seneca", "Tompkins"
                        , "Cortland"
                        )
county.list$Queens <- c("Richmond", "Kings"
                        , "New York", "Nassau"
                        , "Bronx"
                        )
county.list$Essex <- c("Washington", "Warren"
                       , "Hamilton", "Franklin"
                       , "Clinton"
                       )
county.list$Ulster <- c("Orange", "Dutchess"
                        , "Columbia", "Greene"
                        , "Delaware", "Sullivan"
                        )
county.list$Sullivan <- c("Orange", "Ulster"
                          , "Delaware"
                          )
county.list$Chemung <- c("Steuben", "Schuyler"
                         , "Tompkins", "Tioga"
                         )
county.list$`New York` <- c("Kings", "Queens"
                            , "Bronx"
                            )
county.list$Monroe <- c("Orleans", "Genesee"
                        , "Livingston", "Ontario"
                        , "Wayne"
                        )
county.list$Nassau <- c("Suffolk", "Queens"
                        , "Bronx", "Westchester"
                        )
county.list$Onondaga <- c("Oswego", "Cayuga"
                          , "Cortland", "Madison"
                          )
county.list$Columbia <- c("Rensselaer", "Albany"
                          , "Greene", "Ulster"
                          , "Dutchess"
                          )
county.list$Dutchess <- c("Columbia", "Ulster"
                          , "Orange", "Putnam"
                          )
county.list$Schenectady <- c("Albany", "Saratoga"
                             , "Montgomery", "Schoharie"
                             )
county.list$Saratoga <- c("Schenectday", "Albany"
                          , "Rensselaer", "Washington"
                          , "Warren", "Hamilton"
                          , "Fulton", "Montgomery"
                          )
county.list$Greene <- c("Ulster", "Delaware"
                        , "Schoharie", "Albany"
                        , "Columbia", "Rensselaer"
                        )
county.list$Ontario <- c("Wayne", "Seneca"
                         , "Yates", "Steuben"
                         , "Livingston", "Monroe"
                         )
county.list$Delaware <- c("Sullivan", "Ulster"
                          , "Greene", "Schoharie"
                          , "Otesgo", "Chenango"
                          , "Broome"
                          )
county.list$Allegany <- c("Cattaraugus", "Wyoming"
                          , "Livingston", "Steuben"
                          )
county.list$Albany <- c("Rensselaer", "Saratoga"
                        , "Schenectady", "Schoharie"
                        , "Greene", "Columbia"
                        )
county.list$Bronx <- c("New York", "Queens"
                       , "Nassau", "Westchester"
                       )
county.list$Broome <- c("Tioga", "Cortland"
                        , "Chenango", "Delaware"
                        )
county.list$Clinton <- c("Franklin", "Essex")
county.list$Erie <- c("Chautauqua", "Cattaraugus"
                      , "Wyoming", "Genesse"
                      , "Niagara"
                      )
county.list$Jefferson <- c("Oswego", "Lewis"
                           , "St. Lawrence"
                           )
county.list$Fulton <- c("Hamilton", "Herkimer"
                        , "Montgomery", "Schenectady"
                        , "Saratoga"
                        )
county.list$Madison <- c("Oneida", "Oswego"
                         , "Onondaga", "Cortland"
                         , "Chenango", "Otsego"
                         )
county.list$Kings <- c("Richmond", "Queens"
                       , "New York"
                       )
county.list$Genesee <- c("Orleans", "Niagara"
                         , "Erie", "Wyoming"
                         , "Livingstone", "Monroe"
                         )
county.list$Lewis <- c("Jefferson", "Oswego"
                       , "Oneida", "Herkimer"
                       , "St. Lawrence"
                       )
county.list$Franklin <- c("St. Lawrence", "Hamilton"
                          , "Essex", "Clinton"
                          )
county.list$Montgomery <- c("Fulton", "Herkimer"
                            , "Otsego", "Schoharie"
                            , "Schenectady", "Saratoga"
                            )
county.list$Orange <- c("Sullivan", "Ulster"
                        , "Dutchess", "Putnam"
                        , "Rockland", "Westchester"
                        )
county.list$Yates <- c("Ontario", "Steuben"
                       , "Schuyler", "Seneca"
                       )
county.list$Cortland <- c("Onondaga", "Cayuga"
                          , "Tompkins", "Tioga"
                          , "Broome", "Chenango"
                          , "Madison"
                          )
county.list$Richmond <- c("Kings", "Queens")
county.list$Cattaraugus <- c("Chautauqua", "Erie"
                             , "Wyoming", "Allegany"
                             )
county.list$Herkimer <- c("St. Lawrence", "Lewis"
                          , "Oneida", "Otsego"
                          , "Montgomery", "Fulton"
                          , "Hamilton"
                          )
county.list$Niagara <- c("Erie", "Genesee"
                         , "Orleans"
                         )
county.list$Putnam <- c("Westchester", "Rockland"
                        , "Orange", "Dutchess"
                        )
# Done!
# going to run this stuff now
# nbc = county.list is just not working
dorling( name = ny_counties$county_name
         , name.text = TRUE
         , centroidx = centroidLons
         , centroidy = centroidLats
         , density = ny_counties$funding_per_capita
         # , nbr = county.list
         , color = "gold1"
         , main = "FY16 Per Capita Total\nFederal Award Spending in New York Counties"
         , ylab = ""
         , xlab = "Dorling Cartogram:\nThe bigger the bubble, the more federal money coming in"
         , bty = "n"
)
dorling( name = ny_counties$county_name
         , name.text = TRUE
         , centroidx = centroidLons
         , centroidy = centroidLats
         , density = ny_counties$federal_funding
         # , nbr = county.list
         , color = "gold1"
         , main = "FY16 Total Federal Award Spending\nin New York Counties"
         , ylab = ""
         , xlab = "Dorling Cartogram:\nThe bigger the bubble, the more federal money coming in"
         , bty = "n"
)
