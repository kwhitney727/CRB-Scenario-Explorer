# The user interface script of the ColoRiverHydroEx website package.
# More information on this to come.

# Load packages ----
library(shiny)
library(stringi)
library(lubridate)
library(dygraphs)
library(tidyverse)
library(RColorBrewer)
library(plotly)

# Load data ----
anom_yr_timeseries_all <- readRDS("./data/basin_agg_anom_yr_timeseries_all.rds")
assign("anom_yr_timeseries_all", anom_yr_timeseries_all, envir=globalenv()) # Set as a global variable
yr_timeseries_all <- readRDS("./data/basin_agg_yr_timeseries_all.rds")
assign("yr_timeseries_all", yr_timeseries_all, envir=globalenv()) # Set as a global variable

# Source helper scripts ----
source("helpers_dictionaries.R")
source("helpers_functions.R")

# Connect historic and future projected timeseries lines ----
anom_yr_timeseries_all <- connect_hist_and_proj_timeseries(anom_yr_timeseries_all,timeperiod_dict)
yr_timeseries_all <- connect_hist_and_proj_timeseries(yr_timeseries_all,timeperiod_dict)


# User interface ----
ui <- fluidPage(
  navbarPage(
    "ColoRiverHydroEx",
    tabPanel(
      "Introduction",
      h4("ColoRiverHydroEx: Colorado River Basin Hydrology Explorer"),
      helpText("To be populated with an introduction to this App with various figures (e.g., CRB topo map, subbasin regions) and logos (ASU, CAP, NASA)."),
      helpText("(Click on the navigation bar panels to see what has been done so far.)"),
      ),
    tabPanel(
      "Annual values",
      sidebarLayout(
        sidebarPanel(
          width=2,
          selectInput(
            "basin_yr",
            label = "Select a basin region",
            choices = sort(basin_full_names),
            selected = "Basin-wide"
          ),
          selectInput(
            "var_yr",
            label = "Select a variable",
            choices = sort(names(var_info_dict)
            ),
            selected = "air temperature"
          ),
          selectInput(
            "plot_type_yr",
            label = paste("Select a timeseries type"),
            choices = names(plot_type_dict),
            selected = "median"
          ),
          helpText("Note: Move mouse over figures to highlight individual values. Click and drag to zoom. Double-click to zoom out."),
        ),
        mainPanel(
          width=10,
          h4(textOutput("title_str_yr")),
          helpText(textOutput("subtitle_str_yr")),
          dygraphOutput("timeseries_yr"),
          hr(),
          h4(textOutput("title_str_mann")),
          helpText(textOutput("subtitle_str_mann")),
          plotlyOutput("clim_mann_box")
        )
      )
      ),
    tabPanel(
      "Annual anomalies",
      sidebarLayout(
        sidebarPanel(
          width=2,
          selectInput(
            "basin_anom_yr",
            label = "Select a basin region",
            choices = sort(basin_full_names),
            selected = "Basin-wide"
            ),
          selectInput(
            "var_anom_yr",
            label = "Select a variable",
            choices = sort(names(var_info_dict)
                           ),
            selected = "air temperature"
            ),
          selectInput(
            "plot_type_anom_yr",
            label = paste("Select a timeseries type"),
            choices = names(plot_type_dict),
            selected = "median"
            ),
          helpText("Note: Move mouse over figures to highlight individual values. Click and drag to zoom. Double-click to zoom out."),
          ),
        mainPanel(
          width=10,
          h4(textOutput("title_str_anom_yr")),
          helpText(textOutput("subtitle_str_anom_yr")),
          dygraphOutput("timeseries_anom_yr"),
          hr(),
          h4(textOutput("title_str_mann_anom")),
          helpText(textOutput("subtitle_str_mann_anom")),
          plotlyOutput("clim_mann_anom_box")
        )
      )
    ),
    tabPanel("Other app ideas",
             helpText("(This page will be removed, but includes some content ideas. I apreciate your feedback.)"),
             h2('Content ideas:'),
             paste("- Option to switch between unit types (American vs Metric system, cubic-km vs MAF)"),
             br(),
             br(),
             HTML("<p>- Inclusion of subdivision within a given navigation bar tab. Sibdivisions can include tabs for the plot(s), summary, and table(s). See the example at <a href='https://shiny.rstudio.com/articles/tabsets.html'> https://shiny.rstudio.com/articles/tabsets.html</a>.</p>"),
             HTML("<p>- Nagivation bar tab of monthly data. Option to show lines for individual years (like the <a href='https://www.cbrfc.noaa.gov/station/sweplot/snowgroup.php'> NOAA Snow groups</a>, per Orestes's suggestion) or climatological monthly averages. Option to select specigic GCM, an ensemble-aggregation, or GCM+LULC combination.</p>"),
             paste("- Interactive maps, choose a variable, choose an scenario (GCM, ensemble-aggregation, or GCM+LULC combination) click a subbasin and get a box-whisker.",
                   "Box-whiskers could show stats on grid cell values for the given variable/scenario/subbasin."),
             br(),
             br(),
             paste("- Nagivation bar tab of seasonal datasets.",
                   "Could add this as an option to the current navigation bar tabs, or a separate tab to show side-by-side comparison of cool- vs. warm-season?"),
             br(),
             br(),
             HTML("<p>- Hydroclimate extremes analyses using standardized indices (like in my earlier PhD work)",
                   "or percentile-based threshold approach (could identify compound events like in <a href='https://doi.org/10.1029/2021GH000390'> Wu <em>et al</em>. 2021</a>), with 'colored-ribbons' added to timeseries to identify extreme event periods (like done for my earlier PhD work),",
                  " which are very easy to add to timeseries (see example <a href='https://rstudio.github.io/dygraphs/gallery-ribbon.html'> here</a>) and/or maps of frequency/severity of extreme events (like in <a href='https://doi.org/10.1029/2021GH000390'> Wu <em>et al</em>. 2021</a>).</p>"),
             paste("- Hovmoller with latitude on y-axis.",
                   "X-axis has time (full timeperiod, April 1st to March 30th, or hydrological year timeseries). Same options as other nav bar tabs (GCM, ensemble, GCM+LULC scenario selection),",
                   " but perhaps just SWE?"),
             br(),
             br(),
             HTML("<p>- Any other ideas/inspiration from the <a href='https://shiny-apps.ceh.ac.uk/hydro_drought_explorer/'> UK Hydrological Drought Explorer</a> Shiny App?</p>"),
             
             h2('Other considerations/questions:'),
             paste("- How do we want to organize the navigation bar tabs? Separate tabs for the climate change only (ch1) data and the climate+lulc change (ch2) data?.",
                   "Or have options to select between the two types of data for each tab?"),
             br(),
             br(),
             paste("- Do you like the current options in current navigation bar tabs? For example, showing just one variable, and one basin at a time?",
                   "I chose that format, since having more than one at a time might be too much information for one page. Open to your ideas though."),
             br(),
             br(),
             paste("- What should I aim to show for this App (what amount/types of changes from this current App form) in my upcoming technical review?"),
             h4("I would appreciate any additional feedback on a long-term vision of the App (for my dissertation, especially to make this 'publication worthy'), and next steps."),
    ),
    navbarMenu(
      "More",
      tabPanel("About data",
               helpText("(To be populated with more info about the underlying data and the VIC model framework.)")
               ),
      tabPanel("About basin regions",
               helpText("(To be populated with more info about each basin region, including subbasin map.)")
               )
      )
  )
)
