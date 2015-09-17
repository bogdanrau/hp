column(width = 12,
       fluidRow(column(width = 12, h3(textOutput("regionName")))),
       fluidRow(
           box(
               title = "Demographics",
               status = "primary",
               solidHeader = FALSE,
               collapsible = TRUE,
               width = 12,
               HTML("<p><strong>Estimated Population:</strong>"), textOutput("totalPopulation", inline = TRUE), HTML(" adults ages 18+. Estimates are based on the 2012-2013 California Health Interview Survey (CHIS).</p>"),
               fluidRow(column(width = 5, showOutput("raceBreakdown", "nvd3")),
                        column(width = 5, HTML("<p><strong>Adult Age Groups (5-level)</strong></p>"), showOutput("ageBreakdown", "nvd3"), HTML("<p><strong>Adults with income less than 200% FPL</strong></p>"), showOutput("fplBreakdown", "nvd3")))
           ),
           box(
               title = "Access & Utilization",
               status = "primary",
               solidHeader = TRUE,
               collapsible = TRUE,
               width = 12,
               fluidRow(
                   column(width = 5, HTML("<div id='fplSection'><p><strong>No usual source of care</strong></p>"), showOutput("socr", "nvd3"), HTML("</div>"), br(), HTML("<p><strong>Delayed getting prescription drugs or medical services</strong></p>"), showOutput("dly", "nvd3")),
                   column(width = 6, showOutput("insuranceBreakdown", "nvd3"))
                )
           ),
           box(
               title = "Health Behaviors",
               status = "primary",
               solidHeader = TRUE,
               collapsible = TRUE,
               width = 12,
               fluidRow(
                   column(width = 12, DT::dataTableOutput('healthBehaviors'), HTML(table_footer))
                   )
               ),
           box(
               title = "Health Outcomes",
               status = "primary",
               solidHeader = TRUE,
               collapsible = TRUE,
               width = 12,
               fluidRow(
                   column(width = 12, DT::dataTableOutput('healthOutcomes'), HTML(table_footer))
                   )
               ),
           box(
               title = "Other Factors",
               status = "primary",
               solidHeader = TRUE,
               collapsible = TRUE,
               width = 12,
               fluidRow(
                   column(width = 12, DT::dataTableOutput('otherFactors'), HTML(table_footer))
                   )
               )
       ))