## OUTPUT REGION NAME
output$regionName <- renderText({
    input$countyGetData
    
    regionName <- isolate(dbGetQuery(adult_profiles, paste0("SELECT DISTINCT region_name FROM data_1213 WHERE region_id = '", input$countyCountySelect, "'")))
    print(regionName[1,1])
})


## OUTPUT TOTAL POPULATION
output$totalPopulation <- renderText({
    input$countyGetData
    
    totalPopulation <- isolate(dbGetQuery(adult_profiles, paste0("SELECT DISTINCT region_name, region_population FROM data_1213 WHERE region_id = '", input$countyCountySelect, "'")))
    totalPopulation <- format(totalPopulation[1,2], big.mark = ",")
    print(totalPopulation)
})


## RACE BREAKDOWN
output$raceBreakdown <- renderChart2({
    input$countyGetData
    
    isolate({
        county = input$countyCountySelect
        eDonut(county)
    })
    
})


## AGE PYRAMID
output$ageBreakdown <- renderChart2({
    input$countyGetData
    
    isolate({
        county = input$countyCountySelect
        nPyramid(county)})
    
})


## 200% FPL BREAKDOWN
output$fplBreakdown <- renderChart2({
    input$countyGetData
    variable_id = 'fpl_200'
    
    isolate({
        county = input$countyCountySelect
        twoBar(county, variable_id, width = 500, height = 120)
    })
    
})


## INSURANCE BREAKDOWN
output$insuranceBreakdown <- renderChart2({
    input$countyGetData
    
    isolate({
        county = input$countyCountySelect
        iPyramid(county)
    })
    
})


## NO USUAL SOURCE OF CARE
output$socr <- renderChart2({
    input$countyGetData
    variable_id = 'socr'
    
    isolate({
        county = input$countyCountySelect
        twoBar(county, variable_id, width = 400, height = 120)
    })
    
})


## DELAY IN RECEIVING CARE
output$dly <- renderChart2({
    input$countyGetData
    variable_id = 'dly'
    
    isolate({
        county = input$countyCountySelect
        twoBar(county, variable_id, width = 400, height = 120)
    })
    
})


## HEALTH BEHAVIORS TABLE
output$healthBehaviors <- DT::renderDataTable({
    input$countyGetData
    variable_category = "health_behaviors"
    
    isolate({
        county = input$countyCountySelect
        dTable(county, variable_category)
    })
    
})


## HEALTH OUTCOMES TABLE
output$healthOutcomes <- DT::renderDataTable({
    input$countyGetData
    variable_category = "health_outcomes"
    
    isolate({
        county = input$countyCountySelect
        dTable(county, variable_category)
        
    })
})

## OTHER FACTORS TABLE
output$otherFactors <- DT::renderDataTable({
    input$countyGetData
    variable_category = "other_factors"
    
    isolate({
        county = input$countyCountySelect
        dTable(county, variable_category)
        
    })
})