# 
# Ignacio's State Code
library(dplyr)
library(pander)
library(ggplot2)


################ LOADING DONUTZ FUNCTION ######################

#calling the function from git
source_github <- function( url ) {
  # load package
  require(RCurl)
  
  # read script lines from website and evaluate
  script <- getURL(url, ssl.verifypeer = FALSE)
  eval(parse(text = script), envir=.GlobalEnv)
} 

#load the donutzz function using the RAW link
source_github("https://raw.githubusercontent.com/icps86/Functions/master/krzydonutzz")
source_github("https://raw.githubusercontent.com/icps86/Functions/master/donutzz.R")

################ GETTING THE DATAFRAMES ######################

options(scipen = 999)

#lOADING and processing the DF
gra16 <- readRDS( gzcon(url("https://github.com/DataCapstone/Data-Capstone/blob/master/Raw-Data/NYgra16_counties_named.rds?raw=true")))

#Removing state grants
x <- gra16$recipient_type == "00: State government"
gra16 <- gra16[!x,]


################ MAIN FUNDING AGENCIES IN NY ######################

#Creating an agregate by maj_agency_cat
dat <- group_by(gra16, maj_agency_cat)
dat <- arrange(as.data.frame(summarize(dat, Fed = sum(fed_funding_amount))), desc(Fed))

#Removing code from the Agency names.
dat$maj_agency_cat <- substr(dat$maj_agency_cat, 7,nchar(dat$maj_agency_cat))

#making an others category
dat[6,] <- c("Others", sum(dat$Fed[6:length(dat$Fed)])) 
dat <- dat[c(1:6),]
dat$Fed <- as.numeric(dat$Fed)
dat <- arrange(dat, desc(Fed))

#making the names smallerÑ

dat$maj_agency_cat <- c("Health and Human Services", "Others", "Transportation", "Housing and Urban Development",
                        "National Science Foundation", "Homeland Security")

#this is the dataframe we use
# dat %>% pander

#using the donutz func. to make the graph
maj_agency_donut <- donutzz(x=dat$Fed, lev=dat$maj_agency_cat, main=NULL)


################ MAIN RECIPIENT TYPES IN NY ######################

#copying the grants database to a working-out object
dat <- gra16

#making i: 'Private agencies' to be 'f: Private agencies'
#class(dat$recip_cat_type) #is character
x <- dat$recip_cat_type == "i: Private agencies"
dat$recip_cat_type[x] <- "f: Private agencies"

#making recip_cat_type into a factor and changing the levels into more friendly ones
dat$recip_cat_type <- factor(x= dat$recip_cat_type)

levels(dat$recip_cat_type) <- c("Private firms", 
                                "Government",
                                "Public Higher Ed. Inst.",
                                "Private Higher Ed. Inst.",
                                "Nonprofit agencies",
                                "Other")

#Creating an agregate by recip_cat_type
dat <- group_by(dat, recip_cat_type)
dat <- arrange(as.data.frame(summarize(dat, Fed = sum(fed_funding_amount))), desc(Fed))

#using the donutz func. to make the graph
recipient_cat_donut <- donutzz(x=dat$Fed, lev=dat$recip_cat_type, main=NULL)

