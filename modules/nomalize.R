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
