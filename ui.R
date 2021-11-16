#load required packages
library(shinydashboard)
library(shiny)
library(DT)

dashboardPage(
  
  #header
  dashboardHeader(
    # Application title
    title = "My Title"
  ),
  
  #sidebar content
  dashboardSidebar(
    #data set drop down menu
    selectInput(
      "dataset",
      "Choose a dataset",
      choices = c("Example data" = "data"),
      selected = "data"
    ),
    #break line
    hr(),
    #sub-heading in the sidebar
    h4(
      "Violin and Feature plot options", 
      style='padding: 5px 5px 5px 10px'
    ),
    #multi-select gene drop down menu
    selectizeInput(
      "gene",
      "Enter gene name",
      choices = NULL,
      selected = NULL,
      multiple = TRUE,
      options = list(maxItems = 4)
    )
  ),
  
  #body content
  dashboardBody(
    fluidRow(
      #collapsible summary box with publication information
      box(
        id = "sumary",
        title = "Summary",
        width = 12,
        collapsible = TRUE,
        collapsed = TRUE,
        includeHTML("data/summary.txt")
      )
    ),
    fluidRow(
      #tabbed Box for plots and DE analysis
      tabBox(
        width = 12,
        #feature plot tab
        tabPanel(
          "Feature plot",
          #download buttons for feature plot tab
          fluidRow(
            #download button for reference UMAPs
            column(
              width = 1, 
              offset = 4,
              downloadButton("downloadFefUMAPPlot", "Download")
            ),
            #download button for feature plot
            column(
              width = 1,
              offset = 5,
              downloadButton("downloadFeaturePlot", "Download")
            )
          ),
          fluidRow(
            #reference UMAP plot output
            column(
              width = 6,
              plotOutput("refUMAPcluster"),
              plotOutput("refUMAPgenotype")
            ),
            #feature plot output
            column(
              width = 6,
              uiOutput("featurePlot")
            )
          )
        ),
        #violin plot tab
        tabPanel(
          "Violin plot",
          #checkbox to select plot grouping variable
          checkboxGroupInput(
            "groupVariable", 
            "Variables to group by:",
            choices = list("Clusters" = "seurat_clusters",
                           "Disease" = "disease_label",
                           "Gender" = "gender"),
            selected = "seurat_clusters",
            inline = TRUE
          ),
          #download button for violin plots
          fluidRow(
            column(
              width = 1, 
              offset = 10,
              downloadButton("downloadViolinPlot", "Download")
            )
          ),
          #violin plot ouput
          fluidRow(
            column(
              width = 12,
              uiOutput("violinPlot")
            )
          )
        ),
        #differential analysis tab
        tabPanel(
          "Differential analysis",
          #select the cluster number
          uiOutput("DEclusterNumUI"),
          #action button to run DE analysis for selected cluster
          actionButton('do', 'Go'),
          hr(),
          #DE gene list output
          DT::dataTableOutput("DEgenesTable")
        )
      )
    )
  )
)