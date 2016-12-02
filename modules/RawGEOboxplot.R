if(input$checkGroup== 'Raw data CEL files'){
  
  GSEgRNA  <- downloadRawGEO()
  boxplot(GSEgRNA)
  
  
}