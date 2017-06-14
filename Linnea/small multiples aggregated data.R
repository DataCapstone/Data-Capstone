
library(dplyr)
library(pander)
library(shiny)
library(censusapi)
library(plotly)
library(ggthemes)

# Download the data, clean
gra16.named <- readRDS(gzcon(url("https://github.com/DataCapstone/Data-Capstone/blob/master/Raw-Data/NYgra16_counties_named.rds?raw=true")))

#codes <- read.csv("https://raw.githubusercontent.com/DataCapstone/Data-Capstone/master/Raw-Data/countycodesNY.csv")

#exclude money going to state government and choose only project grants
gra16.without.state <- filter(gra16.named , recipient_type != "00: State government" )

gra16.2 <- mutate(gra16.without.state, county = as.character(Name))

#note, changed from agency_name with 72 options to maj_agency_cat with 26!, also dropped columns I didn't need
# gra16.3 <- gra16.2[ c("recip_cat_type", "county" , "fed_funding_amount" ,  "maj_agency_cat", "assistance_type" ) ]
# added two columns: recipient_name + cfda_program_title
# gra16.3 <- gra16.2[ c("county" , "fed_funding_amount" , "assistance_type", "agency_name",  "recipient_name", "recip_cat_type", "cfda_program_title") ]
gra16.3 <- gra16.2[ c("county" , "fed_funding_amount" , "assistance_type", "maj_agency_cat",  "recipient_name", "recip_cat_type", "cfda_program_title") ]
x <- gra16.3$recip_cat_type == "i: Private agencies"
gra16.3$recip_cat_type[x] <- "f: Private agencies"

y <- gra16.3$recip_cat_type == "h: Government"
gra16.3$recip_cat_type[y] <- "h: Private agencies"


#making recip_cat_type into a factor and changing the levels into more friendly ones
gra16.3$recip_cat_type <- factor(x= gra16.3$recip_cat_type)

levels(gra16.3$recip_cat_type) <- c("Private Firm",
                                    "Government",
                                    "Higher Ed",
                                    "Nonprofit",
                                    "Other")

# clean agency names a bit to be more consistent
simpleCap <- function(x) {
  s <- tolower(x) 
  s <- strsplit(s, " ")[[1]] 
  paste(toupper(substring(s, 1,1)), substring(s, 2), 
        sep="", collapse=" ")
} 
gra16.3$maj_agency_cat <-sapply(gra16.3$maj_agency_cat, simpleCap)

gra16.3$maj_agency_cat<-gsub( "Department Of ", "", as.character(gra16.3$maj_agency_cat), n)

gra16.3$maj_agency_cat<-(substring(gra16.3$maj_agency_cat, 7, nchar(gra16.3$maj_agency_cat)))


gra16.4<- filter(gra16.3 , assistance_type== "04: Project grant")

# drop rows with negative funding values
gra16.4 <- subset (gra16.4, fed_funding_amount > 0)

#Load the population data
population <- readRDS(gzcon(url("https://github.com/DataCapstone/Data-Capstone/blob/master/Raw-Data/NYcensus.rds?raw=true"))) 

pop.dat <- population[ c("county.name", "Pop") ]
pop.dat.state <- rbind(pop.dat, data.frame(county.name="State Average", Pop=sum(pop.dat$Pop)))


### aggregate funding by agency and county, and combine with state average

gra16.4$maj_agency_cat<- as.character(gra16.4$maj_agency_cat)

ny.agency.agg <- aggregate (gra16.4$fed_funding_amount, by=list(gra16.4$recip_cat_type, gra16.4$maj_agency_cat), FUN=sum, na.rm=TRUE)

colnames(ny.agency.agg)<- c("Recipient_Type", "Agency", "Federal_Funding")

ny.agency.agg["county"] <- "State Average"

colnames(ny.agency.agg)<- c("Recipient_Type", "Agency", "Federal_Funding", "County")

county.agency.agg <- aggregate (gra16.4$fed_funding_amount, by=list(gra16.4$recip_cat_type, gra16.4$maj_agency_cat, gra16.4$county), FUN=sum, na.rm=TRUE)


colnames(county.agency.agg)<- c("Recipient_Type", "Agency", "County", "Federal_Funding")

agency.agg <- rbind(ny.agency.agg, county.agency.agg)


### adjust to per capita funding by agency - need to work on adding in state averages

agg.pop <- merge(agency.agg , pop.dat.state, by.x = "County", by.y = "county.name", all.x=TRUE)

agg.pop.percap <- mutate(agg.pop , percap =  Federal_Funding / Pop )

agg.pop.percap<- agg.pop.percap[order(agg.pop.percap$Agency), ]

# round percap to display better
agg.pop.percap <- mutate(agg.pop.percap, percap = round(percap, 2))

#drop agencies with less than 10 rows
agg.pop.percap<-agg.pop.percap[as.numeric(ave(agg.pop.percap$Agency, agg.pop.percap$Agency, FUN=length)) >= 10, ]
