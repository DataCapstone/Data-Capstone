
################# FUNCTION #################

################# LOOP FOR MATCHING #################

knitr::opts_chunk$set( echo = T, message=F, warning=F, fig.width = 10, fig.height = 10 )
library(censusapi)
library(dplyr)
library(pander)
library(geojsonio)
library(sp) #need this to read the json shapes in gplot
#install.packages("MatchIt")
library(MatchIt)


############LoadingGrants DF##########

NYcensus <- readRDS( gzcon(url("https://github.com/DataCapstone/Data-Capstone/blob/master/Raw-Data/NYcensus.rds?raw=true")))



#Matchit 
#################################################

dat <- NYcensus

#To run matchit we need to have a treatment and control group
#We flag one county as part of the treatment group and the 61 others are assumed as the control

county <- "Onondaga"
x <- dat$county.name == county
dat$Treat <- 0
dat$Treat[x] <- 1

#creating objects
mat.list <- rep(NA,5)
dis <- rep(FALSE, 62)

#pop density
for (i in c(1:5)) {
  mat <- matchit(Treat ~  Pop + MHincome + pov.rate, data = dat, discard = dis)
  x <- as.numeric(mat$match.matrix)
  dis[x] <- TRUE
  mat.list[i] <- x
}

x <- paste(1:5, ".", as.character(dat$county.name[mat.list]), ", ", sep = "", collapse = "")
x <- substr(x,1,nchar(x)-2)
x <- paste0("Matches for ", county, ": ", x)
print(x)

#to add to this:
#t test to show covarietes.
#confidence interval and diagram to show how different it is.
