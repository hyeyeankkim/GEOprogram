sqlitePath <- "/home/hy/R/GEOmetadb.sqlite"
table <- "gsm"
gse <-"gse"
#series_id <- "GSE75271"
series_id <- "GSE31210"
name <- "characteristics_ch1"
ttable <- "gse_gsm"

db <- dbConnect(SQLite(), sqlitePath)
loadData <- function(){
  query <- sprintf("SELECT %s FROM %s where %s IN (SELECT %s FROM %s Where %s='%s')",name,table,table, table,ttable,gse,series_id)
  data <- dbGetQuery(db, query)
  data
}

m=loadData()
#m
#f=datatable(m)
# write.csv(m, file="mydata.csv")
#v <-read.csv(file = "mydata.csv",sep=";")

ddf = data.frame(m)[,]
#dtable <- DT::datatable(loadData())
#readdata<-read.table(file=loadData(),sep=";")
dat_ub <- data.frame(
  #header1 = LETTERS[1:2],
  start = paste0(ddf,sep=";")
  #end = paste0("")
  )

#dat_ub$id <- with(dat_ub)
#dat_ub
### Bigger versions of each of the above
dat_50K_ub <- do.call(rbind,replicate(1, dat_ub, FALSE))
#dat_50K_ub$id <- with(dat_50K_ub)

### Test it out!
cSplit(dat_ub, c("start"), ";", direction="long")
df<-cSplit(dat_50K_ub, c("start"), ";")
first <-DT::datatable(df)
first

