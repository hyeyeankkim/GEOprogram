
shinyServer(function(input,output){

	downloadSeriesGEO<-function(){
	  GSE <- getGEO(input$number,GSEMatrix = TRUE)
	  GSEmRNA <- exprs(GSE[[1]])[complete.cases(exprs(GSE[[1]])),]
	  return(GSEmRNA)
	  }
	
	downloadRawGEO <- function(){
	  GSE<- getGEOSuppFiles(input$number)
	  # root setting
	  setwd("/home/hy/R/bioexample/")
	  #data<-get(input$number)
	  class(input$number)
	  #print(input$number)
	  #inputFile <- data
	  #outputFile = paste(normalizePath(dirname(".")),"\\", inputFile, sep = "")
	  untar(list.files()[2])
	  GSEgRNA <- ReadAffy()
	  #source("server/server-readAffy.R",local=TRUE)
	  GSEgRNA <- rma(GSEgRNA)
	  GSEgRNA <- exprs(GSEgRNA)
	  GSEgRNA <- GSEgRNA[complete.cases(GSEgRNA),]
	  return(GSEgRNA)
	  }

	output$downloadData <- downloadHandler(
	filename = function() {paste(input$dataset, '.csv',sep='')},
	content = function(file1){cannot coerce type 'closure' to vector of type 'character'
	write.csv(datasetInput(),file1)
	}
	)
	
  source("server/server-renderTable.R",local=TRUE)
	source("server/server-renderPlot.R",local=TRUE)
	
 
	})
