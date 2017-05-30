# How to Import RDS files into RStudio

Author:   Cristian Nuno
Date:     May 30, 2017
Purpose:  How to Import RDS files from GitHub into RStudio

### Step 1

ID a .rds file inside a GitHub repository
https://github.com/DataCapstone/Data-Capstone/tree/master/Drafts/ceuno

### Step 2

Once .rds file is found, ID the phrase "View Raw"

### Step 3

Right-click on "View Raw"

### Step 4

Click on "Copy Link Address" option from the menu

### Step 5

Paste the link address into a character vector

```
rds_url <- "https://github.com/DataCapstone/Data-Capstone/blob/master/Drafts/ceuno/chi_hou_philly_projectgrants_fy17.rds?
```

### Step 6

Nest the character vector into the following functions: 

```
rds.df <- readRDS( gzcon(url( rds_url ) ) )
```

### Step 7: Congratulations!

You now know how to import .rds files into RStudio!

*Last updated on May 30, 2017*
