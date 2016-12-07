library(RSQLite) 
library(DT) 
library(xtable) 
library(DBI) 

source("server/cSpilt.R",local=TRUE) 

observe({ 
  
  sqlitePath <- "/home/hy/R/GEOmetadb.sqlite" 
  table <- "gsm" 
  gse <-"gse" 
  series_id <- "GSE31210" 
  name <- "characteristics_ch1" 
  ttable <- "gse_gsm" 
  # Connect to the database 
  
  db <- dbConnect(RSQLite::SQLite(), sqlitePath) 
  
  
  sqlInput<-reactive({ 
    paste("SELECT %s FROM %s where %s IN (SELECT %s FROM %s Where %s='%s')",name,table,table, table,ttable,gse,series_id) 
    # query <- sprintf("Select gsm, characteristics_ch1  From gsm Where gsm IN ( Select gsm From gse_gsm Where gse = 'GSE31210')") 
  }) 
  sqlOutput<-reactive({data<-dbGetQuery(db, query)}) 
  datasql <-DT::renderDataTable(sqlOutput,server=TRUE) 
  
  #datatable(loadData()) 
  #dtable <- DT::datatable(loadData()) 
  seqfuntion <- reactive({  
    
    ddf = data.frame(datasql)[,]     
    
    dat_ub <- data.frame( 
      start = paste0(ddf,sep=";")  
    ) 
    
    dat_50K_ub <- do.call(rbind,replicate(1, dat_ub, FALSE)) 
    
    cSplit(dat_ub, c("start"), ";", direction="long") 
    df<-cSplit(dat_50K_ub, c("start"), ";")    
    first <-DT::datatable(df) 
    first  
  }) 
  output$summarytable <- seqfuntion() 

})
