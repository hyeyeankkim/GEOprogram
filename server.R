 shinyServer(function(input,output){
   observe(
   if(input$Gobutton==0){return()}
   
   else{
	 downloadSeriesGEO<-function(){
	  GSE <- getGEO(input$number,GSEMatrix = TRUE, AnnotGPL = FALSE, getGPL = FALSE)
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
	    GSEgRNA <- rma(GSEgRNA)
	    #print(GSEgRNA)
	    #print("aa")
	    }
	  
	  
	  if(input$selectGroup=='MAS5'){
	   GSEgRNA <- mas5(GSEgRNA)  }
	  #need
	  #print(GSEgRNA)
	  GSEgRNA <- exprs(GSEgRNA)
	  print(GSEgRNA)
	  GSEgRNA <- GSEgRNA[complete.cases(GSEgRNA),]
	  
	  return(GSEgRNA)
	  }

	

  source("server/server-renderTable.R",local=TRUE)
#	source("server/server-summary.R",local=TRUE)
#	source("server/cSpilt.R",local=TRUE)
	source("server/server-renderPlot.R",local=TRUE)

   }
   )
	})
