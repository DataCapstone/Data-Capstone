#################LOADING THE FUNCTION##########################

source_github <- function( url ) {
  # load package
  require(RCurl)
  
  # read script lines from website and evaluate
  script <- getURL(url, ssl.verifypeer = FALSE)
  eval(parse(text = script), envir=.GlobalEnv)
} 

#load the donutzz function using the RAW link
source_github("https://raw.githubusercontent.com/icps86/Functions/master/krzycensuz.r")


#################FORMATTING THE DF##########################

NYcen_norm <- readRDS( gzcon(url("https://github.com/DataCapstone/Data-Capstone/blob/master/Raw-Data/NYcen_norm.RDS?raw=true")))

x <- NYcen_norm$county.name %in% c("Broome", "St. Lawrence", "Orange", "Sullivan", "Monroe")
NYcen_norm_filter <- NYcen_norm[x,]
NYcen_norm_filter$county.name <- factor(NYcen_norm_filter$county.name, ordered= TRUE)
rownames(NYcen_norm_filter) <- 1:nrow(NYcen_norm_filter)

#################### MAKING THE BARPLOT #######################

krzycensuz(NYcen_norm_filter)
