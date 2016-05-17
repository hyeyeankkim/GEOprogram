
shinyServer(function(input,output){

	downloadSeriesGEO<-function(){
	  GSE <- getGEO(input$number)
	GSEmRNA <- exprs(GSE[[1]])[complete.cases(exprs(GSE[[1]])),]
	  return(GSEmRNA)
	}
	downloadRawGEO <- function(){
	GSE <- getGEOSuppFiles(input$number)
	setwd(input$number)
	untar(list.files()[2])
	GSEmRNA <- ReadAffy()
	GSEmRNA<- rma(GSEmRNA)
	GSEmRNA <- exprs(GSEmRNA)
	GSEmRNA <- GSEmRNA[complete.cases(GSEmRNA),]
	setwd("../")
	return(GSEmRNA)
	}
	normalizeSom <- function(){
	colnamesSAVE <- colnames(GSEmRNA)
	GSEmRNA <- normalize(GSEmRNA)
	colnames(GSEmRNA) <- colnamesSAVE
	return(GSEmRNA)
	}

	output$downloadData <- downloadHandler(
	filename = function() {paste(input$dataset, '.csv',sep='')},
	content = function(file1){
	write.csv(datasetInput(),file1)
	}

	)
	output$content <- renderTable({
	infile <- input$file1
	if(is.null(inFile))
	return(NULL)
	read.table(inFile$datapath,header=input$header, sep=input$sep)})
	output$dataBoxplot <- renderPlot({
	input$Gobutton
	if(input$Gobutton==0){return()}
	else{
	if(input$checkGroup=='Series matrix file'){
	GSEmRNA <- downloadSeriesGEO()
	boxplot(GSEmRNA)}
	if(input$checkGroup== 'Raw data CEL files'){
	GSEmRNA  <- downloadRawGEO()
	if(is.null(infile)){
	  return(NULL)
	}else{
	  file.copy(input$fileUpload$datapath,"/home/hy/R/bioexample")
	}
	boxplot(GSEmRNA)
	}}
	  
	#if(input$NormalizeButton ==0){return()}
	#else{
	#GSEmRNA <- normalizeSom(GSEmRNA)
	#boxplot(GSEmRNA)
	#}
	#if(input$LogTransformButton==0){return()}
	#else{
	#GSEmRNA <- log(GSEmRNA,2)
	#boxplot(GSEmRNA)
	#}    if(is.null(infile)){
	
	})
	})
