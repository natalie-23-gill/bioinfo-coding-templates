#!/usr/bin/env Rscript

###########################################################################
## Project: [Project Name]
## Author: 
##
## Script Goal:
##
## Usage :
##
###########################################################################

# Setup -------------------------------------------------------------------
library(ggplot2) # Plotting
library(ggpubr)  # Publication ready plot themes
set.seed(42)

output <- paste0(
  ""
)

# Create the results folders
if (!(dir.exists(output))) {
  dir.create(output, recursive = TRUE)
}

# Set discrete default colors to Wong B (https://doi.org/10.1038/nmeth.1618)
# colorblindness friendly colors and default continuous colors to the viridis
# color map
custom_colors <- c(
  "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7",
  "#666666", "#AD7700", "#1C91D4", "#007756", "#D5C711", "#005685", "#A04700",
  "#B14380", "#4D4D4D", "#FFBE2D", "#80C7EF", "#00F6B3", "#F4EB71", "#06A5FF",
  "#FF8320", "#D99BBD", "#8C8C8C", "#FFCB57", "#9AD2F2", "#2CFFC6", "#F6EF8E",
  "#38B7FF", "#FF9B4D", "#E0AFCA", "#A3A3A3", "#8A5F00", "#1674A9", "#005F45",
  "#AA9F0D", "#00446B", "#803800", "#8D3666", "#3D3D3D"
)
options(
  ggplot2.discrete.colour = list(custom_colors),
  ggplot2.discrete.fill = list(custom_colors),
  ggplot2.continuous.colour = "viridis",
  ggplot2.continuous.fill = "viridis"
)
# Set default ggplot2 theme options
theme_set(
  theme_pubr(
    base_size = 12,  # Font size
    legend = "right" # Legend position
  ) +
    theme(plot.title = element_text(hjust = 0.5)) # Center plot titles
)

# Note: Add grid lines as needed
# theme(panel.grid.major = element_line(
#    linetype = "dotted",
#    color = "grey50",
#    linewidth = .6
#  ),
#  panel.grid.minor = element_line(
#    linetype = "dotted",
#    color = "grey50",
#    linewidth = .3
#  ))

# Functions ---------------------------------------------------------------

## Custom functions needed to run the script

# multipage_plot: Creates and saves a multipage PDF of a list of ggplot
# objects, with a specified number of plots and columns per page. Plots are
# automatically sized based on ncol and per_page.
multipage_plot <- function(plot_list,
                           per_page,
                           filename,
                           ncol = 2,
                           page_width = 8.5,
                           page_height = 11) {
  # Check for required packages
  required_packages <- c("ggplot2", "ggpubr", "grid")
  missing_packages <- required_packages[!required_packages %in%
                                          installed.packages()[, "Package"]]
  
  if (length(missing_packages) > 0) {
    stop("The following packages are required but not installed: ",
         paste(missing_packages, collapse = ", "))
  }
  
  # Create a PDF file to save the plots
  pdf(file = filename, height = page_height, width = page_width)
  
  # Split the plots into groups of per_page per page
  num_plots <- length(plot_list)
  num_pages <- ceiling(num_plots / per_page)
  plot_indices <- split(seq_len(num_plots),
                        rep(seq_len(num_pages),
                            each = per_page)) |>
    suppressWarnings()
  
  # Plot the plots on each page
  for (i in seq_len(num_pages)) {
    if (length(plot_indices[[i]]) < per_page) {
      # Fill in the rest of the last page with blank plots
      this_index <- max(plot_indices[[i]])
      for (j in seq_len(per_page - length(plot_indices[[i]]))) {
        this_index <- this_index + 1
        plot_indices[[this_index]] <- ggplot() +
          geom_blank()
        plot_indices[[i]] <- c(plot_indices[[i]], this_index)
      }
    }
    plots <- ggpubr::ggarrange(
      plotlist = plot_list[plot_indices[[i]]],
      ncol = ncol, nrow = ceiling(length(plot_indices[[i]]) / ncol)
    )
    plots_grob <- ggplotGrob(plots)
    grid::grid.newpage()
    grid::grid.draw(plots_grob)
  }
  # Close the PDF file
  dev.off()
}



# Inputs ------------------------------------------------------------------

### Any inputs needed to run the script

# Main --------------------------------------------------------------------

### Main script, processing + outputs

# Write out the session info for reproducibility
writeLines(
  capture.output(sessionInfo()),
  file.path(output, "sessionInfo.txt")
)