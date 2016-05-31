observe({
  output$dataBoxplot <- renderPlot({
  input$Gobutton
  if(input$Gobutton==0){return()}
  else{
    if(input$checkGroup=='Series matrix file'){
      GSEmRNA <- downloadSeriesGEO()
      boxplot(GSEmRNA)
      }
    if(input$checkGroup== 'Raw data CEL files'){
      GSEgRNA  <- downloadRawGEO()
      boxplot(GSEgRNA)
    }
  }
})
  
})
