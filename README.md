## scRNA-seq_shiny_app_dashboard

This is a generic app that can be used for visualizing single-cell RNA-seq data. This app uses data stored as Seurat objects in a .RDS file. The demo app can be found at https://gladstone-bioinformatics.shinyapps.io/scrna-seq-dashboard-demo/. 

Below are some recommendations to customize this app for another dataset.

1. Place the data (.RDS file) in the "data" folder in the same directory as the global.R, ui.R and server.R.
2. Update the summary.txt markdown file in the "data" folder to include the details about the dataset used in the app.
3. Modify the scripts:  
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
4. Run and test the app on local R Studio.
5. Deploy the app on shiny server using rsconnect. (https://shiny.rstudio.com/articles/shinyapps.html)
6. The app needs more memory than that provided by the default large instance (1024 MB). Log into the shinyapps.io dashboard and change the application's instance to "xlarge" or higher. For details please refer to: https://docs.rstudio.com/shinyapps.io/applications.html
7. If the app needs to be deployed as private, the Shiny plan should be upgraded to "Standard". The application can be made private during deployment from shinyapps.io dashboard using the  instructions at: https://docs.rstudio.com/shinyapps.io/authentication-and-user-management.html
 
 
## References
1. https://github.com/neuhausi/single-cell-viewer
2. https://satijalab.org/seurat/articles/pbmc3k_tutorial.html
