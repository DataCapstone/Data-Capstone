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

dat <- readRDS( gzcon(url("https://github.com/DataCapstone/Data-Capstone/blob/master/Raw-Data/NYcen_norm.RDS?raw=true")))

#only working with four comparatos and NY state
#"Matches for Onondaga: 1.Broome, 2.St. Lawrence, 3.Orange, 4.Sullivan, 5.Monroe"
x <- dat$county.name %in% c("Onondaga", "Broome", "St. Lawrence", "Sullivan", "Herkimer")
dat <- dat[x,]
dat$county.name <- factor(dat$county.name, ordered= TRUE)
rownames(dat) <- 1:nrow(dat)

#################### MAKING THE BARPLOT #######################


krzycensuz(dat)


