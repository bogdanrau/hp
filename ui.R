## LOAD EXTERNAL RESOURCES
source("global.R")
source("assets/ui/header.R", local = TRUE)
source("assets/ui/sidebar.R", local = TRUE) 
source("assets/ui/body.R", local = TRUE)

## DECLARE UI PAGE
dashboardPage(
    header,
    sidebar,
    body
)