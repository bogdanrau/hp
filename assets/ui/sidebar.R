sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Home", tabName = "home", icon = icon("home")),
        menuItem("County Profiles", tabName = "countyProfiles", icon = icon("square"),
                 menuSubItem("Adult Health Profiles", tabName = "adultHealthProfiles", icon = icon("users")),
                 menuSubItem("Child & Teen Health Profiles", tabName = "childTeenHealthProfiles", icon = icon("child"))
        ),
        menuItem("Legislative Profiles", tabName = "legislativeProfiles", icon = icon("gavel")),
        menuItem("Race & Ethnic Profiles", tabName = "raceEthnicProfiles", icon = icon("star-o")),
        menuItem("Methodology & Notes", tabName = "methodologyNotes", icon = icon("info-circle"))
    )
)