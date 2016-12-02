downloadSeriesGEO<-function(){
  GSE <- getGEO(input$number,GSEMatrix = TRUE, AnnotGPL = FALSE, getGPL = FALSE)
  GSEmRNA <- exprs(GSE[[1]])[complete.cases(exprs(GSE[[1]])),]
  return(GSEmRNA)}