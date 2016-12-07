data.series <-  getGEO("GSE3325",GSEMatrix = TRUE, AnnotGPL = FALSE, getGPL = FALSE)
data.platform = getGEO(GPL) 
data.index = match(GPL, sapply(data.series, annotation)) 
data.p = pData(data.series[[data.index]])       
data.expr = exprs(data.series[[data.index]]) 
common = intersect(colnames(data.expr), rownames(data.p)) 
m1 = match(common, colnames(data.expr)) 
m2 = match(common, rownames(data.p)) 
data.expr = data.expr[,m1] 
data.p = data.p[m2,] 
data.expr[which(data.expr <= 0)] <- NaN 
data.expr = log2(data.expr) 

############################################################################
format.it <-function(x, max) {
  x = x[x!=""]
  if (length(x) <= max) return(x)
  x[max] = " ..."
  return(x[1:max])
}

dataInput <- reactive({
 
  reactiveValues.reset()
  
  content = "Downloading Series (GSE) data from GEO" 

  createAlert(session, "alert1", alertId = "GSE-progress-alert", title = "Current Status", style = "success",
              content = content , append = TRUE, dismiss = FALSE) 
  code = paste0("data.series = getGEO(GEO = \"", GSE, "\", AnnotGPL = FALSE, getGPL = FALSE)")
  
  geo = try(getGEO(GEO = isolate(GSE), AnnotGPL=FALSE, getGPL = FALSE))
  
  if (class(geo) == "try-error") {
    content = "This is typically an indication that the GEO data is not in the correct format. Please select another dataset to continue. <p><p>The specific error appears below:<p>"
    content = paste0(content,  gsub("\n", "<p>",geo[[1]]))
    createAlert(session, "alert1", alertId = "GSE-error-alert", title = "Error downloading GEO dataset", style = "danger", content = content, append = FALSE, dismiss = TRUE)
    return(NULL) 
  }

})
Platforms <- reactive({
  #shinycat("In Platforms reactive...\n")
  if (is.null(dataInput())) {
    return(NULL)
  }
  #closeAlert(session, "GSE-progress-alert")  
  ans = as.character(sapply(dataInput(), annotation))   
#  ans 
})
platformIndex <- reactive({
  #  input$submitPlatform
  #shinycat("In platformIndex reactive...\n")
  #if (TEST.DATA) {
  #  return(1)
  #}
  if (is.null(dataInput()) | length(isolate(input$platform)) ==0) {
    return(NULL)
  }
  if (length(dataInput())==1) return (1)
  m = match((input$platform), as.character(sapply(dataInput(), annotation)))   
  if (is.na(m)) return(NULL)
  return(m)
})
exprInput <- reactive({
  #shinycat("In exprInput reactive...\n")
  pi = platformIndex()
  if (is.null(dataInput()) | is.null(pi)) {
    return(NULL)
  }
  pl=Platforms()[platformIndex()]
  code = paste0("data.index = match(\"", pl, "\", sapply(data.series, annotation))")
  code = paste0("data.expr = exprs(data.series[[data.index]])")
  ans = exprs(dataInput()[[pi]])
  return(ans)
})

########################################################################################
filename = function() {
  file = paste(GSE,"_",Sys.time(),"-clinical", ".csv", sep = "")
  file = gsub(":", "-",file)
  file = gsub(" ", "_",file)
  msg = paste0("<H4>Current Status</H4><p><strong>The clinical data has been downloaded to the following file: ", file, "</p>")
  createAlert(session,"ioAlert2",content = msg, style="success",dismiss=FALSE, append = FALSE)
  return(file)
}

# This function should write data to a file given to it by
# the argument 'file'.

content = function(file) {
  sep <- ","
  # Write to a file specified by the 'file' argument
  write.table(values.edit$table, file, sep = sep,
              row.names = TRUE, col.names = NA) 
}



vector.it <-function(x) {
  x = paste0("\"", x, "\"", collapse = ",")
  paste0("c(", x, ")")
}
values <- as.data.frame(pData(phenoData(object = dataInput()[[platformIndex()]])))
p= values.edit$table 
g=grep("characteristics",colnames(p))
print(p)

num.levels = apply(p, 2, function(x) nlevels(as.factor(x)))  
i = num.levels > 1 | 1:ncol(p) %in% g   

# keep source_name_ch1 and description   
keep = colnames(p) %in% c("source_name_ch1", "description")  

if (sum(keep) > 0) {  
  i[keep] = TRUE  
}  

if (sum(i) <= 1) {  
  i = 1:ncol(p)      
}  
p = p[,i, drop = FALSE]  

print(p)
## remove non-informative columns; but keep all if all columns would   
## be removed    
RM.COLS = c("status", "last_update_date", "submission_date",   
            "supplementary_file", "geo_accession")  
m = match(RM.COLS, colnames(p))  
print(m)
m=m[!is.na(m)]  
if (length(m) == ncol(p)) {  
  return(p)  
}   

if (length(m) > 0) p=p[,-m, drop = FALSE]  

m = match(colnames(exprInput()), rownames(p))  
m = m[!is.na(m)]  

if (sum(m) == 0) {  
  values.edit$table = p  
  return (p)  
}  


values.edit$table = p  
print(table)

