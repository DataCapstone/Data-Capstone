library(censusapi)
library(plotly)
library( shiny )
library( dplyr )
# Download the data, clean
# from RDS
gra16.3_url <- "https://github.com/DataCapstone/Data-Capstone/blob/master/columns_selected.rds?raw=true"
gra16.3 <- readRDS( gzcon( url( gra16.3_url )))
#Load the population data
population <- readRDS(gzcon(url("https://github.com/DataCapstone/Data-Capstone/blob/master/Raw-Data/NYcensus.rds?raw=true")))

# Aggregation function
agg.county <- function(df , var){
  
  ag <- aggregate(df$fed_funding_amount, by= list( df$county, var), FUN = sum  )
  
  colnames(ag) <- c("county", "var", "fund")
  
  return(ag)
}




# Per capita aggregation function
agg.county.percap <- function(df, df.p , var){
  
  ag <- aggregate(df$fed_funding_amount, by= list( df$county, var), FUN = sum  )
  
  colnames(ag) <- c("county", "var", "fund")
  
  ag.pop <- merge(ag , df.p, by.x = "county", by.y = "county.name")
  
  ag.pop.2 <- mutate(ag.pop , percap =  fund / Pop )
  
  ag.pop.3 <- ag.pop.2[c("var", "fund", "percap", "county")]
  
  return(ag.pop.3)
}




# Per capita aggregation function, statewide
agg.percap <- function(df, df.p, var){
  
  ag <- aggregate(df$fed_funding_amount, by= list( var), FUN = sum  )
  
  colnames(ag) <- c("var", "fund")
  
  ag.2 <- mutate(ag , county = "NY Average")
  
  ag.per <- mutate(ag.2 , percap = fund / (sum(df.p$Pop)))
  
  return(ag.per)
}



# Doughnut plots

source_github <- function( url ) {
  # load package
  require(RCurl)

  # read script lines from website and evaluate
  script <- getURL(url, ssl.verifypeer = FALSE)
  eval(parse(text = script), envir=.GlobalEnv)
}

#load the donutzz function using the RAW link
source_github("https://raw.githubusercontent.com/icps86/Functions/master/krzydonutzz.r") # added .r

# National Aggregation

ny.grp <- mutate(gra16.3 , assistance_type.2 = ifelse( assistance_type == "04: Project grant", "Project Grants" , "Other Grants" ) )

ny.per <- agg.percap(ny.grp , population , ny.grp$assistance_type.2) #Function

colnames(ny.per)[1] <- "assistance_type.2"

ny.per.2 <- ny.per[c("assistance_type.2", "fund", "percap", "county")]
