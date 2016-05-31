observe({
  output$content <- renderTable({
  infile <- input$file1
  if(is.null(infile)){
    return(NULL)
  }
  read.table(infile$datapath,header=input$header, sep=input$sep)})
})
