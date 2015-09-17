body <- dashboardBody(
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "chis.css")
    ),
    fluidRow(
        tabItems(
            tabItem(tabName = "home", source("assets/ui/layouts/home.R", local = TRUE)[1]),
            tabItem(tabName = "adultHealthProfiles", source("assets/ui/layouts/adult_profiles.R", local = TRUE)[1])
        )
    )
)