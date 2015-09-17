## LOAD EXTERNAL RESOURCES
source("global.R")

## DECLARE SHINY SERVER
shinyServer(function(input, output, session) {
    ## OPEN MySQL CONNECTIONS
    adult_profiles <- connectAdult()
    
    ## ADULT PROFILES
    source("assets/server/adult_profiles.R", local = TRUE)[1]
    
})