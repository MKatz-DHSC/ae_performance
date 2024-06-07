
# install packages if needed
if (!requireNamespace("librarian")) install.packages("librarian", quiet = TRUE)

suppressWarnings(
  librarian::stock(
    DataS-DHSC/DHSClogger,
    tidyverse, yaml,
    tools, fs,
    curl, httr, polite, rvest,
    tidyxl, unpivotr, writexl, lubridate,
    ggrepel, scales, sf, svglite,
    rmarkdown, here,
    quiet = TRUE
  )
)

# Setup logging -----------------------------------------------------------
logger <- DHSClogger::get_dhsc_logger()
# set threshold of console log to information and above
logger$set_threshold("log.console", "INFO")

# Call main code ----------------------------------------------------------
logger$info("[Begin]")

# add source of run script and entry point to code below
source("./R/run_analysis.R", local = TRUE)
run_analysis()

logger$info("[End]")
