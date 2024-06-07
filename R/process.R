
# Load required packages --------------------------------------------------
library(tidyverse)
library(tidyxl)
library(unpivotr)
library(writexl)
library(lubridate)
library(readxl)


# Function definitions ----------------------------------------------------

#' Read and tidy ae data from single spreadsheet
#'
#' @param file_path The file path to the data file.
#' Should include the file extension (.xlsx)
#'
#' @return A tibble with the sheet data.
#'
load_ae_data <- function(file_path) {
  
  # Reading excel data with tidyxl and manipulating the output with unpivotr and dplyr
  logger$info("Reading system level data from %s", file_path)
  
  # read spreadsheet as cells using tidyxl
  df_raw <- xlsx_cells(
    file_path, sheets = "System Level Data",
    include_blank_cells = FALSE
  )
  
  # get row of table title
  title_row <- df_raw %>%
    filter(
      str_detect(character, "^Table 2a")
    ) %>%
    pull(row) %>%
    first()
  
  # get row of table footer
  footer_row <- df_raw %>%
    filter(
      str_detect(character, "^Source: NHS England$")
    ) %>%
    pull(row) %>%
    first()
  
  # use unpivotr to tidy data
  # start with headers
  df <- df_raw %>%
    filter(row > title_row, row < footer_row) %>%
    behead('up', super_heading) %>%
    behead('up', heading) %>%
    behead('up', hidden_row)
  
  # sort out headings and weekdays
  df <- df %>%
    arrange(col, row) %>%
    fill(heading, .direction = "down") %>%
    behead('left', weekday)
  
  # convert data to tibble
  df <- df %>%
    select(row, data_type, heading, character, numeric, date) %>%
    spatter(heading)
  
  # enforce data types and column names
  df <- df %>%
    mutate(
      date = as.Date(Date),
      appointments = as.numeric(`Total Count of Appointments`),
      attended = as.numeric(Attended),
      dna = as.numeric(`Did Not Attend`),
      unk = as.numeric(Unknown1)
    ) %>%
    select(date, appointments, attended, dna, unk)
  
  return(df)
}



#' Generic read function
#'
#' @param file_path The path to the csv file to read.
#' Should include the file extension (.csv)
#' @param sheet_name The name of the sheet to pull data from. 
#'
#' @return A tibble with the data.
#' @export
#'
read_sheet <- function(file_path, sheet_name) {
  
  logger$info("Reading file %s sheet %s", file_path, sheet_name)
  
  file_path <- file.path("input", "2023-24", "January-2024-AE-by-provider-5CqWX.xls")
  sheet_name <- "System Level Data"
  
  df_xls <- readxl::read_xls(
    file_path, 
    sheet = sheet_name,
    col_names = FALSE
  )
  
  # read spreadsheet as cells using tidyxl
  df_raw <- xlsx_cells(
    file_path, sheets = sheet_name,
    include_blank_cells = FALSE
  )
  
  # get row of table title
  title_row <- df_raw %>%
    filter(
      str_detect(character, "^Table 2a")
    ) %>%
    pull(row) %>%
    first()
  
  # get row of table footer
  footer_row <- df_raw %>%
    filter(
      str_detect(character, "^Source: NHS England$")
    ) %>%
    pull(row) %>%
    first()
  
  # use unpivotr to tidy data
  # start with headers
  df <- df_raw %>%
    filter(row > title_row, row < footer_row) %>%
    behead('up', super_heading) %>%
    behead('up', heading) %>%
    behead('up', hidden_row)
  
  # sort out headings and weekdays
  df <- df %>%
    arrange(col, row) %>%
    fill(heading, .direction = "down") %>%
    behead('left', weekday)
  
  # convert data to tibble
  df <- df %>%
    select(row, data_type, heading, character, numeric, date) %>%
    spatter(heading)
  
  # enforce data types and column names
  df <- df %>%
    mutate(
      date = as.Date(Date),
      appointments = as.numeric(`Total Count of Appointments`),
      attended = as.numeric(Attended),
      dna = as.numeric(`Did Not Attend`),
      unk = as.numeric(Unknown1)
    ) %>%
    select(date, appointments, attended, dna, unk)
  
  return(df)
}

