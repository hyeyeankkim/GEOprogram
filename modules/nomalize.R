GSEgRNA <- ReadAffy( celfile.path = GSE ) 
if(input$selectGroup=='RMA'){
  GSEgRNA <- rma(GSEgRNA)
}
GSEgRNA <- exprs(GSEgRNA)
print(GSEgRNA)
GSEgRNA <- GSEgRNA[complete.cases(GSEgRNA),]

return(GSEgRNA)
