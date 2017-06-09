#IGnacio
#CENSUS status graph

library(ggplot2)
library(dplyr)

########CREATING A NORMALIZED CENSUS DF#######################
#dat <- readRDS( gzcon(url("https://github.com/DataCapstone/Data-Capstone/blob/master/Raw-Data/NYcensus.rds?raw=true")))

dat <- arrange(dat, county.name)
dat$county.name <- as.character(dat$county.name)

#stripping useless columns
dat <- dat[,c(3,4,5,13)]

#normalizing the data
x <- dat$Pop
dat$Pop.n <- (x - mean(x)) / sd(x)

x <- dat$MHincome
dat$MHincome.n <- (x - mean(x)) / sd(x)

x <- dat$pov.rate
dat$pov.rate.n <- (x - mean(x)) / sd(x)

#creating a NY average
y <- data.frame("State Average", sum(dat$Pop)/62, sum(dat$MHincome)/62, sum(dat$pov.rate)/62, 0, 0, 0)
colnames(y) <- colnames(dat)
dat <- rbind(dat,y)

dat[,2:3]<- round(dat[,2:3], digits = 0)
dat[,4]<- round(dat[,4]*100, digits = 1)

#saveRDS(dat, "NYcen_norm.RDS")


###########################################

dat <- readRDS( gzcon(url("https://github.com/DataCapstone/Data-Capstone/blob/master/Raw-Data/NYcen_norm.RDS?raw=true")))

#only working with four comparatos and NY state
#"Matches for Onondaga: 1.Broome, 2.St. Lawrence, 3.Orange, 4.Sullivan, 5.Monroe"
x <- dat$county.name %in% c("Onondaga", "Broome", "St. Lawrence", "Sullivan")
dat <- dat[x,]
dat$county.name <- factor(dat$county.name, ordered= TRUE)
rownames(dat) <- 1:nrow(dat)

#################### MAKING THE BARPLOT #######################

tags <- dat[1:4]

dat <- dat[1:nrow(dat)-1,]

#using tiles
bars <- ggplot(dat, aes(fill=county.name, height=.4, width=.05)) +
  geom_vline(xintercept=0, color = "grey70", size=2, linetype = "solid") +
  geom_tile(aes(x=dat$Pop.n, y="Population"), stat="identity") +
  geom_tile(aes(x=dat$MHincome.n, y="Median Home Income"), stat="identity") + 
  geom_tile(aes(x=dat$pov.rate.n, y="Poverty Rate"), stat="identity") +
  geom_hline(yintercept=c(2.5,1.5), size = 3, color = "white" ) +
  theme(legend.position = "top",
        axis.title = element_blank(),
        panel.border = element_blank(),
        legend.title = element_blank())
bars




###################FUNCTION#########################
x<- dat

krzycensus <- function (x)
  {
  # Load Required Packages
  require(ggplot2)
  
  #making pot
  bars <- ggplot(x, aes(fill=county.name, height=.4, width=.05)) +
    geom_vline(xintercept=0, color = "grey70", size=2, linetype = "solid") +
    geom_tile(aes(x=dat$Pop.n, y="Population"), stat="identity") +
    geom_tile(aes(x=dat$MHincome.n, y="Median Home Income"), stat="identity") + 
    geom_tile(aes(x=dat$pov.rate.n, y="Poverty Rate"), stat="identity") +
    geom_hline(yintercept=c(2.5,1.5), size = 3, color = "white" ) +
    theme(legend.position = "top",
          axis.title = element_blank(),
          panel.border = element_blank(),
          legend.title = element_blank())
  return(bars)
   
}

krzycensus(x)


############################################

#Anotations

my_grob = grobTree(textGrob("This text is at x=0.1 and y=0.9, relative!\n Anchor point is at 0,0", x=0.1,  y=0.9, hjust=0,
                            gp=gpar(col="firebrick", fontsize=25, fontface="bold")))
ggplot(mtcars, aes(x=cyl)) + geom_bar() + annotation_custom(my_grob) + labs(title="Annotation Example")

geom_text(aes(x= (width.min+width.max)/2, y = x$mid, label = paste0(round(x$fraction*100, digits = 1),"%")),
          size= percent.cex,
          fontface = "bold",
          hjust = .5,
          vjust = .5,
          colour = "white") +


##############################################
