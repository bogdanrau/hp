column(12, 
       fluidRow(
           column(2, selectInput("countyYearSelect", label = "Select a Year:", choices=list("2012-2013"))),
           column(3, selectInput("countyCountySelect", label = "Select a County:", choices=countyChoices)),
           column(1, actionButton("countyGetData", label = "Get Data!", icon = icon("search")))
       ),
       fluidRow(
           conditionalPanel("input.countyYearSelect == '2012-2013' && input.countyGetData > 0", source("assets/ui/layouts/adult1213.R", local = TRUE)[1])
           )
)