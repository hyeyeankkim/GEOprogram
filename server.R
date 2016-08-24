
shinyServer(function(input,output){

	downloadSeriesGEO<-function(){
	  GSE <- getGEO(input$number,GSEMatrix = TRUE)
	  GSEmRNA <- exprs(GSE[[1]])[complete.cases(exprs(GSE[[1]])),]
	  return(GSEmRNA)
	  }
	
	downloadRawGEO <- function(){

	  GSE <- input$number
	 if(!file.exists(GSE)){
	    getGEOSuppFiles(GSE)
	    # root setting
	    setwd("/home/hy/R/bioexample/")
	    COMPRESSED_CELS_DIRECTORY <- GSE 
	    untar( paste( GSE , paste( GSE , "RAW.tar" , sep="_") , sep="/" ), exdir=COMPRESSED_CELS_DIRECTORY) 
	    cels <- list.files( COMPRESSED_CELS_DIRECTORY , pattern = "[gz]") 
	    sapply( paste( COMPRESSED_CELS_DIRECTORY , cels, sep="/") , gunzip ) 
	  }
	 
	  GSEgRNA <- ReadAffy( celfile.path = GSE ) 
	  if(input$selectGroup=='RMA'){
	    GSEgRNA <- rma(GSEgRNA)}
	  if(input$selectGroup=='MAS5'){
	   GSEgRNA <- mas5(GSEgRNA)}
	  #need
	  GSEgRNA <- exprs(GSEgRNA)
	  #print(GSEgRNA)
	  GSEgRNA <- GSEgRNA[complete.cases(GSEgRNA),]
	  return(GSEgRNA)
	  
	  output$summary<-renderTable({
	    source("server/server-summary.R",local=TRUE)
	  })
	  
	  
	  }

	output$downloadData <- downloadHandler(
	filename = function() {paste(input$dataset, '.csv',sep='')},
	content = function(file1){
	write.csv(datasetInput(),file1)
	}
	)
	
        source("server/server-renderTable.R",local=TRUE)
	source("server/server-renderPlot.R",local=TRUE)

	})
