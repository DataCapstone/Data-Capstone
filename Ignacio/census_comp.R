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

#####function code######

krzycensuz <- function (x)
{
  # Load Required Packages
  require(ggplot2)
  
  #making pot
  bars <- ggplot(x, aes(fill=county.name, height=.4, width=.03)) +
    geom_vline(xintercept=0, color = "grey70", size=2, linetype = "solid") +
    geom_tile(aes(x=x$Pop.n, y="Population"), stat="identity") +
    geom_tile(aes(x=x$MHincome.n, y="Median HIncome"), stat="identity") + 
    geom_tile(aes(x=x$pov.rate.n, y="Poverty Rate"), stat="identity") +
    geom_hline(yintercept=c(2.5,1.5), size = 3, color = "white" ) +
    theme(legend.position = "bottom",
          axis.title = element_blank(),
          panel.border = element_blank(),
          legend.title = element_blank()) +
    ggtitle(label= "County Demographics Comparison (normalized values)" ) 
  return(bars)
  
}
