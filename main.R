
# install packages if needed
if (!requireNamespace("librarian")) install.packages("librarian", quiet = TRUE)

suppressWarnings(
  librarian::stock(
    DataS-DHSC/DHSClogger,
    DataS-DHSC/DHSCcolours,
    quiet = TRUE
  )
)

# Setup logging -----------------------------------------------------------
logger <- DHSClogger::get_dhsc_logger()
# set threshold of console log to information and above
logger$set_threshold("log.console", "INFO")


# At some point build in automatic download of the file

# Do we want a static report or a dashboard???