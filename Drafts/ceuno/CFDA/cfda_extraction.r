#
# Author:   Cristian Nuno
# Date:     June 5, 2017
# Purpose:  Extract Meaningful Names from CFDA Program Title and Objective
#
# Load necessary packages
library( stringi )
# Define url
rds_url <- "https://github.com/DataCapstone/Data-Capstone/blob/master/Drafts/ceuno/cfda_program_info.rds?raw=true"
# Import .rds url
cfda_program <- readRDS( gzcon(url( rds_url ) ) )
# add keyword
cfda_program$keyword <- "fake keyword"

############ Stop words ########################
stop.words <- read.csv( file = "https://raw.githubusercontent.com/ecmendenhall/DaveDaveFind/master/data/stopwords.csv"
                        , sep = ""
                        , stringsAsFactors = FALSE
                        , header = FALSE
)
# Only vector
stop.words.lowercase <- stop.words$V1
# Capital case
stop.words.capitalcase <- stri_trans_totitle( stop.words.lowercase)
# combine the two vectors
all.stop.words <- append( stop.words.capitalcase, stop.words.lowercase)
# add blank space to stop words
all.stop.words <- append( all.stop.words, "")
################### Extract keywords from "Program Title" variable ##################
# split with pattern into list
keywords.all <- strsplit( x = cfda_program$program_title
                          , split = "[[:punct:]]|[[:space:]]|\\[[:xdigit:]]"
)
# Remove stop words
# Need a function that will go inside each list
# and clean each individual character vector
clean.list <- function( list.object ) {
  # initialize the counter
  i <- 1
  # empty list
  clean.list.object <- list()
  # set logical expression
  while( i <= length( list.object ) ){
    # what action the while loop should do
    # Create vector of clean words
    clean.vector <- list.object[[i]][ !list.object[[i]] %in% all.stop.words ]
    # add vector to empty list
    # with only unique elements
    clean.list.object[[i]] <- unique( clean.vector )
    # add to the counter to move logic onto the next list
    i <- i + 1
  }
  # return the full list
  return( clean.list.object )
} # end of function
#
# Call the function
keywords.clean.all <- clean.list( keywords.all )
####################### Need some functions #########################

# duplicate data frame 
copy.cat <- function( n, df ) {
do.call("rbind"
        , replicate(n, df, simplify = FALSE)
)
}

# splice one row within a data frame
# and return an extended data frame
# where the extension depends on the amount of keywords in the keywords.clean.all list
splice.original <- function( df, list_object ) {
    # set keyword vector counter
    i <- 1
    # make keyword vector
    keyword.vector <- unlist( list_object )
    # duplicate data frame
    duplicate.df <- copy.cat( n = length( keyword.vector )
                            , df = df
    )
      while( i <= length( keyword.vector ) ) {
      # replace fake keyword
      # with real keyword from keyword vector
      duplicate.df$keyword[i] <- keyword.vector[i]
      # add to counter
      i <- i + 1
    } # end of while loop
  # return the duplicate.df with keywords
  return( duplicate.df )
} # end of function

# Now one last function
# which takes each spliced extended data frame
# and binds the results together
# to create a giant extended data frame
piecemeal <- function( df, list_object) {
  # add counter
  i <- 1
  # add empty df
  empty_df <- NULL
  # start for loop
  for(i in 1:nrow(df)) {
    # extend one row
    one.row <- splice.original( df[i, ], list_object[i] )
    # add extended row to empty data frame
    empty_df <- rbind( empty_df, one.row)
    # add to counter
    i <- i + 1
  }
  # return empty df
  return( empty_df )
}
########## Test the functions ##################
cfda_program_keywords <- piecemeal( df = cfda_program
                   , list_object = keywords.clean.all
                  )
dim( cfda_program_keywords )
