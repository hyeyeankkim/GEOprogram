library(GEOquery) 
library(reshape2) 
library(survival) 
library(ggplot2) 
library(GGally) 
library(survMisc) 
library(limma)

observe({
  output$dataBoxplot <- renderPlot({
  input$Gobutton
  if(input$Gobutton==0){return()}
  else{
    if(input$checkGroup=='Series matrix file'){
      #GSEmRNA <- downloadSeriesGEO()
      #p = GSEmRNA
      #boxplot(GSEmRNA)
      #GPL = "GPL570"
      data.series <- getGEO(input$number, AnnotGPL = FALSE, getGPL = FALSE,GSEMatrix = TRUE) 
      #data.series = GSE
      data.platform = getGEO(GPL) 
      data.index = match(GPL, sapply(data.series, annotation)) 
      data.p = pData(data.series[[data.index]])       
      
      #   output$summary<-renderTable({
      #    source("server/server-summary.R",local=TRUE)
      #  })
      
      data.expr = exprs(data.series[[data.index]]) 
      common = intersect(colnames(data.expr), rownames(data.p)) 
      m1 = match(common, colnames(data.expr)) 
      m2 = match(common, rownames(data.p)) 
      data.expr = data.expr[,m1] 
      data.p = data.p[m2,] 
      data.expr[which(data.expr <= 0)] <- NaN 
      data.expr = log2(data.expr) 
      g=grep("characteristics",colnames(p))
      
      values.edit <- reactiveValues(table = NULL, platformGeneColumn = NULL, original = NULL, log2 = FALSE, profilesPlot = FALSE, autogen = TRUE, norm = 1, norm.open = FALSE) 
      reproducible <-reactiveValues(report = NULL) 
      KM <- reactiveValues(time.col = NULL, outcome.col = NULL, generated = FALSE,  
                           eventYes = NULL, eventNo = NULL, xlab = "Time", ylab = "Survival", hr.format = "high/low",col = c("darkblue", "darkred"))
      
      #print(values.edit)
      #print(KM)
      
      ## generate boxplot of expression profiles ## 
      title = "samples"  
      s.num = 1:ncol(data.expr) 
      n = ncol(data.expr) 
      if (n > 30) { 
        s.num = sample(1:n, 30) 
        title = "selected samples" 
      } 
      title = paste0(GSE, "/", GPL, " ", title) 
      fixed.df <- as.data.frame(x=data.expr[,s.num], stringsAsFactors = FALSE) 
      x1 <- reshape2::melt(fixed.df, na.rm = TRUE, id.vars = NULL, 
                           variable.name = "variable", value.name = "value") 
      #print(x1)
      exp.prof.plot <- ggplot(x1, aes(variable, value)) + 
        geom_boxplot(outlier.colour = "green") + 
        labs(title = title, y = "log2 expression", x = "") + 
        theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
      
      print(exp.prof.plot) 

    }
    
    if(input$checkGroup== 'Raw data CEL files'){
     
      GSEgRNA  <- downloadRawGEO()
      #boxplot(GSEgRNA)
      p = GSEgRNA
      GPL = "GPL570"
      data.series <- getGEO(GEO=GSE, AnnotGPL = FALSE, getGPL = FALSE,GSEMatrix = TRUE) 
      data.platform = getGEO(GPL) 
      data.index = match(GPL, sapply(data.series, annotation)) 
      data.p = pData(data.series[[data.index]])       
      
      #   output$summary<-renderTable({
      #    source("server/server-summary.R",local=TRUE)
      #  })
      
      data.expr = exprs(data.series[[data.index]]) 
      common = intersect(colnames(data.expr), rownames(data.p)) 
      m1 = match(common, colnames(data.expr)) 
      m2 = match(common, rownames(data.p)) 
      data.expr = data.expr[,m1] 
      data.p = data.p[m2,] 
      data.expr[which(data.expr <= 0)] <- NaN 
      data.expr = log2(data.expr) 
      g=grep("characteristics",colnames(p))
      
      values.edit <- reactiveValues(table = NULL, platformGeneColumn = NULL, original = NULL, log2 = FALSE, profilesPlot = FALSE, autogen = TRUE, norm = 1, norm.open = FALSE) 
      reproducible <-reactiveValues(report = NULL) 
      KM <- reactiveValues(time.col = NULL, outcome.col = NULL, generated = FALSE,  
                           eventYes = NULL, eventNo = NULL, xlab = "Time", ylab = "Survival", hr.format = "high/low",col = c("darkblue", "darkred"))
      
      #print(values.edit)
      #print(KM)
      
      ## generate boxplot of expression profiles ## 
      title = "samples"  
      s.num = 1:ncol(data.expr) 
      n = ncol(data.expr) 
      if (n > 30) { 
        s.num = sample(1:n, 30) 
        title = "selected samples" 
      } 
      title = paste0(GSE, "/", GPL, " ", title) 
      fixed.df <- as.data.frame(x=data.expr[,s.num], stringsAsFactors = FALSE) 
      x1 <- reshape2::melt(fixed.df, na.rm = TRUE, id.vars = NULL, 
                           variable.name = "variable", value.name = "value") 
      #print(x1)
      exp.prof.plot <- ggplot(x1, aes(variable, value)) + 
        geom_boxplot(outlier.colour = "green") + 
        labs(title = title, y = "log2 expression", x = "") + 
        theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
      
      print(exp.prof.plot) 
      
    }
  }
})
  
})

