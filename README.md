## scRNA-seq_shiny_app_dashboard

This is a generic app that can be used for visualizing single-cell RNA-seq data. This app uses data stored as Seurat objects in a .RDS file. Below are some recommendations to customize this app for another dataset.

1. Place the data (.RDS file) in the "data" folder in the same directory as the global.R, ui.R and server.R.
2. Modify the scripts:  
    global.R 
      - Line 4: update the dataset
      - Line 6: update the "plot_download_prefix"

    ui.R
      - Change application title on line 11
      - Change the dataset choices on lines 20-21
      - Line 33
      
    server.R
      - update the plots


## References
1. https://github.com/neuhausi/single-cell-viewer
2. https://satijalab.org/seurat/articles/pbmc3k_tutorial.html
