# Import R Objects from GitHub

To use other people's code, you will find this function especially useful!

```
# Source GitHub Function
source_github <- function( url ) {
  # load package
  require(RCurl)
  
  # read script lines from website and evaluate
  script <- getURL(url, ssl.verifypeer = FALSE)
  eval(parse(text = script), envir=.GlobalEnv)
} 

# Grab GitHub "raw" URL
leaflet_url <- "https://raw.githubusercontent.com/DataCapstone/Data-Capstone/master/Raw-Data/leaflet_ny.r"

# Run the "raw" URL inside your R environment!
source_github( leaflet_url )
```
Now other people's R objects are alive and well inside your R environment!

*Last updated on June 8, 2017*
