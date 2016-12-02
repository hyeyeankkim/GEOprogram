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
}