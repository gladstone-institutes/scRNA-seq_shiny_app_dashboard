library(Seurat)
#place the RDS file for the single-cell data in the data folder
#update the name of the RDS file in the below line
data <- readRDS(file = 'data/example_data.rds')
#update the prefix for the filename of any data/plot downloaded from the app
plot_download_prefix <- "example_app"