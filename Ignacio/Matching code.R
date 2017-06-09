#################LOADING THE FUNCTION##########################

source_github <- function( url ) {
  # load package
  require(RCurl)
  
  # read script lines from website and evaluate
  script <- getURL(url, ssl.verifypeer = FALSE)
  eval(parse(text = script), envir=.GlobalEnv)
} 

#load the match function using the RAW link
source_github("https://raw.githubusercontent.com/icps86/Functions/master/krzymatch.r")


############ INPUTS ##########

#input dataframe of counties
dat <- readRDS( gzcon(url("https://github.com/DataCapstone/Data-Capstone/blob/master/Raw-Data/NYcen_norm.RDS?raw=true")))

#########trying the function##########

krzymatch(dat, county="Onondaga", comparators = 3)
