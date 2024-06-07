
# Load required packages --------------------------------------------------
library(tidyverse)
library(lubridate)
library(ggrepel)
library(scales)
library(sf)
library(svglite)


# Function definitions ----------------------------------------------------

#' Display and save a plot
#'
#' @param plt Plot to be saved.
#' @param file_path Path to save plot to.
#'
#' @return Path plot saved to.
#' @export
#'
save_plot <- function(plt, file_path) {
  
  logger$info("Saving plot to %s", file_path)
  
  print(plt)
  
  ggsave(
    plt,
    dpi = 300, width = 12, height = 8, units = "in",
    filename = file_path
  )
  
  return(file_path)
}


#' Create plot
#'
#' Create a line graph
#'
#' @param data Data to plot.
#'
#' @return Plot of data.
#' @export
#'
plot_timeseries <- function(data) {
  
  df <- data %>%
    mutate(
      attended = attended / appointments,
      dna = dna / appointments,
      unknown = unk / appointments
    ) %>%
    select(date, attended, dna, unknown) %>%
    pivot_longer(
      c(attended, dna, unknown),
      names_to = "type",
      values_to = "proportion"
    )
  
  # want weekly separator lines
  v_ticks <- seq(min(df$date), max(df$date), by = "1 week")
  
  # function to display the weekday as a single character with
  # the day of the month at each week start
  format_dates <- function(x) {
    day_of_week <- strftime(x, format = "%a") %>%
      str_sub(1, 1)
    day_of_month <- strftime(x, format = "%d")
    week_start = wday(min(df$date))
    return(
      if_else(
        wday(x) == week_start,  # Conditions for pasting.
        true = paste(day_of_week, day_of_month, sep = "\n"),
        false = day_of_week)
    )
  }
  
  plt <- ggplot() +
    DHSCcolours::theme_dhsc() +
    theme(
      axis.title.y = element_blank(),
      panel.grid.major.y = element_blank(),
      axis.text.x = element_text(angle = 0, hjust = 0.5)
    ) +
    geom_line(
      data = df,
      aes(date, proportion, colour = type),
      linewidth = 1
    ) +
    DHSCcolours::scale_colour_dhsc_d() +
    scale_y_continuous(labels=scales::percent) +
    scale_x_date(
      name = "Date",
      labels = format_dates,
      date_breaks = "1 day"
    ) +
    geom_vline(
      xintercept = v_ticks,
      linetype="dotted",
      colour = DHSCcolours::dhsc_grey()
    ) +
    labs(
      title = "Proportion of attendances by type",
      subtitle = sprintf("England, %s", format(min(df$date), "%b %Y"))
    )
  
  return(plt)
  
}

