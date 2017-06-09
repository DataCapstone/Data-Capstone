#IGnacio
#CENSUS status graph

library(ggplot2)
library(dplyr)

#CENSUS 
cen <- readRDS( gzcon(url("https://github.com/DataCapstone/Data-Capstone/blob/master/Raw-Data/NYcensus.rds?raw=true")))

dat <- cen 
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

saveRDS(dat, "NYcen_norm.RDS")
dir()



#only working with four comparatos and NY state
#"Matches for Onondaga: 1.Broome, 2.St. Lawrence, 3.Orange, 4.Sullivan, 5.Monroe"
x <- dat$county.name %in% c("Onondaga", "Broome", "St. Lawrence", "Sullivan", "State Average")
dat <- dat[x,]
dat$county.name <- factor(dat$county.name, ordered= TRUE)


#################### MAKING THE BARPLOT #######################

dat
#dat$Pop <- c(1,8,18,14,10) dat$MHincome <- c(11,19,4,12,10) dat$pov.rate <- c(5,8,14,17,10)


#using tiles
bars <- ggplot(dat, aes(fill=county.name, height=.4, width=.5)) +
  geom_tile(aes(x=dat$Pop, y="Population"), stat="identity") +
  geom_tile(aes(x=dat$MHincome, y="Median Home Income"), stat="identity") + 
  geom_tile(aes(x=dat$pov.rate, y="Poverty Rate"), stat="identity") +
  geom_hline(yintercept=c(2.5,1.5)) +
  theme(legend.position = "top",
        axis.title = element_blank(),
        panel.border = element_blank(),
        legend.title = element_blank()
        )
bars




############################################

#Anotations

my_grob = grobTree(textGrob("This text is at x=0.1 and y=0.9, relative!\n Anchor point is at 0,0", x=0.1,  y=0.9, hjust=0,
                            gp=gpar(col="firebrick", fontsize=25, fontface="bold")))
ggplot(mtcars, aes(x=cyl)) + geom_bar() + annotation_custom(my_grob) + labs(title="Annotation Example")


##############################################

#DONUT

pie <- ggplot(data=x,
              aes(fill=labels,
                  xmax=width.max, xmin=width.min,
                  ymax=ymax, ymin=ymin)) +
  xlim(c(0, width.max + mar)) +
  geom_rect(colour=border.col,
            size = border.cex) +
  coord_polar(theta="y") +
  geom_text(aes(x= (width.min+width.max)/2, y = x$mid, label = paste0(round(x$fraction*100, digits = 1),"%")),
            size= percent.cex,
            fontface = "bold",
            hjust = .5,
            vjust = .5,
            colour = "white") +
  ggtitle(label=main) +
  theme_bw() +
  theme(panel.grid=element_blank(),
        axis.text=element_blank(), 
        axis.ticks=element_blank(),
        axis.title = element_blank(),
        panel.border = element_blank(),
        strip.background = element_rect(fill= sbgfill, color = sbgcol), 
        plot.margin = margin(0,0,0,0, "cm"),
        legend.margin = margin(0,0,0,0, "cm"),
        legend.title = element_blank(),
        legend.position = "right",
        legend.text = element_text(colour = "grey40", size = 9)) +
  facet_wrap(~multiple, ncol = columns)
return(pie)
}
