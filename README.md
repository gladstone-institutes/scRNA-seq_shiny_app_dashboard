## scRNA-seq_shiny_app_dashboard

This is a generic app that can be used for visualizing single-cell RNA-seq data. This app uses data stored as Seurat objects in a .RDS file. The demo app can be found at https://gladstone-bioinformatics.shinyapps.io/scrna-seq-dashboard-demo/. 

Below are some recommendations to customize this app for another dataset.

1. Place the data (.RDS file) in the "data" folder in the same directory as the global.R, ui.R and server.R.
2. Modify the scripts:  
    global.R 
      - update the dataset to be used in the app
      - update the value of the variable "plot_download_prefix"

    ui.R
      - Change application title
      - In the sidebar, change the choices in the data set drop down menu based on the datasets to be used in the app
      - In the violin plot tab, change the choices in the checkbox to select plot grouping variable. These choices should match the metadata columns of the dataset to be used in the app.
      
    server.R
      - In the sidear, update the default selected gene in the gene list drop down.
      - In the feature plot tab, update the code for the reference UMAP plots and the refUMAPPlotfunction() function for the download button based on the metadata columns of the dataset to be used in the app.
      - For specific changes related to color schemes or themes of the plots in any tab, update the plots accordingly in the server.R file.


## References
1. https://github.com/neuhausi/single-cell-viewer
2. https://satijalab.org/seurat/articles/pbmc3k_tutorial.html
