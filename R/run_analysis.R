
# Load required packages --------------------------------------------------
library(tidyverse)

# Source other scripts ----------------------------------------------------
download <- new.env(); source("./R/download.R", local = download)
process <- new.env(); source("./R/process.R", local = process)
visualise <- new.env(); source("./R/visualise.R", local = visualise)


# Main function to run analysis -------------------------------------------

#' Run analysis
#'
#' Main function used to run analysis. This function is called from
#' the main.R script which should be used to run the project.
#'
#' @export
#'
run_analysis <- function() {
  # log action
  logger$info("Running analysis...")
  
  # read in configuration
  config_path <- file.path("input", "config.yml")
  config <- yaml::read_yaml(config_path)
  
  # get file date and time stamp
  config$date_stamp <- format(Sys.time(), "%Y%m%d-%H%M")
  out_stamp <- function(x) sprintf("%s_%s", config$date_stamp, x)
  
  # backup config file
  fs::file_copy(config_path, file.path("output", out_stamp("config.yml")))
  
  # correctly configure date
  fy_str <- sprintf(
    "%s-%s", 
    config$analysis_year, 
    stringr::str_sub(as.character(config$analysis_year + 1), start = -2)
  )
  
  # At some point build in automatic download of the files
  # download_folder <- download$download_nhse_data(
  #   
  # )
  
  download_folder <- file.path("input", fy_str)
  
  # load data
  # process$
  
  # Do we want a static report or a dashboard???
  
  logger$info("Generating report")
  
  report_env <- new.env()
  rmarkdown::render(
    here::here("R", "ae_performance.qmd"),
    output_file = here::here("output", out_stamp("ae_performance")),
    envir = report_env,
    intermediates_dir = here::here("output")
  )
  
  logger$info("Report done")
  
  # How do we use data to make predictions of future?
  # compare previous years data to current years
  
  logger$info("Finished")
}

