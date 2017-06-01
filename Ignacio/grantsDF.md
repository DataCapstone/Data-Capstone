Grants data frame
================

``` r
#generating a csv with the variables
x <- gra16[1,]
x <- as.data.frame(lapply(x, class))
x <- as.data.frame(t(x))
x <- data.frame(var = row.names(x), class = as.character(x$V1), stringsAsFactors = F)
grav <- x
write.csv(grav, "gra.variables.csv", row.names = F)
```

``` r
#exploring some variables

#types of assistance
#what type of assistances are they getting?
unique(gra16$asst_cat_type)
unique(gra16$assistance_type)

#cfda_program_title
head(gra16$cfda_program_title)
head(gra16$cfda_program_num)
(table(gra16$cfda_program_title == "")) #has 110 blank ones.
table(is.na(gra16$cfda_program_title)) #no NAs here!
class(gra16$cfda_program_title)

#fda_program_num
table(is.na(gra16$cfda_program_num)) #no NAs here!
table(gra16$cfda_program_num == "") #no blanks!
class(gra16$cfda_program_num)

#project_description
unique(gra16$project_description)

######PRINCIPAL PLACE###############
#location: wanna focus on 4 cities, no idea if they are comparable.
sort(unique(gra16$principal_place_cc))
# "Syracuse" | "SYRACUSE"   
# "Rochester" | "ROCHESTER"
# "Albany" | "ALBANY"
#  "Ithaca" | "ITHACA" 

sort(unique(gra16$principal_place_state)) 
#Output is  "Illinois" "Massachusetts" "New York" "NEW YORK"
#this means that the filter in the manual download is not for this variable. 

######RECIPIENTS###############
sort(unique(gra16$recipient_state_code)) 
#output is only NY, so the filter is by recipients place, which makes sense because if we are an IDA we should care about the recipient not the pop.

sort(unique(gra16$recipient_city_name)) 
# "Syracuse" | "SYRACUSE"   
# "Rochester" | "ROCHESTER"
# "Albany" | "ALBANY"
#  "Ithaca" | "ITHACA" 

sort(unique(gra16$recipient_county_code))
sort(unique(gra16$recipient_county_name))
sort(unique(gra16$recipient_state_code))
```

**ASSISSTANCE**

-   1 unique\_transaction\_id character
-   16 federal\_award\_id character

-   18 fed\_funding\_amount numeric
-   19 non\_fed\_funding\_amount numeric
-   20 total\_funding\_amount numeric

-   50 asst\_cat\_type character
-   24 assistance\_type character
-   25 record\_type integer : Federal Assistance Awards Data System record type: 1 = county aggregate record, 2 = individual action record.
-   47 fiscal\_year integer

-   23 ending\_date character

-   28 principal\_place\_code character
-   29 principal\_place\_state character
-   30 principal\_place\_cc character
-   32 principal\_place\_zip character
-   48 principal\_place\_state\_code character

**AGENCY/PROGRAM**

-   52 maj\_agency\_cat character
-   35 agency\_name character
-   4 cfda\_program\_num numeric
-   34 cfda\_program\_title character
-   15 agency\_code character

**RECIPIENT**

-   36 project\_description character
-   7 recipient\_name character
-   13 recipient\_type character
-   49 recip\_cat\_type character

-   8 recipient\_city\_code integer
-   9 recipient\_city\_name character
-   10 recipient\_county\_code integer
-   11 recipient\_county\_name character
-   56 recipient\_state\_code character
-   12 recipient\_zip integer
-   42 receip\_addr1 character
-   43 receip\_addr2 character
-   44 receip\_addr3 character

-   57 exec1\_fullname character
-   58 exec1\_amount numeric

Questions
=========

1.  how to work with negatives?
