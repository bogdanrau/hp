# LIBRARIES AND PACKAGES
library(shiny)                  ## REQUIRED FOR SHINY APPLICATION FUNCTIONALITY
library(shinydashboard)         ## REQUIRED FOR SHINY DASHBOARD APPEARANCE
library(DT)                     ## DATA TABLES PACKAGE
library(htmlwidgets)
library(RMySQL)                 ## REQUIRED FOR CONNECTING TO MySQL DATABASES
library(plyr)                   ## REQUIRED FOR ENHANCED DATA/TABLE MANIPULATION
library(XML)
library(rCharts)                ## REQUIRED FOR INTERACTIVE CHART GENERATION
library(reshape2)

## LOAD ADDITIONAL FUNCTIONS
source("functions.R", local = TRUE)

## MySQL CONNECTION FUNCTION
connectAdult <- function(group) {
    
    if (!exists('adult_profiles', where=.GlobalEnv)) {
        adult_profiles <<- dbConnect(MySQL(), default.file=mysqlconf, group='client', dbname='adult_profiles')
    } else if (class(try(dbGetQuery(adult_profiles, "SELECT 1"))) == "try-error") {
        dbDisconnect(adult_profiles)
        adult_profiles <<- dbConnect(MySQL(), default.file=mysqlconf, group='client', dbname='adult_profiles')
    }
    
    return(adult_profiles)
}

## GLOBAL OPTIONS
options(sqldf.driver = "SQLite")    ## USE SQLite DRIVER FOR SQLDF. PREVENTS CONFLICT WITH RMySQL

## DEFINE MySQL CONFIGURATION FILE LOCATION
mysqlconf <- "/home/bogdan/R-Programs/connection.cnf"

## DEFINE CHOICES
load(file = "assets/countyChoices.Rda")

## COMMON TEXT
table_footer <- "<span class='table-footer'><strong>*</strong> Statistically significant difference between county and state at p < 0.05. <br> <span style='color: red; font-weight: bold;'>†</span> Estimate should be interpreted with caution because it is either unstable (coefficient of variation &ge;40%) or it has a wide confidence interval (&gt;20%).</span>"