## ETHNICITY BREAKDOWN
eDonut <- function(county, colors = NULL) {
    ## GET DATA
    suppressWarnings(raceTable <- isolate(dbGetQuery(adult_profiles, paste0("SELECT variable_id, variable_estimate FROM data_1213 WHERE region_id = '", county, "' AND variable_id IN ('white', 'latino', 'asian', 'black', 'other')"))))
    raceTable$variable_estimate <- round(raceTable$variable_estimate, 1)
    
    suppressWarnings(raceMetadata <- isolate(dbGetQuery(adult_profiles, paste0("SELECT variable_id, variable_name FROM metadata_1213 WHERE variable_id IN ('white', 'latino', 'asian', 'black', 'other')"))))
    raceLabel <- c(raceMetadata[4,2], raceMetadata[3,2], raceMetadata[2,2], raceMetadata[1,2], raceMetadata[5,2])
    
    raceData <- c(raceTable[4,2], raceTable[3,2], raceTable[2,2], raceTable[1,2], raceTable[5,2])
    raceFinal <- data.frame(raceLabel, raceData)
    
    d1 <- nPlot(x = 'raceLabel', y = 'raceData', data = raceFinal, type = 'pieChart')
    
    d1$chart(donut = TRUE, width = 400, height = 400, color = list("#FF9933", "#99C2FF", "#00527A", "#A8BC80", "#293D00"))
    
    d1$chart(tooltipContent = "#! function(key, y, e, graph){
        var format = d3.format('.1f');
        return '<p>' + key + '</p>' + 
        '<p>' + '<strong>Estimate: ' + format(e.point.raceData) + '%</strong></p>'
        } !#")
    
    ## PRINT MESSAGE & TABLE
    message("Data Loaded Into Donut")
    print(raceFinal)
    
    ## GENERATE GRAPH
    d1
    
}

## POPULATION PYRAMID
nPyramid <- function(county, colors = NULL) {    
    ## GET DATA
    suppressWarnings(ageTable <- isolate(dbGetQuery(adult_profiles, paste0("SELECT variable_id, variable_estimate FROM data_1213 WHERE region_id = '", county, "' AND variable_id IN ('age_1824', 'age_2539', 'age_4064', 'age_6579', 'age_80')"))))
    ageTable$Type <- 'County'
    ageTable$variable_estimate <- round(ageTable$variable_estimate, 1)
    ageTable$variable_estimate <- -1 * ageTable$variable_estimate
    
    suppressWarnings(ageTableState <- isolate(dbGetQuery(adult_profiles, "SELECT variable_id, variable_estimate FROM data_1213 WHERE region_id = '1' AND variable_id IN ('age_1824', 'age_2539', 'age_4064', 'age_6579', 'age_80')")))
    ageTableState$Type <- 'California'
    ageTableState$variable_estimate <- round(ageTableState$variable_estimate, 1)
    
    suppressWarnings(ageMetadata <- isolate(dbGetQuery(adult_profiles, paste0("SELECT variable_id, variable_name FROM metadata_1213 WHERE variable_id IN ('age_1824', 'age_2539', 'age_4064', 'age_6579', 'age_80')"))))
    
    finalData <- rbind(ageTable, ageTableState)
    finalData <- merge(ageMetadata, finalData, by = 'variable_id')
    finalData$abs <- abs(finalData$variable_estimate)
    finalData <- finalData[,2:5]
    
    finalData <- rename(finalData, c("variable_name" = "Age Group", "variable_estimate" = "Estimate"))
    
    n1 <- nPlot(
        y = 'Estimate',
        x = 'Age Group',
        group = 'Type',
        type = 'multiBarHorizontalChart',
        data = finalData
    )
    
    n1$chart(stacked = TRUE)
    
    n1$chart(tooltipContent = "#! function(key, x, y, e){
        var format = d3.format('.1f');
        return '<p>' + x + '</p>' + 
        '<p>' + '<strong>Estimate: ' + format(e.point.abs) + '%</strong></p>'
        } !#")
    
    n1$yAxis(axisLabel = 'Estimate', tickFormat = "#! function(d) {
             return d3.format(', 02f')(Math.abs(d))
             } !#")
    
    n1$chart(color = c("#367fa9", "#FF9933"), height = 250, width = 500)
    
    ## PRINT MESSAGE AND TABLE
    message("Data Loaded Into Pyramid")
    print(finalData)
    
    ## GENERATE GRAPH
    n1
}

## TWO-BAR
twoBar <- function(county, variable_id, colors = NULL, width = 500, height = 120) {
    ## GET DATA
    suppressWarnings(countyData <- isolate(dbGetQuery(adult_profiles, paste0("SELECT variable_id, variable_estimate, variable_lb, variable_ub, variable_cv, variable_se, variable_p FROM data_1213 WHERE region_id = '", county, "' AND variable_id = '", variable_id, "'"))))
    countyData <- rename(countyData, c("variable_estimate"="Estimate"))
    countyData$Type <- 'County'

    
    suppressWarnings(stateData <- isolate(dbGetQuery(adult_profiles, paste0("SELECT variable_id, variable_estimate, variable_lb, variable_ub, variable_cv, variable_se, variable_p FROM data_1213 WHERE region_id = '1' AND variable_id = '", variable_id, "'"))))
    stateData <- rename(stateData, c("variable_estimate"="Estimate"))
    stateData$Type <- 'California'
    
    finalData <- rbind(countyData, stateData)
    finalData <- finalData[, -1]
    finalData$Estimate <- sprintf("%.1f", round(finalData$Estimate, 1))
    finalData$textimate <- ifelse(finalData$variable_p < 0.05, paste0(finalData$Estimate, "*"), finalData$Estimate)
    finalData$textimate <- ifelse(finalData$Type == 'County' && finalData$variable_cv >= 40 | (finalData$variable_ub - finalData$variable_lb) > 25, paste0(finalData$textimate, "†"), finalData$textimate)
    finalData[2,8] <- finalData[2,1]

    
    
    finalData$variable_lb <- sprintf("%.1f", round(finalData$variable_lb, 1))
    finalData$variable_ub <- sprintf("%.1f",round(finalData$variable_ub, 1))
    
    finalData <- rename(finalData, c("variable_lb" = "lb", "variable_ub" = "ub"))
    
    b1 <- nPlot(Estimate~Type, data = finalData, type = 'multiBarHorizontalChart')
    
    b1$chart(forceY=c(0,100),barColor = c('#367fa9', '#FF9933'), width = width, height = height, showLegend = FALSE, showControls = FALSE, showValues = TRUE)
    b1$chart(valueFormat="#!d3.format('.1f')!#")
    b1$chart(tooltipContent = "#! function(key, x, y, e){
        var format = d3.format('.1f');
        return '<p>' + x + '</p>' + 
        '<p>' + '<strong>Estimate: ' + e.point.textimate + '</strong></p>' + '<p><center>(' + e.point.lb + ' - ' + e.point.ub + ')</center></p>'
        } !#")
    
    b1$yAxis(axisLabel = 'Estimate', tickFormat = "#! function(d) {
             return d3.format(', 02f')(Math.abs(d))
             } !#")
    
    ## PRINT MESSAGE AND TABLE
    message("Data Loaded Into Chart")
    print(finalData)
    
    ## GENERATE GRAPH
    b1
}

## INSURANCE PYRAMID
iPyramid <- function(county, colors = NULL) {    
    ## GET DATA
    suppressWarnings(insuranceTable <- isolate(dbGetQuery(adult_profiles, paste0("SELECT variable_id, variable_estimate FROM data_1213 WHERE region_id = '", county, "' AND variable_id IN ('uninsured', 'ebi', 'medical', 'private_insurance')"))))
    insuranceTable$Type <- 'County'
    insuranceTable$variable_estimate <- round(insuranceTable$variable_estimate, 1)
    insuranceTable$variable_estimate <- -1 * insuranceTable$variable_estimate
    
    suppressWarnings(insuranceTableState <- isolate(dbGetQuery(adult_profiles, "SELECT variable_id, variable_estimate FROM data_1213 WHERE region_id = '1' AND variable_id IN ('uninsured', 'ebi', 'medical', 'private_insurance')")))
    insuranceTableState$Type <- 'California'
    insuranceTableState$variable_estimate <- round(insuranceTableState$variable_estimate, 1)
    
    suppressWarnings(insuranceMetadata <- isolate(dbGetQuery(adult_profiles, paste0("SELECT variable_id, variable_name FROM metadata_1213 WHERE variable_id IN ('uninsured', 'ebi', 'medical', 'private_insurance')"))))
    
    finalData <- rbind(insuranceTable, insuranceTableState)
    finalData <- merge(insuranceMetadata, finalData, by = 'variable_id')
    finalData$abs <- abs(finalData$variable_estimate)
    finalData <- finalData[,2:5]
    
    finalData <- rename(finalData, c("variable_name" = "Insurance Status", "variable_estimate" = "Estimate"))
    
    i1 <- nPlot(
        y = 'Estimate',
        x = 'Insurance Status',
        group = 'Type',
        type = 'multiBarHorizontalChart',
        data = finalData
    )
    
    i1$chart(stacked = TRUE, margin = list(left = 100))
    
    i1$chart(tooltipContent = "#! function(key, x, y, e){
        var format = d3.format('.1f');
        return '<p>' + x + '</p>' + 
        '<p>' + '<strong>Estimate: ' + format(e.point.abs) + '%</strong></p>'
        } !#")
    
    i1$yAxis(axisLabel = 'Estimate', tickFormat = "#! function(d) {
             return d3.format(', 02f')(Math.abs(d))
             } !#")
    
    i1$chart(color = c("#367fa9", "#FF9933"), height = 250, width = 550)
    
    ## PRINT MESSAGE AND TABLE
    message("Data Loaded Into Pyramid")
    print(finalData)
    
    ## GENERATE GRAPH
    i1
}


## TABLES
dTable <- function(county, variable_category) {
    
    suppressWarnings(variableMetadata <- isolate(dbGetQuery(adult_profiles, paste0("SELECT variable_id, variable_name FROM metadata_1213 WHERE variable_category = '", variable_category, "'"))))
    suppressWarnings(countyEstimates <- isolate(dbGetQuery(adult_profiles, paste0("SELECT variable_id, variable_estimate, variable_se, variable_lb, variable_ub, variable_cv, variable_p FROM data_1213 WHERE region_id = '", county, "' AND variable_id IN (", paste0("'", variableMetadata$variable_id, "'", collapse = ","), ")"))))
    suppressWarnings(stateEstimates <- isolate(dbGetQuery(adult_profiles, paste0("SELECT variable_id, variable_estimate, variable_se, variable_lb, variable_ub, variable_cv, variable_p FROM data_1213 WHERE region_id = '1' AND variable_id IN (", paste0("'", variableMetadata$variable_id, "'", collapse = ","), ")"))))
 
    countyEstimates$county_estimate <- sprintf("%.01f", round(countyEstimates$variable_estimate, 1))
    countyEstimates$county_estimate <- ifelse(countyEstimates$variable_p < 0.05, paste0(countyEstimates$county_estimate, "*"), countyEstimates$county_estimate)
    countyEstimates$county_estimate <- ifelse(countyEstimates$variable_cv >= 40 | (countyEstimates$variable_ub - countyEstimates$variable_lb) > 25, paste0(countyEstimates$county_estimate, "<span style='color: red; font-size: 13px; font-style: italic;'>†</span>"), countyEstimates$county_estimate)
    countyEstimates$county_CI <- paste0("(", sprintf("%.01f", round(countyEstimates$variable_lb, 1)), " - ", sprintf("%.01f", round(countyEstimates$variable_ub, 1)), ")")
    countyEstimates$county_value <- paste0("<center><strong>", countyEstimates$county_estimate, "</strong><br /><span style='font-size: 12px;'>", countyEstimates$county_CI, "</span></center>")
    
    stateEstimates$state_estimate <- sprintf("%.01f", round(stateEstimates$variable_estimate, 1))
    stateEstimates$state_CI <- paste0("(", sprintf("%.01f", round(stateEstimates$variable_lb, 1)), " - ", sprintf("%.01f", round(stateEstimates$variable_ub, 1)), ")")
    stateEstimates$state_value <- paste0("<center><strong>", stateEstimates$state_estimate, "</strong><br /><span style='font-size: 12px;'>", stateEstimates$state_CI, "</span></center>")
    
    countyFinal <- join(variableMetadata, countyEstimates, by = 'variable_id')
    allFinal <- join(countyFinal, stateEstimates, by = 'variable_id')
    allFinal <- allFinal[, c(2, 11, 20)]
    
    customHeader <- htmltools::withTags(table(
        class = 'display',
        thead(
            tr(
                th(rowspan = 2, style = 'border-bottom: 3px solid #367FA9;', 'Health Indicator'),
                th(colspan = 1, style = 'border-bottom: none; background-color: #F0F5FF; color: #367fa9;', HTML('<center>County</center>')),
                th(colspan = 1, style = 'border-bottom: none; color: #FF9933;', HTML('<center>California</center>'))),
            tr(
                th(style = 'background-color: #F0F5FF; color: #367fa9; border-bottom: 3px solid #367FA9;', HTML("%<br /><span style = 'font-size: 11px;'>(95% CI)</span>")),
                th(style = 'color: #FF9933; border-bottom: 3px solid #367FA9;', HTML("%<br /><span style = 'font-size: 11px;'>(95% CI)</span>"))))))
    
    ## PRINT MESSAGE AND TABLE
    message("Data Loaded Into Table")
    print(allFinal)
    
    DT::datatable(allFinal,
                  options = list(
                      columnDefs = list(list(className = 'dt-center', targets = c(1,2))),
                      ordering = FALSE,
                      dom = "t"
                  ),
                  rownames = FALSE,
                  escape = FALSE,
                  container = customHeader
                  
    ) %>%
        
        formatStyle('state_value', color = '#FF9933') %>%
        formatStyle('county_value', color = '#367fa9', backgroundColor = '#F0F5FF')
    

}