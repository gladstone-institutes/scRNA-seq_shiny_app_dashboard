#load required packages
library(dittoSeq)
require(gridExtra)

shinyServer(function(input, output, session) {
  
  ##########
  #sidebar
  ##########
  
  #update input gene list drop down when data set is selected
  inputgenes <- reactiveValues()
  observeEvent(input$dataset,{
    inputgenes <- rownames(get(input$dataset)@assays$RNA)
    updateSelectizeInput(
      session,
      'gene', 
      choices = inputgenes, 
      selected = "CD14",
      server = TRUE
    )
  }
  )
  
  
  ##########
  #body
  ##########
  
  #feature plot tab - download button for reference UMAPs
  refUMAPPlotfunction <- function(){
    p1 <- dittoDimPlot(get(input$dataset),
                       c("seurat_clusters"),
                       order = "increasing",
                       size = 2.5,
                       opacity = 0.8,
                       show.others = T,
                       main = "Seurat clusters",
                       theme = theme_bw(base_size = 15)
                      )
    p2 <- dittoDimPlot(get(input$dataset),
                       c("cell_type"),
                       order = "increasing",
                       size = 2.5,
                       opacity = 0.8,
                       show.others = T,
                       main = "Cell type",
                       theme = theme_bw(base_size = 15)
                      )

    grid.arrange(p1,p2, ncol = 2)
  }
  output$downloadFefUMAPPlot <- downloadHandler(
    filename =  function() {
      #downloaded file name
      paste0(plot_download_prefix, "_", Sys.time(),".png")
    },
    #content is a function with argument file.
    #content writes the plot to the device
    content = function(file) {
      png(file,
          width = 580*3,
          height = 500)
      refUMAPPlotfunction() # draw the plot
      dev.off()  # turn the device off
    }
  )

  #feature plot tab - download button for feature plots
  featurePlotfunction <- function(){
    if (is.null(input$gene)) {
      ggplot()
    }else{
      FeaturePlot(get(input$dataset),
                  slot = "data",
                  features = input$gene,
                  label = F,
                  order = T,
                  pt.size = 2.5,
                  ncol =1
      )
    }
  }
  output$downloadFeaturePlot <- downloadHandler(
    filename =  function() {
      #downloaded file name
      paste0(plot_download_prefix, "_", Sys.time(),".png")
    },
    #content is a function with argument file.
    #content writes the plot to the device
    content = function(file) {
      if(length(input$gene) == 0){
        height_param = 1
      }else{
        height_param = length(input$gene)
      }
      png(file,
          width = 480,
          height = 480 * height_param)
      print(featurePlotfunction()) # draw the plot
      dev.off()  # turn the device off
    }
  )

  #feature plot tab - reference UMAP plot output (group by seurat cluster)
  output$refUMAPcluster <- renderPlot({
    dittoDimPlot(get(input$dataset),
                 c("seurat_clusters"),
                 order = "increasing",
                 size = 2.5,
                 opacity = 0.8,
                 show.others = T,
                 main = "Seurat clusters",
                 theme = theme_bw(base_size = 15)
    )
  })

  #feature plot tab - reference UMAP plot output (group by genotype)
  output$refUMAPgenotype <- renderPlot({
    dittoDimPlot(get(input$dataset),
                 c("cell_type"),
                 order = "increasing",
                 size = 2.5,
                 opacity = 0.8,
                 show.others = T,
                 main = "Cell type",
                 colors = c(1:9),
                 theme = theme_bw(base_size = 15)
    )
  })

  #feature plot tab - feature plot output
  get_featurePlot_list <- function(input_n) {
    #insert plot output objects the list
    plot_fpoutput_list <- lapply(1:input_n, function(i) {
      fpplotname <- paste("plot", i, sep="")
      plot_fpoutput_object <- plotOutput(fpplotname)
      plot_fpoutput_object <- renderPlot({
        if (i == 0 | is.null(input$gene[i]) ) {
          ggplot()
        }else{
          FeaturePlot(get(input$dataset),
                      slot = "data",
                      features = input$gene[i],
                      label = F,
                      order = T,
                      pt.size = 2.5)
        }
      })
    })
    # needed to display properly
    do.call(tagList, plot_fpoutput_list)
    return(plot_fpoutput_list)
  }
  observe({
    output$featurePlot <- renderUI({
      req(input$dataset)
      req(input$gene)
      get_featurePlot_list(length(input$gene))
    })
  })

  #violin plot tab - download button for violin plots
  violinPlotfunction <- function(){
    if (length(input$groupVariable) == 0 | is.null(input$gene)) {
      ggplot()
    }else{
      vp <- lapply(input$groupVariable,
                   function(x){
                     multi_dittoPlot(get(input$dataset),
                                     slot = "data",
                                     input$gene,
                                     #reduction.use = "umap",
                                     group.by = x,
                                     plots = c('vlnplot',
                                               "jitter",
                                               "boxplot"),
                                     #change the color and size of jitter points
                                     jitter.color = "blue",
                                     jitter.size = 1,
                                     # change the outline color and width, and remove the fill of boxplots
                                     boxplot.color = "white",
                                     boxplot.width = 0.2,
                                     boxplot.fill = T,
                                     # change how the violin plot widths are normalized across groups
                                     vlnplot.scaling = "width",
                                     legend.show = F,
                                     ncol = 1,
                                     ylab = "Log counts",
                                     xlab = x,
                                     theme = theme_classic(base_size = 15)

                   )
      })
      return(vp)
    }
  }
  output$downloadViolinPlot <- downloadHandler(
    filename =  function() {
      paste0(plot_download_prefix, "_", Sys.time(),".png")
    },
    #content is a function with argument file.
    #content writes the plot to the device
    content = function(file) {
      if(length(input$gene) == 0){
        height_param = 1
      }else{
        height_param = length(input$gene)
      }
      png(file,
          width = 540 * length(input$groupVariable),
          height = 480 * height_param)
      vp <- violinPlotfunction()
      grid.arrange(grobs = vp, nrow = 1) # draw the plot
      dev.off()  # turn the device off
    }
  )

  #violin plot tab - violin plot output
  get_violinPlot_list <- function(input_n) {
    #insert plot output objects the list
    plot_vpoutput_list <- lapply(1:input_n, function(i) {
      vpplotname <- paste("plot", i, sep="")
      plot_vpoutput_object <- plotOutput(vpplotname)
      plot_vpoutput_object <- renderPlot({
        if (length(input$groupVariable) == 0 | is.null(input$gene[i]) | i == 0) {
          ggplot()
        }else{
          vp <- lapply(input$groupVariable,
                       function(x){
                         multi_dittoPlot(get(input$dataset),
                                         slot = "data",
                                         input$gene[i],
                                         group.by = x,
                                         plots = c('vlnplot',
                                                   "jitter",
                                                   "boxplot"),
                                         #change the color and size of jitter points
                                         jitter.color = "blue",
                                         jitter.size = 1,
                                         # change the outline color and width, and remove the fill of boxplots
                                         boxplot.color = "white",
                                         boxplot.width = 0.2,
                                         boxplot.fill = T,
                                         # change how the violin plot widths are normalized across groups
                                         vlnplot.scaling = "width",
                                         legend.show = F,
                                         ncol = 1,
                                         ylab = "Log counts",
                                         xlab = x,
                                         theme = theme_classic(base_size = 15)
                                         )
                       }
          )
          grid.arrange(grobs = vp , nrow = 1)
        }
      })
    })
    do.call(tagList, plot_vpoutput_list) #needed to display properly
    return(plot_vpoutput_list)
  }
  observe({
    output$violinPlot <- renderUI({
      req(input$dataset)
      req(input$gene)
      get_violinPlot_list(length(input$gene))
    })
  })

  #differential analysis tab - select the cluster number
  output$DEclusterNumUI <- renderUI({
    selectInput(
      "clusterNum",
      "Choose a cluster to compare with all other clusters for differentially expressed genes",
      choices = unique(get(input$dataset)@meta.data$seurat_clusters),
      selected = unique(get(input$dataset)@meta.data$seurat_clusters)[1]
    )
  })

  #differential analysis tab - DE gene list output
  DEdata <- eventReactive(c(input$do, input$dataset),{
    if(input$do == 0){
      return()
    }
    withProgress(message = 'Updating table...',
                 detail = "",
                 style = getShinyOption("progress.style",
                                        default = "notification"),
                 value = NULL,
                 {
                   this_data <- FindMarkers(get(input$dataset),
                                                          ident.1 = input$clusterNum
                                                          )
                   this_data[, c(1:2, 5)] <- apply(this_data[, c(1:2, 5)],
                                                   2,
                                                   signif,
                                                   digits = 3)
                 }
    )
  })
  output$DEgenesTable <- DT::renderDataTable(server = FALSE,{
    DT::datatable({ as.data.frame(DEdata()) },
                  caption = "Table: Differentially expressed genes per cluster",
                  extensions = 'Buttons',
                  options = list(dom = 'Bfrtip',
                                 buttons = list(list(extend = 'collection',
                                                     buttons = c('csv', 'excel'),
                                                     text = 'Download'
                                 ))
                  )
    )
  })

})