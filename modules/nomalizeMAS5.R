GSEgRNA <- ReadAffy( celfile.path = GSE ) 
if(input$selectGroup=='MAS5'){
  GSEgRNA <- mas5(GSEgRNA)  }
GSEgRNA <- exprs(GSEgRNA)
print(GSEgRNA)
GSEgRNA <- GSEgRNA[complete.cases(GSEgRNA),]

return(GSEgRNA)
