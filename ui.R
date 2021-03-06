library(shiny)
library(affy)
library(RCurl)
library(GEOquery)
library(som)
library(DT)
library(shinyjs)
library(RSQLite)


shinyUI(fluidPage(
	mainPanel(pageWithSidebar(
	headerPanel("Dataset Selection"),
  sidebarPanel(
		tabsetPanel(
			tabPanel("Download dataset from GEO",value=1),
			tabPanel("Upload your own dataset", value=2),
			id="conditionedPanels"
		),
		conditionalPanel(condition="input.conditionedPanels=='1'",
				textInput("number","Enter a dataset name e.g. GSE3325 : ",value=""),
				actionButton("Gobutton","Download"),
				radioButtons("checkGroup",label = h3("Select type of dataset file"),
				choices = list('Series matrix file','Raw data CEL files'), selected =NULL),
				selectInput("selectGroup",label = h3("Select type of nomarlize"),
				            choices = list('RMA','MAS5'), selected ="RMA"),htmlOutput('pdfviewer'),
				radioButtons(inputId="var3",label="Select the file type",choices = list("png","pdf"))
				),
		conditionalPanel(condition="input.conditionedPanels=='2'",
			fileInput('file1', 'Choose CSV File',
					accept = c('text/csv',
			   		'text/comma-separated-values,text/plain','.csv')
				  ),
				tags$hr(),
				checkboxInput(inputId = 'header', label = 'Header', value = FALSE),
				radioButtons('sep','Separator',
		     				      c(Comma=',',
		       				        Semicolon=';',Tab='\t',
                      				',')
					          )
				),width =4
		),
	mainPanel(
		tabsetPanel(
		tabPanel("dataset",
			fluidRow(
			      column(width=12,plotOutput("dataBoxplot"),
				tableOutput("contents"),tags$style(type='text/css','#view{background-color:rgba(11,56,49,0.2);color:balck;font-family:verdana;}'),
	       			downloadButton(outputId="download",label="Download the plot")
				    )
				)
			)
		
		,
		
		tabPanel("summary", 
		         fluidRow(column(width=12,DT::dataTableOutput('summarytable'))
		                #size fix (scrollbar) =>1280
		                  )
		        )
		,
		tabPanel("Grouping",verbatimTextOutput("group"))
		)
		#,
		#actionButton("NormalizeButton","Normalize"),
		#actionButton("LogTransformButton","Log2 Transform")
			  )
		))
	))
