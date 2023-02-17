## --------------------------------------------------------------------------------------##
##
## Script name: server.R
##
## Purpose of the script: The server script of the VIC-Explorer website package.
##
## @author: Kristen Whitney
##
## Created on Fri Sept 19 2022
##
## Email: kmwhitne@asu.edu
##
## --------------------------------------------------------------------------------------##
##    Notes:
##     
##
## --------------------------------------------------------------------------------------##
## ----------------------------------Load packages---------------------------------------## ----

# Load packages ----
library(shiny,quietly=TRUE,warn.conflicts = FALSE)
library(stringi,quietly=TRUE,warn.conflicts = FALSE)
library(stringr,quietly=TRUE,warn.conflicts = FALSE)
library(plotly,quietly=TRUE,warn.conflicts = FALSE)
library(tidyverse,quietly=TRUE,warn.conflicts = FALSE)
library(dplyr,quietly=TRUE,warn.conflicts = FALSE)
library(RColorBrewer,quietly=TRUE,warn.conflicts = FALSE)
library(leaflet,quietly=TRUE,warn.conflicts = FALSE)
library(sp,quietly=TRUE,warn.conflicts = FALSE)
library(raster,quietly=TRUE,warn.conflicts = FALSE)
library(rgdal,quietly=TRUE,warn.conflicts = FALSE)
library(leafem,quietly=TRUE,warn.conflicts = FALSE)
library(sf,quietly=TRUE,warn.conflicts = FALSE)
library(rlist,quietly=TRUE,warn.conflicts = FALSE)
library(manipulateWidget,quietly=TRUE,warn.conflicts = FALSE) # sync leaflet
library(leaflet.minicharts,quietly=TRUE,warn.conflicts = FALSE)
library(leaflet.extras,quietly=TRUE,warn.conflicts = FALSE)
# library(dygraphs,quietly=TRUE,warn.conflicts = FALSE)
# library(xts,quietly=TRUE,warn.conflicts = FALSE)
# library(stringi,quietly=TRUE,warn.conflicts = FALSE)
# library(lubridate,quietly=TRUE,warn.conflicts = FALSE)
# library(leaflegend,quietly=TRUE,warn.conflicts = FALSE)
library(mapview,quietly=TRUE,warn.conflicts = FALSE)

# library(leaflet,quietly=TRUE,warn.conflicts = FALSE)
library(ncdf4,quietly=TRUE,warn.conflicts = FALSE)
library(stars,quietly=TRUE,warn.conflicts = FALSE)
# library(DT)
#library(quantmod)
# library(tidyr)

## ----------------------------------Load data---------------------------------------## ----
basin_agg_clim_mann_changes <- readRDS("./data/basin_agg_climatological_mean_annual_changes_all.rds")
basin_agg_clim_mann_abs_changes <- readRDS("./data/basin_agg_climatological_mean_annual_abs_changes_all.rds")
basin_agg_clim_mseas_warm_abs_changes <- readRDS("./data/basin_agg_climatological_mean_warm_season_abs_changes_all.rds")  ## change this to use the absolute differences
basin_agg_clim_mseas_cool_abs_changes <- readRDS("./data/basin_agg_climatological_mean_cool_season_abs_changes_all.rds")

basin_agg_clim_mann <- readRDS("./data/basin_agg_climatological_mean_annuals_all.rds")
basin_agg_clim_mmon <- readRDS("./data/basin_agg_climatological_mean_monthly_all.rds")
basin_agg_clim_mann_scenario_diffs <- readRDS("./data/basin_agg_climatological_mean_annuals_scenario_diffs_all.rds")
basin_agg_clim_mseas_warm_scenario_diffs <- readRDS("./data/basin_agg_climatological_mean_warm_season_scenario_diffs_all.rds")
basin_agg_clim_mseas_cool_scenario_diffs <- readRDS("./data/basin_agg_climatological_mean_cool_season_scenario_diffs_all.rds")

subbasins <- readOGR("./data/subbasin_shapefile/Major_Subbasins.shp",layer="Major_Subbasins",verbose=FALSE)
bounds <- subbasins %>% st_bbox() %>% as.double() # subbasin bounds for plotting

## ----------------------------------Set global variables---------------------------------------##
assign("basin_agg_clim_mann_changes", basin_agg_clim_mann_changes, envir=globalenv())
assign("basin_agg_clim_mann_abs_changes", basin_agg_clim_mann_abs_changes, envir=globalenv())
assign("basin_agg_clim_mseas_warm_abs_changes", basin_agg_clim_mseas_warm_abs_changes, envir=globalenv())
assign("basin_agg_clim_mseas_cool_abs_changes", basin_agg_clim_mseas_cool_abs_changes, envir=globalenv())
assign("basin_agg_clim_mann_scenario_diffs", basin_agg_clim_mann_scenario_diffs, envir=globalenv())
assign("basin_agg_clim_mseas_warm_scenario_diffs", basin_agg_clim_mseas_warm_scenario_diffs, envir=globalenv())
assign("basin_agg_clim_mseas_cool_scenario_diffs", basin_agg_clim_mseas_cool_scenario_diffs, envir=globalenv())
assign("basin_agg_clim_mann",basin_agg_clim_mann, envir=globalenv())
assign("basin_agg_clim_mmon",basin_agg_clim_mmon, envir=globalenv())
assign("subbasins", subbasins, envir=globalenv())
assign("bounds",bounds,envir=globalenv())

## ----------------------------------Source helper scripts---------------------------------------## ----
source("./helpfiles/helper_dictionaries.R")
source("./helpfiles/helper_functions.R")

## ----------------------------------Server logic---------------------------------------##
# Server logic
server <- function(input, output,session) {

## ----------------------------------Internal links---------------------------------------## ----
  # Notes: 
  #   - Each item can only be called once, and therefore if wanting to use the 
  #     item more than once, you need to initialize two separate items. 

  # Landing page
  observeEvent(input$more_info_button, {
    panel_name <- "Scenario Overview"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$watershed_annual_button, {
    navpage_name <- "Annual"
    updateNavbarPage(session, "pages",navpage_name)
  })
  observeEvent(input$watershed_monthly_button, {
    navpage_name <- "Monthly"
    updateNavbarPage(session, "pages",navpage_name)
  })
  observeEvent(input$spatial_button, {
    navpage_name <- "Spatial-Analyses"
    updateNavbarPage(session, "pages",navpage_name)
  })
  
  # Spatial-Analyses panel
  observeEvent(input$link_from_spatial_to_watersheds1a, {
    panel_name <- "Watersheds"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_spatial_to_watersheds1b, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Watershed statistics")
  })
  observeEvent(input$link_from_spatial_to_watersheds2, {
    panel_name <- "Watersheds"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_spatial_to_watersheds3, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Watershed statistics")
  })
  observeEvent(input$link_from_spatial_to_scenario_overview1, {
    panel_name <- "Scenario Overview"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  
  observeEvent(input$link_from_spatial_to_framework_overview1, {
    panel_name <- "Framework Overview"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_spatial_to_flow_routing, {
    panel_name <- "Streamflow Routing"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_spatial_to_wat_ann1, {
    navpage_name <- "Annual"
    updateNavbarPage(session, "pages",navpage_name)
  })
  observeEvent(input$link_from_spatial_to_wat_ann2, {
    navpage_name <- "Annual"
    updateNavbarPage(session, "pages",navpage_name)
    updateCollapse(session,"watershed_analyses_annual_panels",open="Guided Analysis")
    updateRadioButtons(session,"wat_ann_analyses",selected = "wat_ann_analysis_conclusions")
  })
  observeEvent(input$link_from_spatial_to_wat_ann3, {
    navpage_name <- "Annual"
    updateNavbarPage(session, "pages",navpage_name)
    updateCollapse(session,"watershed_analyses_annual_panels",open="Guided Analysis")
    updateRadioButtons(session,"wat_ann_analyses",selected = "wat_ann_analysis_3")
  })
  observeEvent(input$link_from_spatial_to_wat_ann4, {
    navpage_name <- "Annual"
    updateNavbarPage(session, "pages",navpage_name)
    updateCollapse(session,"watershed_analyses_annual_panels",open="Guided Analysis")
    updateRadioButtons(session,"wat_ann_analyses",selected = "wat_ann_analysis_3")
  })
  observeEvent(input$link_from_spatial_to_wat_ann5, {
    navpage_name <- "Annual"
    updateNavbarPage(session, "pages",navpage_name)
    updateCollapse(session,"watershed_analyses_annual_panels",open="Guided Analysis")
    updateRadioButtons(session,"wat_ann_analyses",selected = "wat_ann_analysis_5")
  })
  observeEvent(input$link_from_spatial_to_wat_ann6, {
    navpage_name <- "Annual"
    updateNavbarPage(session, "pages",navpage_name)
    updateCollapse(session,"watershed_analyses_annual_panels",open="Guided Analysis")
    updateRadioButtons(session,"wat_ann_analyses",selected = "wat_ann_analysis_5")
  })
  observeEvent(input$link_from_spatial_to_wat_mon1, {
    navpage_name <- "Monthly"
    updateNavbarPage(session, "pages",navpage_name)
  })
  observeEvent(input$link_from_spatial_to_wat_mon2, {
    navpage_name <- "Monthly"
    updateNavbarPage(session, "pages",navpage_name)
    
    updateCollapse(session,"watershed_analyses_monthly_panels",open="Guided Analysis")
    updateRadioButtons(session,"wat_mon_analyses",selected = "wat_mon_analysis_2")
  })
  observeEvent(input$link_from_spatial_to_wat_mon3, {
    navpage_name <- "Monthly"
    updateNavbarPage(session, "pages",navpage_name)
    
    updateCollapse(session,"watershed_analyses_monthly_panels",open="Guided Analysis")
    updateRadioButtons(session,"wat_mon_analyses",selected = "wat_mon_analysis_2")
  })
  observeEvent(input$link_from_spatial_to_forest_disturbances0, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Overview")
    updateCollapse(session,"elevation_landcover_maps_info_panels",open="More Info")
    
  })
  observeEvent(input$link_from_spatial_to_forest_disturbances1, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Forest vs. grass parameters")
  })
  observeEvent(input$link_from_spatial_to_forest_disturbances2, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Forest vs. grass parameters")
  })
  observeEvent(input$link_from_spatial_to_forest_disturbances3, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Overview")
    updateCollapse(session,"elevation_landcover_maps_info_panels",open="Assumptions")
  })
  observeEvent(input$link_from_spatial_to_stakeholder_engagement, {
    panel_name <- "Stakeholder Engagement"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  
  
  
  # Watersheds-Analyses Monthly panel
  observeEvent(input$link_from_wat_mon_to_watersheds1a, {
    panel_name <- "Watersheds"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_wat_mon_to_watersheds1b, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Watershed statistics")
  })
  observeEvent(input$link_from_wat_mon_to_watersheds2, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Watershed statistics")
  })
  observeEvent(input$link_from_wat_mon_to_scenario_overview1, {
    panel_name <- "Scenario Overview"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_wat_mon_to_framework_overview1, {
    panel_name <- "Framework Overview"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_wat_mon_to_spatial_analyses1, {
    navpage_name <- "Spatial-Analyses"
    updateNavbarPage(session, "pages",navpage_name)
  })
  observeEvent(input$link_from_wat_mon_to_spatial_analyses2, {
    navpage_name <- "Spatial-Analyses"
    updateNavbarPage(session, "pages",navpage_name)
  })
  observeEvent(input$link_from_wat_mon_to_spatial_analyses3, {
    navpage_name <- "Spatial-Analyses"
    updateNavbarPage(session, "pages",navpage_name)
  })
  observeEvent(input$link_from_wat_mon_to_wat_ann1, {
    navpage_name <- "Annual"
    updateNavbarPage(session, "pages",navpage_name)
  })
  
  observeEvent(input$link_from_wat_mon_to_forest_disturbances1, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Forest vs. grass parameters")
  })
  observeEvent(input$link_from_wat_mon_to_forest_disturbances2, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Forest vs. grass parameters")
  })
  observeEvent(input$link_from_wat_mon_to_hydro_snow, {
    # panel_name <- "Hydrology Model"
    navpage_name <- "More Info"
    masterpanel_id <- "more_info_panels"
    panel1_id <- "more_info_hydro_model"
    panel1_name <- "Hydrology Model"
    panel2_name <-  "Snowpack"
    updateNavbarPage(session, "pages",navpage_name)
    # updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
  })
  
  
  # Watersheds-Analyses Annual panel
  observeEvent(input$link_from_wat_ann_to_watersheds1a, {
    panel_name <- "Watersheds"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_wat_ann_to_watersheds1b, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Watershed statistics")
  })
  
  observeEvent(input$link_from_wat_ann_to_watersheds2, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Watershed statistics")
  })
  observeEvent(input$link_from_wat_ann_to_watersheds3, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Overview")
  })
  observeEvent(input$link_from_wat_ann_to_watersheds4, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Overview")
  })
  observeEvent(input$link_from_wat_ann_to_watersheds5, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Overview")
  })
  observeEvent(input$link_from_wat_ann_to_scenario_overview, {
    panel_name <- "Scenario Overview"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_wat_ann_to_framework_overview1, {
    panel_name <- "Framework Overview"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_wat_ann_to_flow_routing, {
    panel_name <- "Streamflow Routing"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_wat_ann_to_spatial_analyses1, {
    navpage_name <- "Spatial-Analyses"
    updateNavbarPage(session, "pages",navpage_name)
  })
  observeEvent(input$link_from_wat_ann_to_spatial_analyses2, {
    navpage_name <- "Spatial-Analyses"
    updateNavbarPage(session, "pages",navpage_name)
  })
  observeEvent(input$link_from_wat_ann_to_spatial_analyses3, {
    navpage_name <- "Spatial-Analyses"
    updateNavbarPage(session, "pages",navpage_name)
  })
  observeEvent(input$link_from_wat_ann_to_wat_month1, {
    navpage_name <- "Monthly"
    updateNavbarPage(session, "pages",navpage_name)
  })
  observeEvent(input$link_from_wat_ann_to_wat_month2, {
    navpage_name <- "Monthly"
    updateNavbarPage(session, "pages",navpage_name)
  })
  observeEvent(input$link_from_wat_ann_to_climate_projections1, {
    panel_name <- "Climate Projections"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_wat_ann_to_climate_projections2, {
    panel_name <- "Climate Projections"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_wat_ann_to_stakeholder_engagement, {
    panel_name <- "Stakeholder Engagement"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  
  observeEvent(input$link_from_wat_ann_to_hydro_model_prec, {
    # panel_name <- "Scenario Overview"
    navpage_name <- "More Info"
    masterpanel_id <- "more_info_panels"
    panel1_id <- "more_info_hydro_model"
    panel1_name <- "Hydrology Model"
    panel2_name <-  "Precipitation Partitioning"
    updateNavbarPage(session, "pages",navpage_name)
    # updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
  })
  observeEvent(input$link_from_wat_ann_to_forest_disturbances1, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_wat_ann_to_forest_disturbances2, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Forest vs. grass parameters")
  })
  observeEvent(input$link_from_wat_ann_to_forest_disturbances3, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_wat_ann_to_forest_disturbances4, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateCollapse(session,"elevation_landcover_maps_info_panels",open="More Info")
    
  })
  observeEvent(input$link_from_wat_ann_to_land_cover, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_wat_ann_to_hydro_model_overview, {
    # panel_name <- "Hydrology Model"
    navpage_name <- "More Info"
    masterpanel_id <- "more_info_panels"
    panel1_id <- "more_info_hydro_model"
    panel1_name <- "Hydrology Model"
    panel2_name <-  "Overview"
    updateNavbarPage(session, "pages",navpage_name)
    # updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
  })
  
  observeEvent(input$link_from_wat_ann_to_hydro_model_snow, {
    # panel_name <- "Hydrology Model"
    navpage_name <- "More Info"
    masterpanel_id <- "more_info_panels"
    panel1_id <- "more_info_hydro_model"
    panel1_name <- "Hydrology Model"
    panel2_name <-  "Snowpack"
    updateNavbarPage(session, "pages",navpage_name)
    # updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
  })
  observeEvent(input$link_from_wat_ann_to_met_model, {
    panel_name <- "Meteorology Model"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })

  # Scenario Overview panel
  observeEvent(input$link_from_scenario_to_climate_projections, {
    panel_name <- "Climate Projections"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  # observeEvent(input$link_from_scenario_to_land_cover, {
  #   panel_name <- "Forest Disturbances"
  #   updateTabsetPanel(session, "more_info_panels", panel_name)
  # })
  observeEvent(input$link_from_scenario_to_forest_disturbances1, {
    panel_name <- "Forest Disturbances"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_scenario_to_forest_disturbances2, {
    panel_name <- "Forest Disturbances"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_scenario_to_stakeholder_engagement, {
    panel_name <- "Stakeholder Engagement"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_scenario_to_framework_overview, {
    panel_name <- "Framework Overview"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  
  
  # Framework Overview panel
  # output$active <- renderUI(input$more_info_panels)
  observeEvent(input$link_from_framework_to_hydro_model_overview, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Hydrology Model"
    panel1_id <- "more_info_hydro_model"
    panel2_name <-  "Overview"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
  })
  observeEvent(input$link_from_framework_to_climate_projections, {
    panel_name <- "Climate Projections"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_framework_to_met_model, {
    panel_name <- "Meteorology Model"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_framework_to_land_cover, {
    panel_name <- "Forest Disturbances"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_framework_to_forest_disturbances, {
    panel_name <- "Forest Disturbances"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_framework_to_model_parameters, {
    panel_name <- "Forest Disturbances"
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Forest vs. grass parameters")
  })
  observeEvent(input$link_from_framework_to_flow_rout, {
    panel_name <- "Streamflow Routing"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_framework_to_watersheds, {
    panel_name <- "Watersheds"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_framework_to_stakeholder_engagement, {
    panel_name <- "Stakeholder Engagement"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_framework_to_scenario_overview, {
    panel_name <- "Scenario Overview"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_framework_to_hydro_model_snow, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Hydrology Model"
    panel1_id <- "more_info_hydro_model"
    panel2_name <-  "Snowpack"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
  })
  
  
  # Hydrology Model panel - overview
  observeEvent(input$link_from_hydro_overview_to_hydro_model_snow, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Hydrology Model"
    panel1_id <- "more_info_hydro_model"
    panel2_name <-  "Snowpack"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
  })
  observeEvent(input$link_from_hydro_overview_to_hydro_model_evap, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Hydrology Model"
    panel1_id <- "more_info_hydro_model"
    panel2_name <-  "Evapotranspiration"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
  })
  observeEvent(input$link_from_hydro_overview_to_hydro_model_infil_runoff, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Hydrology Model"
    panel1_id <- "more_info_hydro_model"
    panel2_name <-  "Soil Infiltration/Runoff"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
  })
  observeEvent(input$link_from_hydro_overview_to_hydro_model_baseflow, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Hydrology Model"
    panel1_id <- "more_info_hydro_model"
    panel2_name <-  "Baseflow"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
  })
  observeEvent(input$link_from_hydro_overview_to_met_model, {
    panel_name <- "Meteorology Model"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_hydro_overview_to_hydro_model_prec, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Hydrology Model"
    panel1_id <- "more_info_hydro_model"
    panel2_name <-  "Precipitation Partitioning"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
  })
  observeEvent(input$link_from_hydro_overview_to_flow_rout, {
    panel_name <- "Streamflow Routing"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_hydro_overview_to_land_cover, {
    panel_name <- "Forest Disturbances"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$link_from_hydro_overview_to_stakeholder_engagement, {
    panel_name <- "Stakeholder Engagement"
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  
  # Hydrology Model panel - precipitation partitioning
  observeEvent(input$link_from_hydro_p_partition_to_hydro_model_snow, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Hydrology Model"
    panel1_id <- "more_info_hydro_model"
    panel2_name <-  "Snowpack"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
    updateCollapse(session,"hydro_model_snow_info_panels",open = "More Info")
  })
  
  observeEvent(input$hydro_p_partition_update1, {
    updateCollapse(session,"hydro_model_prec_info_panels",open = "Figure Description")
  })
  
  # Hydrology Model panel - snowpack
  observeEvent(input$link_from_hydro_model_snow_to_hydro_model_p_partitioning, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Hydrology Model"
    panel1_id <- "more_info_hydro_model"
    panel2_name <-  "Precipitation Partitioning"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
  })
  
  # Hydrology Model panel - evapotranspiration
  observeEvent(input$link_from_hydro_model_evap_to_hydro_model_elev_bands, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Hydrology Model"
    panel1_id <- "more_info_hydro_model"
    panel2_name <-  "Snowpack"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
    updateCollapse(session,"hydro_model_snow_info_panels",open = "More Info")
  })
  observeEvent(input$hydro_model_evap_update1, {
    updateCollapse(session,"hydro_model_evap_info_panels",open = "More Info")
  })
  observeEvent(input$hydro_model_evap_update2, {
    updateCollapse(session,"hydro_model_evap_info_panels",open = "More Info")
  })
  observeEvent(input$hydro_model_evap_update3, {
    updateCollapse(session,"hydro_model_evap_info_panels",open = "More Info")
  })
  observeEvent(input$link_from_hydro_model_evap_to_snowpack, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Hydrology Model"
    panel1_id <- "more_info_hydro_model"
    panel2_name <-  "Snowpack"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
    updateCollapse(session,"hydro_model_snow_info_panels",open = "Figure Description")
  })
  observeEvent(input$link_from_hydro_model_evap_to_snowpack_assumptions, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Hydrology Model"
    panel1_id <- "more_info_hydro_model"
    panel2_name <-  "Snowpack"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
    updateCollapse(session,"hydro_model_snow_info_panels",open = "Assumptions")
  })
  
  # Hydrology Model panel - infiltration/runoff
  observeEvent(input$hydro_model_infil_runoff_update, {
    updateCollapse(session,"hydro_model_infil_runoff_info_panels",open = "More Info")
  })

  # Climate Projections Panel
  observeEvent(input$climate_proj_update1, {
    updateTabsetPanel(session,inputId =  "more_info_climate_proj",selected = "Mean annual comparisons")
  })
  observeEvent(input$climate_proj_to_stakeholder1, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Stakeholder Engagement"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
  })
  observeEvent(input$climate_proj_to_stakeholder2, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Stakeholder Engagement"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
  })
  observeEvent(input$climate_proj_to_watersheds1, {
    panel_name <- "Watersheds"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$climate_proj_to_watersheds2, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Watershed statistics")
  })
  
  # Forest Disturbances Panel
  observeEvent(input$forest_disturb_update0, {
    updateCollapse(session,"elevation_landcover_maps_info_panels",open = "More Info")
  })
  observeEvent(input$forest_disturb_update1, {
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Watershed statistics")
  })
  observeEvent(input$forest_disturb_update2, {
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Watershed statistics")
  })
  observeEvent(input$forest_disturb_update3, {
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Forest vs. grass parameters")
  })
  observeEvent(input$forest_disturb_update4, {
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Forest vs. grass parameters")
  })
  observeEvent(input$forest_disturb_to_watersheds, {
    panel_name <- "Watersheds"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$forest_disturb_to_watersheds1, {
    panel_name <- "Watersheds"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$forest_disturb_to_watersheds2, {
    panel_name <- "Watersheds"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$forest_disturb_to_watersheds3, {
    panel_name <- "Watersheds"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$forest_disturb_to_stakeholder1, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Stakeholder Engagement"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
  })
  observeEvent(input$forest_disturb_to_stakeholder2, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Stakeholder Engagement"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
  })
  observeEvent(input$forest_disturb_to_stakeholder3, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Stakeholder Engagement"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
  })
  observeEvent(input$forest_disturb_to_stakeholder4, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Stakeholder Engagement"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
  })
  
  # Watersheds Panel
  observeEvent(input$link_from_watersheds_to_stakeholders1, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Stakeholder Engagement"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
  })
  observeEvent(input$link_from_watersheds_to_forest_disturbance_elevations, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Overview")
  })
  observeEvent(input$link_from_watersheds_to_forest_disturbances_watershed_stats, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Watershed statistics")
  })
  
  # Stakeholders Panel
  observeEvent(input$stakeholder_update1, {
    updateCollapse(session,"stakeholder_engagement_info_panels",open = "More Info")
  })
  observeEvent(input$stakeholder_update2, {
    updateCollapse(session,"stakeholder_engagement_info_panels",open = "More Info")
  })
  observeEvent(input$stakeholder_to_climate_proj1, {
    panel_name <- "Climate Projections"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
  })
  observeEvent(input$stakeholder_to_forest_disturbance1, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Overview")
    updateCollapse(session,"elevation_landcover_maps_info_panels",open = "More Info")
  })
  observeEvent(input$stakeholder_to_forest_disturbance2, {
    panel_name <- "Forest Disturbances"
    navpage_name <- "More Info"
    updateNavbarPage(session, "pages",navpage_name)
    updateTabsetPanel(session, "more_info_panels", panel_name)
    updateTabsetPanel(session,inputId =  "more_info_forest_disturbances",selected = "Overview")
    updateCollapse(session,"elevation_landcover_maps_info_panels",open = "More Info")
  })
  
  # Streamflow Routing Panel
  observeEvent(input$flow_rout_to_hydro_model, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Hydrology Model"
    panel1_id <- "more_info_hydro_model"
    panel2_name <-  "Overview"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
    updateTabsetPanel(session,inputId =  panel1_id,selected =  panel2_name)
  })
  observeEvent(input$flow_rout_to_watersheds1, {
    masterpanel_id <- "more_info_panels"
    panel1_name <- "Watersheds"
    updateTabsetPanel(session,inputId =  masterpanel_id,selected =  panel1_name)
  })
  
  
  

## ----------------------------------References and Source Code html outputs---------------------------------------## ----
  # Notes: 
  #   - Each item can only be called once, and therefore if wanting to use the 
  #     item more than once, you need to initialize two separate items. 
  #     See https://github.com/rstudio/shiny/issues/743 
  #     ("Shiny doesn't support multiple outputs with the same name.
  #     This code would generate HTML where two elements have the same ID, 
  #     which is invalid HTML.")
  
  # Spatial-Analyses page
  output$spatial_analysis_vivoni_et_al_2008 <- renderText((references_and_code$vivoni_et_al_2008))
  output$spatial_analysis_buma_and_livneh_2015 <- renderText((references_and_code$buma_and_livneh_2015))
  output$spatial_analysis_livneh_et_al_2015a <- renderText((references_and_code$livneh_et_al_2015a))
  output$spatial_analysis_moreno_et_al_2016 <- renderText((references_and_code$moreno_et_al_2016))
  output$spatial_analysis_boon_2007 <- renderText((references_and_code$boon_2007))
  output$spatial_analysis_zou_et_al_2010 <- renderText((references_and_code$zou_et_al_2010))
  output$spatial_analysis_zou_et_al_2010_2 <- renderText((references_and_code$zou_et_al_2010))
  output$spatial_analysis_biederman_et_al_2015 <- renderText((references_and_code$biederman_et_al_2015))
  output$spatial_analysis_brown_et_al_2014 <- renderText((references_and_code$brown_et_al_2014))
  output$spatial_analysis_harpold_et_al_2014 <- renderText((references_and_code$harpold_et_al_2014))
  output$spatial_analysis_williams_et_al_2022 <- renderText((references_and_code$williams_et_al_2022))
  output$spatial_analysis_deangelo_et_al_2017 <- renderText((references_and_code$deangelo_et_al_2017))
  output$spatial_analysis_bennett_et_al_2009 <- renderText((references_and_code$bennett_et_al_2009))
  output$spatial_analysis_goeking_tarboton_2020 <- renderText((references_and_code$goeking_tarboton_2020))
  output$spatial_analysis_bohn_et_al_2018b <- renderText((references_and_code$bohn_et_al_2018b))
  output$spatial_analysis_wang_vivoni_2022 <- renderText((references_and_code$wang_vivoni_2022))
  output$spatial_analysis_dore_et_al_2008 <- renderText((references_and_code$dore_et_al_2008))
  
  output$spatial_analysis_reed_et_al_2016 <- renderText((references_and_code$reed_et_al_2016))
  output$spatial_analysis_zhang_et_al_2017 <- renderText((references_and_code$zhang_et_al_2017))
  output$spatial_analysis_li_et_al_2017 <- renderText((references_and_code$li_et_al_2017))
  output$spatial_analysis_wang_et_al_2020 <- renderText((references_and_code$wang_et_al_2020))
  output$spatial_analysis_boon_2012 <- renderText((references_and_code$boon_2012))
  output$spatial_analysis_broxton_et_al_2014 <- renderText((references_and_code$broxton_et_al_2014))
  
  output$spatial_analysis_harpold_et_al_2015 <- renderText((references_and_code$harpold_et_al_2015))
  output$spatial_analysis_overpeck_udall_2020 <- renderText((references_and_code$overpeck_udall_2020))
  output$spatial_analysis_seager_et_al_2007 <- renderText((references_and_code$seager_et_al_2007))
  
  # Watershed-Analyses Annual page
  output$wat_ann_analysis_williams_et_al_2022 <- renderText((references_and_code$williams_et_al_2022))
  output$wat_ann_analysis_biederman_et_al_2022 <- renderText((references_and_code$biederman_et_al_2022))
  
  # Watershed-Analyses Monthly page
  output$wat_mon_analysis_buma_and_livneh_2015 <- renderText((references_and_code$buma_and_livneh_2015))
  output$wat_mon_analysis_livneh_et_al_2015a <- renderText((references_and_code$livneh_et_al_2015a))
  output$wat_mon_analysis_moreno_et_al_2016 <- renderText((references_and_code$moreno_et_al_2016))
  output$wat_mon_analysis_boon_2007 <- renderText((references_and_code$boon_2007))
  output$wat_mon_analysis_zou_et_al_2010 <- renderText((references_and_code$zou_et_al_2010))
  output$wat_mon_analysis_biederman_et_al_2015 <- renderText((references_and_code$biederman_et_al_2015))
  output$wat_mon_analysis_brown_et_al_2014 <- renderText((references_and_code$brown_et_al_2014))
  output$wat_mon_analysis_harpold_et_al_2014 <- renderText((references_and_code$harpold_et_al_2014))
  output$wat_mon_analysis_williams_et_al_2022 <- renderText((references_and_code$williams_et_al_2022))
  
  # Hydrology Model page - Overview panel
  output$hydro_overview_vic_code <- renderText((references_and_code$vic_code))
  output$hydro_overview_hamman_et_al_2018 <- renderText((references_and_code$hamman_et_al_2018))
  output$hydro_overview_liang_et_al_1994 <- renderText((references_and_code$liang_et_al_1994))
  output$hydro_overview_andreadis_et_al_2009 <- renderText((references_and_code$andreadis_et_al_2009))
  output$hydro_overview_cherkauer_lettenmaier_2003 <- renderText((references_and_code$cherkauer_lettenmaier_2003))
  output$hydro_overview_bohn_vivoni_2016 <- renderText((references_and_code$bohn_vivoni_2016))
  output$hydro_overview_bureau_2012 <- renderText((references_and_code$bureau_2012))
  output$hydro_overview_christensen_lettenmaier_2007 <- renderText((references_and_code$christensen_lettenmaier_2007))
  output$hydro_overview_vano_lettenmaier_2012 <- renderText((references_and_code$vano_lettenmaier_2012))
  output$hydro_overview_bohn_et_al_2018b <- renderText((references_and_code$bohn_et_al_2018b))
  output$hydro_overview_wang_vivoni_2022 <- renderText((references_and_code$wang_vivoni_2022))
  
  # Hydrology Model page - Precipitation partitioning panel
  output$p_partitioning_andreadis_et_al_2009 <- renderText((references_and_code$andreadis_et_al_2009))
  output$p_partitioning_marks_et_al_2013 <- renderText((references_and_code$marks_et_al_2013))
  output$p_partitioning_jennings_et_al_2018 <- renderText((references_and_code$jennings_et_al_2018))
  output$p_partitioning_harpold_et_al_2017 <- renderText((references_and_code$harpold_et_al_2017))
  output$p_partitioning_wang_et_al_2019 <- renderText((references_and_code$wang_et_al_2019))
  
  # Hydrology Model page - Snowpack panel
  output$hydro_model_snowpack_andreadis_et_al_2009 <- renderText((references_and_code$andreadis_et_al_2009))
  output$hydro_model_snowpack_cherkauer_et_al_2003 <- renderText((references_and_code$cherkauer_et_al_2003))
  output$hydro_model_snowpack_liang_et_al_1994 <- renderText((references_and_code$liang_et_al_1994))
  output$hydro_model_snowpack_xiao_et_al_2022 <- renderText((references_and_code$xiao_et_al_2022))
  
  # Hydrology Model page - Evapotranspiration panel
  output$hydro_model_evap_andreadis_et_al_2009 <- renderText((references_and_code$andreadis_et_al_2009))
  output$hydro_model_evap_cherkauer_et_al_2003 <- renderText((references_and_code$cherkauer_et_al_2003))
  output$hydro_model_evap_liang_et_al_1994 <- renderText((references_and_code$liang_et_al_1994))
  output$hydro_model_evap_bohn_and_vivoni_2016 <- renderText((references_and_code$bohn_vivoni_2016))
  output$hydro_model_evap_xiao_et_al_2022 <- renderText((references_and_code$xiao_et_al_2022))
  
  # Hydrology Model page - Infiltration/Runoff panel
  output$hydro_model_infil_runoff_liang_et_al_1994 <- renderText((references_and_code$liang_et_al_1994))
  
  # Hydrology Model page - Baseflow panel
  output$hydro_model_baseflow_franchini_pacciani_1991 <- renderText((references_and_code$franchini_pacciani_1991))
  output$hydro_model_baseflow_rosenberg_et_al_2013 <- renderText((references_and_code$rosenberg_et_al_2013))
  
  # Streamflow Routing page 
  output$flow_rout_lohmann_et_al_1996 <- renderText((references_and_code$lohmann_et_al_1996))
  output$flow_rout_lohmann_et_al_1998 <- renderText((references_and_code$lohmann_et_al_1998))
  output$flow_rout_rosenberg_et_al_2013 <- renderText((references_and_code$rosenberg_et_al_2013))
  
  
  # Climate Projections page
  output$climate_proj_pierce_et_al_2014 <- renderText((references_and_code$pierce_et_al_2014))
  output$climate_proj_taylor_et_al_2012 <- renderText((references_and_code$taylor_et_al_2012))
  output$climate_proj_gautam_mascaro_2018 <- renderText((references_and_code$gautam_mascaro_2018))
  output$climate_proj_table_pierce_et_al_2014 <- renderText((references_and_code$pierce_et_al_2014))
  output$climate_proj_table_taylor_et_al_2012 <- renderText((references_and_code$taylor_et_al_2012))
  output$climate_proj_table_gautam_mascaro_2018 <- renderText((references_and_code$gautam_mascaro_2018))
  
  # Forest Disturbances page
  output$forest_disturb_sleeter_et_al_2012 <- renderText((references_and_code$sleeter_et_al_2012))
  output$forest_disturb_inegi_2013 <- renderText((references_and_code$inegi_2013))
  output$forest_disturb_usgs_et_al_2016a <- renderText((references_and_code$usgs_et_al_2016a))
  output$forest_disturb_lukas_payton_2020 <- renderText((references_and_code$lukas_payton_2020))
  output$forest_disturb_sohl_et_al_2016 <- renderText((references_and_code$sohl_et_al_2016))
  output$forest_disturb_haffey_et_al_2018 <- renderText((references_and_code$haffey_et_al_2018))
  output$forest_disturb_hurteau_et_al_2014 <- renderText((references_and_code$hurteau_et_al_2014))
  output$forest_disturb_litschert_et_al_2012 <- renderText((references_and_code$litschert_et_al_2012))
  output$forest_disturb_mcdowell_et_al_2016 <- renderText((references_and_code$mcdowell_et_al_2016))
  output$forest_disturb_bohn_et_al_2018b <- renderText((references_and_code$bohn_et_al_2018b))
  output$forest_disturb_wang_vivoni_2022 <- renderText((references_and_code$wang_vivoni_2022))
  output$forest_disturb_seidl_et_al_2011 <- renderText((references_and_code$seidl_et_al_2011))
  output$forest_disturb_goeking_tarboton_2020 <- renderText((references_and_code$goeking_tarboton_2020))
  output$forest_disturb_xiao_et_al_2022 <- renderText((references_and_code$xiao_et_al_2022))
  output$forest_disturb_livneh_et_al_2015b <- renderText((references_and_code$livneh_et_al_2015b))
  
  # Watersheds page
  output$watersheds_usgs_et_al_2016a <- renderText((references_and_code$usgs_et_al_2016a))
  output$watersheds_usgs_et_al_2016b <- renderText((references_and_code$usgs_et_al_2016b))
  output$watersheds_usgs_et_al_2019 <- renderText((references_and_code$usgs_et_al_2019))
  
  # Stakeholder Engagement page
  output$stakeholder_white_et_al_2010 <- renderText((references_and_code$white_et_al_2010))
  output$stakeholder_dunn_laing_2017 <- renderText((references_and_code$dunn_laing_2017))
  
  
  # Scenario Overview page
  output$scenario_pierce_et_al_2014 <- renderText((references_and_code$pierce_et_al_2014))
  output$scenario_pierce_et_al_2015 <- renderText((references_and_code$pierce_et_al_2015))
  output$scenario_taylor_et_al_2012 <- renderText((references_and_code$taylor_et_al_2012))
  output$scenario_sleeter_et_al_2012 <- renderText((references_and_code$sleeter_et_al_2012))
  
  
  # Framework Overview page
  output$framework_vic_code <- renderText((references_and_code$vic_code))
  output$framework_rvic_code <- renderText((references_and_code$rvic_code))
  output$framework_metsim_code <- renderText((references_and_code$metsim_code))
  output$framework_liang_et_al_1994 <- renderText((references_and_code$liang_et_al_1994))
  output$framework_hamman_et_al_2018 <- renderText((references_and_code$hamman_et_al_2018))
  output$framework_pierce_et_al_2014 <- renderText((references_and_code$pierce_et_al_2014))
  output$framework_pierce_et_al_2015 <- renderText((references_and_code$pierce_et_al_2015))
  output$framework_taylor_et_al_2012 <- renderText((references_and_code$taylor_et_al_2012))
  output$framework_bennett_et_al_2020 <- renderText((references_and_code$bennett_et_al_2020))
  output$framework_bohn_et_al_2013 <- renderText((references_and_code$bohn_et_al_2013))
  output$framework_bohn_et_al_2018 <- renderText((references_and_code$bohn_et_al_2018b))
  output$framework_bohn_et_al_2019 <- renderText((references_and_code$bohn_et_al_2019))
  output$framework_sleeter_et_al_2012 <- renderText((references_and_code$sleeter_et_al_2012))
  output$framework_bohn_vivoni_2019 <- renderText((references_and_code$bohn_vivoni_2019))
  output$framework_xiao_et_al_2018 <- renderText((references_and_code$xiao_et_al_2018))
  output$framework_xiao_et_al_2022 <- renderText((references_and_code$xiao_et_al_2022))
  output$framework_livneh_et_al_2015b <- renderText((references_and_code$livneh_et_al_2015b))
  output$framework_nijssen_et_al_2001 <- renderText((references_and_code$nijssen_et_al_2001))
  output$framework_lohmann_et_al_1996 <- renderText((references_and_code$lohmann_et_al_1996))
  output$framework_lohmann_et_al_1998 <- renderText((references_and_code$lohmann_et_al_1998))
  output$framework_bennett_et_al_2018a <- renderText((references_and_code$bennett_et_al_2018a))
  output$framework_bennett_et_al_2018b <- renderText((references_and_code$bennett_et_al_2018b))
  output$framework_usgs_et_al_2016a <- renderText((references_and_code$usgs_et_al_2016a))
  output$framework_andreadis_et_al_2009 <- renderText((references_and_code$andreadis_et_al_2009))
  output$framework_liang_et_al_1999 <- renderText((references_and_code$liang_et_al_1999))
  output$framework_cherkauer_lettenmaier_2003 <- renderText((references_and_code$cherkauer_lettenmaier_2003))
  output$framework_wigmosta_et_al_1994 <- renderText((references_and_code$wigmosta_et_al_1994))
  output$framework_franchini_pacciani_1991 <- renderText((references_and_code$franchini_pacciani_1991))
  output$framework_bohn_vivoni_2016 <- renderText((references_and_code$bohn_vivoni_2016))
  
  
## ----------------------------------Watershed-Analyses Annual tab---------------------------------------## ----
  
  # plot description output
  output$wat_ann_plot_description <- renderText({
    if (input$wat_ann_plot_type_selected==1) {
      return(plot_specs_wat_ann_barchart$plot_description)
    } else if (input$wat_ann_plot_type_selected==2){
      return(plot_specs_wat_ann_change_line$plot_description$relative)
    } else {
      return(plot_specs_wat_ann_change_line$plot_description$absolute)
    }
  })
  
  # plot description to other panels
  observeEvent(input$wat_ann_plot_description_to_freeform, {
    updateCollapse(session,"watershed_analyses_annual_panels",open="Freeform Analysis")
  })
  observeEvent(input$wat_ann_plot_description_to_guided, {
    updateCollapse(session,"watershed_analyses_annual_panels",open="Guided Analysis")
  })
  
  # render plot
  output$wat_ann_plot <- renderPlotly({
    # create plot function input list
    wat_ann_basins_selected <- c(input$wat_ann_basin_selected_1,input$wat_ann_basin_selected_2)
    wat_ann_vars_selected <- c(input$wat_ann_var_selected_1,input$wat_ann_var_selected_2)
    plot_input_list <- list(
      "basins_selected" = wat_ann_basins_selected,
      "vars_selected" = wat_ann_vars_selected
    )
    # run plot function
    if (input$wat_ann_plot_type_selected==1) {
      plot_input_list$input_data = basin_agg_clim_mann
      fig <-plot_mean_ann_val_barplot(plot_input_list)
    } else if (input$wat_ann_plot_type_selected==2){
      plot_input_list$input_data = basin_agg_clim_mann_changes
      plot_input_list$plot_type = "relative"
      fig <-plot_mean_ann_anomaly_lineplot(plot_input_list)
    } else {
      plot_input_list$input_data = basin_agg_clim_mann_abs_changes
      plot_input_list$plot_type = "absolute"
      fig <-plot_mean_ann_anomaly_lineplot(plot_input_list)
      }
    
    return(fig)
  })
  
  # Main guided analyses 
  observeEvent(input$wat_ann_analyses,{
      guided_analyses_wat_ann_controls = guided_analyses_wat_ann[[input$wat_ann_analyses]]
      updateVarSelectInput(session,"wat_ann_basin_selected_1",selected = guided_analyses_wat_ann_controls$wat_ann_basin_selected_1)
      updateVarSelectInput(session,"wat_ann_basin_selected_2",selected = guided_analyses_wat_ann_controls$wat_ann_basin_selected_2)
      updateVarSelectInput(session,"wat_ann_var_selected_1",selected = guided_analyses_wat_ann_controls$wat_ann_var_selected_1)
      updateVarSelectInput(session,"wat_ann_var_selected_2",selected = guided_analyses_wat_ann_controls$wat_ann_var_selected_2)
      updateRadioButtons(session,"wat_ann_plot_type_selected",selected = guided_analyses_wat_ann_controls$wat_ann_plot_type_selected)
      
      # Update the analysis results description
      if (identical(input$wat_ann_analyses, "wat_ann_analysis_1")) {
        
        # Climate scenario differences
        output$wat_ann_analysis_description<- renderUI({
          tagList(
            HTML("<b>Background:</b>"),
            HTML("First let’s compare the two underlying climate scenarios, by comparing mean annual Total precipitation (<i>P</i>) and Air temperature (<i>T</i>) values."),
            tags$li(HTML("Mean annual changes are determined by comparing the height of ‘Far-Future’ bars (grey/colored bars) to the ‘Baseline’ bar (black bar) or the ‘Baseline’ reference line (dashed horizontal line).")),
            tags$li(HTML("You can use the controls in the"), 
                    actionLink("wat_ann_analysis_1_update0","'Freemform Analysis' panel"),
                    HTML("to change the plot type (Mean annual changes with fluxes as"),
                    actionLink("wat_ann_analysis_1_update1","percentages"), 
                    HTML("or"), 
                    actionLink("wat_ann_analysis_1_update2","absolute differences"), 
                    HTML(").")
                    ),
            tags$li(HTML("For now, keep the plot type as the '"),
                    actionLink("wat_ann_analysis_1_update3","Mean annual values"), 
                    HTML("' (barplots).")),
            br(),
            HTML("<b>Climate Scenario Comparisons:</b>"),
            tags$li(HTML("Since <i>P</i> and <i>T</i> are climate variables (not affected by the land cover), the changes are identical between all Far-Future cases.")),
            tags$li(HTML("<code>The ‘Hot/Dry’ and ‘Warm/Wet’ cases represent two ‘bookends’ of climate futures</code> that capture the sensitivity of hydrology to a range of <code>climate uncertainty</code> ("),
                    actionLink("link_from_wat_ann_to_climate_projections1", "more info here"),
                    HTML(").")
                    ),
            tags$li(HTML("These bookends were selected based on our"),
                    actionLink("link_from_wat_ann_to_stakeholder_engagement", "Stakeholder Engagement"),
                    HTML("activities.")),
            br(),
            helpText(
              HTML("<b>Helpful hints:</b>"),
              tags$li(
                actionLink("wat_ann_analysis_1_update4", "Change the variables"),
                HTML("to 'Rainfall' and 'Snowfall' to compare the changes in precipitation partitioning.")),
              tags$li(
                actionLink("link_from_wat_ann_to_hydro_model_prec", "Click here"),
                HTML("to learn more about how VIC estimates precipitation partitioning."))
            )
          )
        })
        
      } else if (identical(input$wat_ann_analyses, "wat_ann_analysis_2")) {
        # Snowpack Impacts
        output$wat_ann_analysis_description<- renderUI({
          tagList(
            HTML("<b>Background:</b>"),
            HTML("Next we assess the hydrologic sensitivity to climate change and a range of forest disturbances in terms of the"),
            actionLink("link_from_wat_ann_to_hydro_model_snow", "modeled snowpack dynamics"),
            HTML("."),
            tags$li(
              actionLink("link_from_wat_ann_to_forest_disturbances1", "Forest Disturbances"),
              HTML("included conversions of high-elevation (≥ 1,800 m) forests to grasses (by 0, 10, 30, 60, or 90%) applied to the Far-Future land use land cover (LULC) conditions (from the "),
              actionLink("link_from_wat_ann_to_land_cover","Forest Disturbances"),
              HTML(").")
            ),
            tags$li(HTML("Hydrologic sensitivities to these changes are determined by comparing Far-Future (grey/colored bars) and Baseline (black bars) values.")),
            br(),
            HTML("<b>Climate Change Impacts:</b>"),
            tags$li(HTML("Comparisons of Baseline values to either the Far-Future 'Climate-only' (using Basline LULC) or '0% Disturbance' (Far-Future LULC, no forest disturbances) case indicate the climate impact.")),
            tags$li(HTML("<code>Climate change reduced snow water equivalent (<i>SWE</i>) relative to Baseline</code>, with larger reductions in the Hot/Dry case accompanying larger snowfall (<i>P<sub>S</sub></i>) decline than the Warm/Wet case.")),
            tags$li(HTML("The different levels of <i>P<sub>S</sub></i> decline between climate cases was due to"),
                    actionLink("wat_ann_analysis_2_update1", HTML("opposite total precipitation trends and different degrees of warming."))),
            tags$li(actionLink("wat_ann_analysis_2_update2","Sublimation and Snowmelt"),
                    HTML("also declined, verifying that <code><i>SWE</i> reductions were due to <i>P<sub>S</sub></i> decline accompanying climate change</code>.")),
            helpText(tags$li(
              HTML("The 'Climate-only' and '0% Disturbance' cases had nearly identical results for all variables and regions."), 
            ),
            tags$li(
              HTML("This indicated that the LULC changes from the FORE-SCE had a negligble impact on the overall water budget,"),
              HTML("primarily due to the VIC assumptions (click"),
              actionLink("link_from_wat_ann_to_hydro_model_overview","here"),
              HTML(" for more info).")
            )),
            br(),
            HTML("<b>Forest Disturbance Impacts under Climate Change:</b>"),
            tags$li(HTML("<code>Forest disturbances minimized reductions in"),
                    actionLink("wat_ann_analysis_2_update3",HTML("<i>SWE</i> and <i>M</i>")),
                    HTML("under climate change</code> (increasing values with forest disturbances).")),
            tags$li(HTML("This was due to canopy reductions and larger canopy spacing when"), 
                    actionLink("link_from_wat_ann_to_forest_disturbances2","grasses replace forests (causing higher ground snowpack accumulation).")),
            tags$li(HTML("The effect was more pronounced in the Warm/Wet case and led to a near-recovery of Baseline <i>SWE</i> for the 90% forest disturbance case."))
          )
        })
        
      } else if (identical(input$wat_ann_analyses, "wat_ann_analysis_3")) {
        # Evapotranspiration Impacts
        output$wat_ann_analysis_description<- renderUI({
          tagList(
            HTML("<b>Climate Change Impacts:</b>"),
            br(),
            tags$li(HTML("Total evapotranspiration (<i>ET</i>) trends followed total precipitation (<i>P</i>), with increases in the Warm/Wet and declines in the Hot/Dry cases.")),
            tags$li(HTML("Climate change had a stronger effect on <i>ET</i> than that of any LULC + Forest Disturbance scenario, indicating that <code>climate uncertainty overwhelms the impact of forest disturbance on future <i>ET</i></code>.")),
            br(),
            HTML("<b>Forest Disturbance Impacts under Climate Change:</b>"),
            tags$li(HTML("Overall, forest disturbances slightly reduced <i>ET</i> relative to no disturbance on average across the basin, but differed in their magnitude based on the amount of <i>P</i> in each climate case.")),
            tags$li(HTML("We attributed <i>ET</i> reductions to"),
                    actionLink("wat_ann_analysis_3_update1","canopy evaporation"),
                    HTML("from"),
                    actionLink("link_from_wat_ann_to_forest_disturbances3","the reduced Leaf Area Index and larger canopy spacing for grasses.")),
            tags$li(HTML("<code>Forest disturbance impacts to <i>ET</i> were more limited under the Hot/Dry climate"),
                    HTML("due to the increasingly water-limited conditions</code> ("),
                    actionLink("wat_ann_analysis_3_update2",HTML("most of <i>P</i>")),
                    HTML("was lost to <i>ET</i> regardless of vegetation status).")),
            tags$li(HTML("The Upper Basin also exhibited the largest forest disturbance impacts due to <i>P</i> trends and the larger area of disturbed forests at high elevations (≥ 1,800 m,"),
                    actionLink("link_from_wat_ann_to_watersheds2","more info here"),
                    HTML(")."))
          )
        })
        
      } else if (identical(input$wat_ann_analyses, "wat_ann_analysis_4")) {
        # Streamflow Impacts
        output$wat_ann_analysis_description<- renderUI({
          tagList(
            HTML("<b>Climate Change Impacts:</b>"),
            tags$li(HTML("Streamflow (<i>Q</i>) trends followed total precipitation (<i>P</i>), with increases in the Warm/Wet and declines in the Hot/Dry cases.")),
            tags$li(HTML("Clearly, the hydrologic uncertainties due to climate change were represented well by the two"),
                    actionLink("link_from_wat_ann_to_climate_projections2","selected climate bookends.")),
            br(),
            HTML("<b>Forest Disturbance Impacts under Climate Change:</b>"),
            tags$li(HTML("The forest disturbance effects to"),
                    actionLink("wat_ann_analysis_4_update1",HTML("total evapotranspiration (<i>ET</i>)")),
                    HTML("and"),
                    actionLink("wat_ann_analysis_4_update2",HTML("<i>SWE</i>")),
                    HTML("caused an increase in <i>Q</i>"),
                    HTML("(relative to the case without disturbance), with larger changes in the Warm/Wet case than the Hot/Dry case."),
            ),
            tags$li(HTML("The forest disturbances under the Hot/Dry climate were not enough to fully offset warming and <i>P</i> declines on mean annual <i>Q</i>, even under the 90% disturbance case.")),
            tags$li(HTML("<code>As a result, the climate change uncertainty overwhelms the impact of forest disturbances on future streamflow.</code>"))
          )
        })
        
      } else if (identical(input$wat_ann_analyses, "wat_ann_analysis_5")) {
        # Underlying Efficiency Changes
        output$wat_ann_analysis_description<- renderUI({
          tagList(
            HTML("<b>Background:</b>"),
            HTML("We will make a deeper assessment of how each climate scenario modulated the impact of forest disturbance to streamflow supplies, or"),
            actionLink("link_from_wat_ann_to_flow_routing",HTML("the total runoff (<i>R</i>) + baseflow (<i>BF</i>).")),
            tags$li(
              HTML("The figure above shows the Far-Future changes (\u0394; relative to Baseline) in mean annual <i>Q</i> and supply efficiency (<i>RBFE</i>), or the change in mean annual <i>R</i> and <i>BF</i> per precipitation (<i>P</i>).")
            ),
            tags$li(
              HTML("Average changes across the Upper Basin and the Green subbasin (representing a"),
              actionLink("link_from_wat_ann_to_watersheds3","basin headwater region"),
              HTML(") are shown.")
            ),
            helpText(
              tags$li(HTML("Negative <i>\u0394RBFE</i> values imply more ‘water-limited’ conditions than Baseline, where greater amounts of <i>P</i> are lost to total evapotranspiration (<i>ET</i>) at the expense of <i>R</i> and <i>BF</i>.")),
              tags$li(HTML("Likewise, postive in <i>\u0394RBFE</i> values imply more ‘energy-limited’ conditions than Baseline, where less of <i>P</i> is lost to <i>ET</i>, causing the production of more <i>R</i> and <i>BF</i>.")),
            ),
            
            br(),
            HTML("<b>Results and discussion:</b>"),
            tags$li(HTML("Though <i>RBFE</i> declined due to climate change alone (0% disturbance case), <i>Q</i> increased due to <i>P</i> increases in the Warm/Wet case.")),
            tags$li(HTML("Forest disturbances increased <i>RBFE</i> over these regions for both climate cases.")),
            tags$li(HTML("Forest disturbances at"),
                    actionLink("link_from_wat_ann_to_forest_disturbances4","historic rates (30% or more)"),
                    HTML("reversed the impacts of climate change on <i>RBFE</i> only in the Warm/Wet case, as indicated by the cross-over point on the 0% horizontal line at ~45% forest disturbance.")),
            tags$li(HTML("A similar cross-over point was found for the"),
                    actionLink("wat_ann_analysis_5_update1","Upper Colorado subbasin"),
                    HTML("(another"),
                    actionLink("link_from_wat_ann_to_watersheds4","basin headwater region"),
                    (").")),
            tags$li(HTML("Forest disturbances of 30% or more were also sufficient to reverse the impacts of climate change on <i>Q</i> only in the Warm/Wet case for the"),
                    actionLink("wat_ann_analysis_5_update2","San Juan subbasin"),
                    HTML("(another"),
                    actionLink("link_from_wat_ann_to_watersheds5","basin headwater region"),
                    (").")),
            tags$li(HTML("In contrast, there were <code>more limited forest disturbance impacts on <i>RBFE</i> and <i>Q</i> in the Hot/Dry climate</code> for all regions (increases relative to Baseline were not found).")),
            tags$li(HTML("<code>This was attributed to the increasingly water-limited conditons of the Hot/Dry case</code>, under which the majority of <i>P</i> was lost to <i>ET</i> regardless of vegetation status.")),
          )
        })
        
      } else if (identical(input$wat_ann_analyses, "wat_ann_analysis_conclusions")) {
        # Conclusions
        output$wat_ann_analysis_description<- renderUI({
          tagList(
            HTML("<b>Conclusions:</b>"),
            tags$li(HTML("Forest reductions augmented snowpacks (and"),
                    actionLink("wat_ann_analysis_conclusions_update1","reduced total evapotranspiration"),
                    HTML(") under climate change, leading to increased streamflow, relative to the case without disturbance.")),
            tags$li(HTML("The increases in water yield scaled with the forest disturbance amounts, confirming similar conclusions by prior efforts.<sup>1</sup>")),
            tags$li(HTML("While forest disturbances at historic rates (i.e., 30% reductions) were sufficient to reverse warming impacts to"),
                    actionLink("wat_ann_analysis_conclusions_update2","key headwater regions"),
                    HTML("in the Warm/Wet case, the effects were not enough to offset the high evapotranspiration of the Hot/Dry future (even at the scale of the 90% forest disturbance which would require massive wildfire impacts).")),
            # tags$li(
            #   HTML("These results are analogous to negligible wildfire impacts to streamflow under warmer conditions.<sup>2</sup>")
            # ),
            # tags$li(HTML("As a result, the climate change uncertainty overwhelms the impact of forest disturbances on future streamflow.")),
            br(),
            HTML("<b>Next analysis steps:</b>"),
            tags$ol(
              tags$li(HTML("Check out the"),
                      actionLink("link_from_wat_ann_to_wat_month2","Monthly Watershed-Analyses"),
                      HTML("to learn the impacts to streamflow timing and the underlying snowpack dynamics.")),
              tags$li(HTML("Follow the guided analysis on the"),
                      actionLink("link_from_wat_ann_to_spatial_analyses3","Spatial-Analyses"),
                      HTML("page to explore how impacts varied across the basin and learn the overall conclusions and water resource management implications of this work.")),
            ),
            br(),
            helpText(
              HTML("<b>References:</b>"),
              tags$ol(
                tags$li(htmlOutput("wat_ann_analysis_williams_et_al_2022")),
                # tags$li(htmlOutput("wat_ann_analysis_biederman_et_al_2022"))
              )
            )
          )
        })
        
      }
      
  })
  
  # Guided analyses - subcomponents
  observeEvent(input$wat_ann_analysis_1_update0, {
    updateCollapse(session,"watershed_analyses_annual_panels",open="Freeform Analysis")
  })
  observeEvent(input$wat_ann_analysis_1_update1, {
    updateRadioButtons(session,"wat_ann_plot_type_selected",selected = 2)
  })
  observeEvent(input$wat_ann_analysis_1_update2, {
    updateRadioButtons(session,"wat_ann_plot_type_selected",selected = 3)
  })
  observeEvent(input$wat_ann_analysis_1_update3, {
    updateRadioButtons(session,"wat_ann_plot_type_selected",selected = 1)
  })
  observeEvent(input$wat_ann_analysis_1_update4, {
    updateVarSelectInput(session,"wat_ann_var_selected_1",selected = "Rainfall")
    updateVarSelectInput(session,"wat_ann_var_selected_2",selected = "Snowfall")
  })
  observeEvent(input$wat_ann_analysis_2_update1, {
    updateRadioButtons(session,"wat_ann_analyses",selected = "wat_ann_analysis_1")
  })
  observeEvent(input$wat_ann_analysis_2_update2, {
    updateVarSelectInput(session,"wat_ann_var_selected_1",selected = "Sublimation")
    updateVarSelectInput(session,"wat_ann_var_selected_2",selected = "Snowmelt")
  })
  observeEvent(input$wat_ann_analysis_2_update3, {
    updateVarSelectInput(session,"wat_ann_var_selected_1",selected = "Snow water equivalent")
    updateVarSelectInput(session,"wat_ann_var_selected_2",selected = "Snowmelt")
  })
  observeEvent(input$wat_ann_analysis_3_update1, {
    updateVarSelectInput(session,"wat_ann_var_selected_2",selected = "Canopy evaporation")
  })
  observeEvent(input$wat_ann_analysis_3_update2, {
    updateVarSelectInput(session,"wat_ann_var_selected_2",selected = "Total precipitation")
  })
  observeEvent(input$wat_ann_analysis_4_update1, {
    updateVarSelectInput(session,"wat_ann_var_selected_1",selected = "Streamflow ([cubic km])")
    updateVarSelectInput(session,"wat_ann_var_selected_2",selected = "Total evapotranspiration")
  })
  observeEvent(input$wat_ann_analysis_4_update2, {
    updateVarSelectInput(session,"wat_ann_var_selected_1",selected = "Streamflow ([cubic km])")
    updateVarSelectInput(session,"wat_ann_var_selected_2",selected = "Snow water equivalent")
  })
  observeEvent(input$wat_ann_analysis_5_update1, {
    updateVarSelectInput(session,"wat_ann_basin_selected_2",selected = "Upper Colorado")
    updateVarSelectInput(session,"wat_ann_var_selected_1",selected = "Streamflow ([cubic km])")
    updateVarSelectInput(session,"wat_ann_var_selected_2",selected = "Supply efficiency ([runoff + baseflow]/precipitation)")
  })
  observeEvent(input$wat_ann_analysis_5_update2, {
    updateVarSelectInput(session,"wat_ann_basin_selected_1",selected = "San Juan")
    updateVarSelectInput(session,"wat_ann_var_selected_1",selected = "Streamflow ([cubic km])")
    updateVarSelectInput(session,"wat_ann_var_selected_2",selected = "Supply efficiency ([runoff + baseflow]/precipitation)")
  })
  observeEvent(input$wat_ann_analysis_conclusions_update1, {
    updateVarSelectInput(session,"wat_ann_var_selected_1",selected = "Total evapotranspiration")
  })
  observeEvent(input$wat_ann_analysis_conclusions_update2, {
    updateVarSelectInput(session,"wat_ann_basin_selected_1",selected = "San Juan")
    updateVarSelectInput(session,"wat_ann_basin_selected_2",selected = "Upper Colorado")
    updateVarSelectInput(session,"wat_ann_var_selected_1",selected = "Snow water equivalent")
  })
  
  # observe({
  #   
  # })
  # 
## ----------------------------------Spatial-Analyses tab---------------------------------------## ----
  
  # plot description output
  output$spatial_plot_description <- renderText({
    spatial_input_argument_dictionary$impact_scenarios[[input$spatial_impact_type_selected]]$plot_description[[input$spatial_temporal_scale_selected]]
    })
  
  # plot description to other panels
  observeEvent(input$spatial_plot_description_to_freeform, {
    updateCollapse(session,"spatial_analyses_panels",open="Freeform Analysis")
  })
  observeEvent(input$spatial_plot_description_to_guided, {
    updateCollapse(session,"spatial_analyses_panels",open="Guided Analysis")
  })
  observeEvent(input$spatial_plot_description_to_conclusions, {
    updateCollapse(session,"spatial_analyses_panels",open="Overarching Research Conclusions")
  })
  observeEvent(input$spatial_plot_description_to_implications, {
    updateCollapse(session,"spatial_analyses_panels",open="Water Management and Policy Implications")
  })
  
  
  # Plot title outputs
  output$spatial_plot_warmwet_var1 <- renderText({
    paste0("<br><center><b>",input$spatial_var_selected_1,"</b></center>")
  })
  output$spatial_plot_warmwet_var2 <- renderText({
    paste0("<br><center><b>",input$spatial_var_selected_2,"</b></center>")
  })
  output$spatial_plot_hotdry_var1 <- renderText({
    paste0("<br><center><b>",input$spatial_var_selected_1,"</b></center>")
  })
  output$spatial_plot_hotdry_var2 <- renderText({
    paste0("<br><center><b>",input$spatial_var_selected_2,"</b></center>")
  })
  
  
  
  # Initialize maps - Warm/Wet
  output$spatial_scenario_maps_warmwet = renderCombineWidgets({
    # get associated subbasin aggregated data (for the hover-over labels)
    temporal_scale_stored <- spatial_input_argument_dictionary$temporal_scales[[input$spatial_temporal_scale_selected]]$stored_name
    impact_type_stored <-spatial_input_argument_dictionary$impact_scenarios[[input$spatial_impact_type_selected]]$stored_name
    if (identical(temporal_scale_stored,"annual")) {
      if (identical(impact_type_stored,"climate_impact")){
        spatial_subbasin_aggs <- basin_agg_clim_mann_abs_changes
      } else {
        spatial_subbasin_aggs <- basin_agg_clim_mann_scenario_diffs
      }
    } else if (identical(temporal_scale_stored,"cool_season")) {
      if (identical(impact_type_stored,"climate_impact")){
        spatial_subbasin_aggs <- basin_agg_clim_mseas_cool_abs_changes   # change to use absolute differences
      } else {
        spatial_subbasin_aggs <- basin_agg_clim_mseas_cool_scenario_diffs
      }
    } else if (identical(temporal_scale_stored,"warm_season")) {
      if (identical(impact_type_stored,"climate_impact")){
        spatial_subbasin_aggs <- basin_agg_clim_mseas_warm_abs_changes   # change to use absolute differences
      } else {
        spatial_subbasin_aggs <- basin_agg_clim_mseas_warm_scenario_diffs
      }
    }
    
    # get plot input list (variable one, Warm/Wet climate)
    plot_input_list = list(
      "var_selected" = input$spatial_var_selected_1,
      "temporal_scale_selected" = input$spatial_temporal_scale_selected,
      "impact_type_selected" = input$spatial_impact_type_selected,
      "climate_scenario" = "Warm_Wet",
      "subbasin_aggs" = spatial_subbasin_aggs,
      "basemap_on" = input$spatial_basemap_on    
    )
    
    fig1 <-plot_spatial_map(plot_input_list) 
    
    
    # get plot input list (variable two, Warm/Wet climate)
    plot_input_list = list(
      "var_selected" = input$spatial_var_selected_2,
      "temporal_scale_selected" = input$spatial_temporal_scale_selected,
      "impact_type_selected" = input$spatial_impact_type_selected,
      "climate_scenario" = "Warm_Wet",
      "subbasin_aggs" = spatial_subbasin_aggs,
      "basemap_on" = input$spatial_basemap_on    
    )
    
    fig2 <-plot_spatial_map(plot_input_list)
    if (input$spatial_sync_maps){
      fig1 <- fig1 %>% syncWith("basicmaps")
      fig2 <- fig2 %>% syncWith("basicmaps")
    }
    
    combineWidgets(fig1, fig2,ncol = 2)

  })
  
  # Initialize maps - Hot/Dry
  output$spatial_scenario_maps_hotdry = renderCombineWidgets({
    # get associated subbasin aggregated data (for the hover-over labels)
    temporal_scale_stored <- spatial_input_argument_dictionary$temporal_scales[[input$spatial_temporal_scale_selected]]$stored_name
    impact_type_stored <-spatial_input_argument_dictionary$impact_scenarios[[input$spatial_impact_type_selected]]$stored_name
    if (identical(temporal_scale_stored,"annual")) {
      if (identical(impact_type_stored,"climate_impact")){
        spatial_subbasin_aggs <- basin_agg_clim_mann_abs_changes
      } else {
        spatial_subbasin_aggs <- basin_agg_clim_mann_scenario_diffs
      }
    } else if (identical(temporal_scale_stored,"cool_season")) {
      if (identical(impact_type_stored,"climate_impact")){
        spatial_subbasin_aggs <- basin_agg_clim_mseas_cool_abs_changes   # change to use absolute differences
      } else {
        spatial_subbasin_aggs <- basin_agg_clim_mseas_cool_scenario_diffs
      }
    } else if (identical(temporal_scale_stored,"warm_season")) {
      if (identical(impact_type_stored,"climate_impact")){
        spatial_subbasin_aggs <- basin_agg_clim_mseas_warm_abs_changes   # change to use absolute differences
      } else {
        spatial_subbasin_aggs <- basin_agg_clim_mseas_warm_scenario_diffs
      }
    }
    
    # get plot input list (variable one, Hot/Dry climate)
    plot_input_list = list(
      "var_selected" = input$spatial_var_selected_1,
      "temporal_scale_selected" = input$spatial_temporal_scale_selected,
      "impact_type_selected" = input$spatial_impact_type_selected,
      "climate_scenario" = "Hot_Dry",
      "subbasin_aggs" = spatial_subbasin_aggs,
      "basemap_on" = input$spatial_basemap_on    
    )
    
    fig1 <-plot_spatial_map(plot_input_list)
    
    # get plot input list (variable two, Hot/Dry climate)
    plot_input_list = list(
      "var_selected" = input$spatial_var_selected_2,
      "temporal_scale_selected" = input$spatial_temporal_scale_selected,
      "impact_type_selected" = input$spatial_impact_type_selected,
      "climate_scenario" = "Hot_Dry",
      "subbasin_aggs" = spatial_subbasin_aggs,
      "basemap_on" = input$spatial_basemap_on    
    )
    
    fig2 <-plot_spatial_map(plot_input_list)
    
    if (input$spatial_sync_maps){
      fig1 <- fig1 %>% syncWith("basicmaps")
      fig2 <- fig2 %>% syncWith("basicmaps")
    }
    combineWidgets(fig1, fig2, ncol = 2)
    
  })
  
  # Main guided analyses
  observeEvent(input$spatial_guided_analyses,{
    guided_analyses_spatial_controls = guided_analyses_spatial[[input$spatial_guided_analyses]]
    updateVarSelectInput(session,"spatial_var_selected_1",selected = guided_analyses_spatial_controls$spatial_var_selected_1)
    updateVarSelectInput(session,"spatial_var_selected_2",selected = guided_analyses_spatial_controls$spatial_var_selected_2)
    updateVarSelectInput(session,"spatial_temporal_scale_selected",selected = guided_analyses_spatial_controls$spatial_temporal_scale_selected)
    updateVarSelectInput(session,"spatial_impact_type_selected",selected = guided_analyses_spatial_controls$spatial_impact_type_selected)
    
    if (identical(input$spatial_guided_analyses, "spatial_analysis_1")) {
      
      # Snowpack Impacts
      output$spatial_analysis_description<- renderUI({
        tagList(
          HTML("<b>Climate Change Impacts:</b>"),
          tags$li(HTML("The climate change impacts to snow water equivalent (<i>SWE</i>) and snowmelt (<i>M</i>) are determined by comparing the spatial distributions of Far-Future mean annual changes (\u0394) relative to Baseline (without any forest disturbances).")),
          tags$li(HTML("Move your mouse over the maps to see the average changes across each subbasin region ("),
                  actionLink("link_from_spatial_to_watersheds2","click here"),
                  HTML("<Click here> for more info on subbasins).")
                  ),
          tags$li(HTML("Climate change led to large declines in <i>SWE</i> and <i>M</i>, especially under the Hot/Dry climate.")),
          br(),
          HTML("<b>Forest Disturbance Impacts under Climate Change:</b>"),
          tags$li(actionLink("spatial_analysis_1_update1","Change the impact type to ‘30% Forest disturbance'.")),
          tags$li(HTML("These maps show the difference in mean annual values between the case with 30% forest disturbance ("),
                  actionLink("link_from_spatial_to_forest_disturbances0", "the disturbance case set by historic amounts"),
                  HTML(") and the case without disturbance, highlighting where disturbances had the greatest impact.")),
          tags$li(HTML("Forest disturbances increased <i>SWE</i> and <i>M</i> due to larger ground snowpack accumulation that accompany"),
                  actionLink("link_from_spatial_to_forest_disturbances1","canopy reductions when grasses replace forests.")),
          tags$li(HTML("Switching the 'impact type' (from the"),
                       actionLink("spatial_analysis_1_update2","'Freemform Analysis' panel"),
                       HTML(") reveals that these <code>impacts scale with the amount of forest disturbance.</code>")),
          tags$li(HTML("<code>The climate cases modulated the forest disturbance impacts</code> (larger disturbance impacts under the Warm/Wet than the Hot/Dry climate).<br>&nbsp;&nbsp;&nbsp;&nbsp;<i>This climate modulation effect is explored more in the"),
                  actionLink("spatial_analysis_1_update3",HTML("next analysis step.</i>")))
          
        )
      })
    } else if (identical(input$spatial_guided_analyses, "spatial_analysis_2")) {
      
      # Evapotranspiration Impacts
      output$spatial_analysis_description<- renderUI({
        tagList(
          HTML("<b>Climate Change Impacts:</b>"),
          tags$li(HTML("Trends in total evapotranspiration (<i>ET</i>) followed spatial variations in total precipitation (<i>P</i>) given the water-limited conditions in the CRB.<sup>1</sup> ")),
          tags$li(HTML("Warm/Wet conditions included widespread <i>P</i> and <i>ET</i> increases with larger changes towards the northwest.")),
          tags$li(HTML("Hot/Dry conditions led to <i>P</i> and <i>ET</i> declines in most regions except in high elevations of the north, with larger declines in the southeast.")),
          br(),
          HTML("<b>Forest Disturbance Impacts under Climate Change:</b>"),
          tags$li(actionLink("spatial_analysis_2_update1","Switch the impact type to ‘30% Forest disturbance' and the 'Total precipitation' variable to 'Canopy evaporation'.")),
          tags$li(HTML("<code>Forest disturbances decreased <i>ET</i> in most regions</code> following canopy evaporation (<i>E<sub>C</sub></i>) declines, due to"), 
                  actionLink("link_from_spatial_to_forest_disturbances2","canopy reductions and larger canopy spacing when grasses replace forests.")),
          tags$li(HTML("Disturbances slightly increased <i>ET</i> over some mid-elevation regions ("),
                  actionLink("link_from_spatial_to_wat_ann4",HTML("causing muted impacts to <i>ET</i> at the basin-averaged scale")),
                  HTML(") due to"),
                  actionLink("spatial_analysis_2_update2",HTML("higher soil evaporation (<i>E<sub>Soil</sub></i>) rates."))),
          tags$li(HTML("<code>Climate cases modulated the forest disturbance impact to <i>ET</i> (larger impacts under Warm/Wet climate, with more substantial <i>ET</i> declines).</code><br>&nbsp;&nbsp;&nbsp;&nbsp;<i>This in turn modulated the effect to streamflow supplies, explored more in the"),
                  actionLink("spatial_analysis_2_update3",HTML("next analysis step.</i>"))
                  
                  ),
          helpText(
            HTML("<b>References:</b>"),
            tags$ol(
              tags$li(htmlOutput("spatial_analysis_vivoni_et_al_2008"))))
        )
      })
    } else if (identical(input$spatial_guided_analyses, "spatial_analysis_3")) {
      
      # Flow Supply Impacts
      output$spatial_analysis_description<- renderUI({
        tagList(
          HTML("<b>Climate Change Impacts:</b>"),
          tags$li(HTML("Total runoff and baseflow (<i>RBF</i>) represents the ‘streamflow supplies’ of the system, as the"),
                  actionLink("link_from_spatial_to_flow_routing",HTML("model routes <i>RBF</i> through the channel network to simulate streamflow (<i>Q</i>) at each outlet."))),
          tags$li(HTML("Warm/Wet conditions increased soil moisture (<i>SM</i>) and <i>RBF</i> over high elevations in the northwest, despite declines in snow water equivalent (<i>SWE</i>).")),
          tags$li(HTML("Hot/Dry conditions led to large <i>RBF</i> declines in northern high elevation regions due declines in <i>SM</i> and <i>SWE</i>, as well as total evapotranspiration (<i>ET</i>) increases.")),
          br(),
          HTML("<b>Forest Disturbance Impacts under Climate Change:</b>"),
          tags$li(actionLink("spatial_analysis_3_update1","Change the impact type to ‘30% Forest disturbance'.")),
          tags$li(HTML("Forest disturbances increased <i>RBF</i> in headwater regions following the disturbance-induced <i>SWE</i> increases and <i>ET</i> declines.")),
          tags$li(HTML("While forest disturbances caused much larger <i>RBF</i> increases under the Warm/Wet climate, disturbances also led to declines in <i>RBF</i> over some regions under the Hot/Dry climate.")),
          tags$li(HTML("<code>This indicated that the climate uncertainties modulated the impact of forest disturbances.</code><br>&nbsp;&nbsp;&nbsp;&nbsp;<i>The underlying mechanism for the climate modulation effect is explored in the"),
                  actionLink("spatial_analysis_3_update2",HTML("final analysis step.</i>")))
        )
      })
    } else if (identical(input$spatial_guided_analyses, "spatial_analysis_4")) {
      
      # Supply Efficiency Impacts
      output$spatial_analysis_description<- renderUI({
        tagList(
          HTML("<b>Background:</b> Finally we will assess impacts to mean flow supply (total <i>R</i> + <i>BF</i>) efficiency (<i>RBFE</i>), or the mean <i>R</i> and <i>BF</i> per total precipitation (<i>P</i>)."),
          tags$li(HTML("Changes (\u0394) in <i>RBFE</i> closer to zero imply more ‘water-limited’ conditions, where most <i>P</i> is lost to total evapotranspiration (<i>ET</i>) at the expense of <i>R</i> and <i>BF</i>.")),
          tags$li(HTML("Likewise, <i>RBFE</i> values closer to one imply more ‘energy-limited’ conditions, where not all <i>P</i> is lost to <i>ET</i>, causing the production of more <i>R</i> and <i>BF</i>.")),
          br(),
          HTML("<b>Climate Change Impacts:</b>"),
          tags$li(HTML("The Warm/Wet case led to a transition to more energy-limited conditions with increased <i>RBFE</i> across headwater regions.")),
          tags$li(HTML("The Hot/Dry case amplified water-limited conditions and led to large declines in <i>RBFE</i>.")),
          tags$li(HTML("<code>These two climate futures modulated the forest disturbance impacts, explored next.</code>")),
          br(),
          HTML("<b>Forest Disturbance Impacts under Climate Change:</b>"),
          tags$li(actionLink("spatial_analysis_4_update1","Change the impact type to ‘30% Forest disturbance'.")),
          tags$li(HTML("Forest disturbances increased <i>RBFE</i> and by larger amounts under the Warm/Wet case due to the more substantial snow water equivalent (<i>SWE</i>) increases and <i>ET</i> declines, relative to no disturbance.")),
          tags$li(HTML("<code>This indicated that forest disturbance impacts were smaller in the increasingly water-limited Hot/Dry climate (majority of <i>P</i> was lost to <i>ET</i> regardless of vegetation status).</code>")),
          tags$li(HTML("The Upper Basin (composed of the 4 northern subbasins) had the largest forest disturbance impacts due to <i>P</i> trends and the larger area of disturbed forests at high elevations (≥ 1,800 m,"),
                  actionLink("link_from_spatial_to_watersheds3","more info here"),
                  (").")),
          br(),
          HTML("<b>Seasonal differences:</b>"),
          tags$li(actionLink("spatial_analysis_4_update2","Swtich the 'temporal average' to ‘Cool-Season (Oct-Mar)'.")),
          tags$li(HTML("Impacts to <i>RBFE</i> were more moderate and variable across the domain in the Cool-Season and included small <i>RBFE</i> increases in the northeast due to larger <i>ET</i> declines in both Warm/Wet and Hot/Dry cases.")),
          tags$li(HTML("Forest disturbances caused more substantial <i>RBFE</i> increases on average in the"),
                  actionLink("spatial_analysis_4_update3","Warm-Season (Apr-Sep).")),
          tags$li(HTML("This seasonal difference was largely related to"),
                  actionLink("link_from_spatial_to_wat_mon2","the shift in peak snowmelt to later months.")),
          tags$li(HTML("<i>RBFE</i> increases for both seasons were more widespread in the Warm/Wet climate case due to more energy-limited conditions.")),
          tags$li(HTML("<code>Overall, forest disturbance impacts to annual <i>RBFE</i> reflected the warm-season behavior.</code>"))
        )
      })
    }

  })
  
  # Guided analysis - subcomponents
  observeEvent(input$spatial_analysis_update1, {
    updateCollapse(session,"spatial_analyses_panels",open="Guided Analysis")
  })
  observeEvent(input$spatial_analysis_1_update2, {
    updateCollapse(session,"spatial_analyses_panels",open="Freeform Analysis")
  })
  observeEvent(input$spatial_analysis_1_update3, {
    updateRadioButtons(session,"spatial_guided_analyses",selected = "spatial_analysis_2")
  })
  observeEvent(input$spatial_analysis_1_update1, {
    updateVarSelectInput(session,"spatial_var_selected_1",selected = "Snow water equivalent")
    updateVarSelectInput(session,"spatial_var_selected_2",selected = "Snowmelt")
    updateVarSelectInput(session,"spatial_temporal_scale_selected",selected = "Annual (Oct-Sep)")
    updateVarSelectInput(session,"spatial_impact_type_selected",selected = "30% Forest disturbance")
  })
  observeEvent(input$spatial_analysis_2_update1, {
    updateVarSelectInput(session,"spatial_var_selected_1",selected = "Total evapotranspiration")
    updateVarSelectInput(session,"spatial_var_selected_2",selected = "Canopy evaporation")
    updateVarSelectInput(session,"spatial_temporal_scale_selected",selected = "Annual (Oct-Sep)")
    updateVarSelectInput(session,"spatial_impact_type_selected",selected = "30% Forest disturbance")
  })
  observeEvent(input$spatial_analysis_2_update2, {
    updateVarSelectInput(session,"spatial_var_selected_1",selected = "Total evapotranspiration")
    updateVarSelectInput(session,"spatial_var_selected_2",selected = "Soil evaporation")
    updateVarSelectInput(session,"spatial_temporal_scale_selected",selected = "Annual (Oct-Sep)")
    updateVarSelectInput(session,"spatial_impact_type_selected",selected = "30% Forest disturbance")
  })
  observeEvent(input$spatial_analysis_2_update3, {
    updateRadioButtons(session,"spatial_guided_analyses",selected = "spatial_analysis_3")
  })
  observeEvent(input$spatial_analysis_3_update1, {
    updateVarSelectInput(session,"spatial_var_selected_1",selected = "Flow supply (runoff + baseflow)")
    updateVarSelectInput(session,"spatial_var_selected_2",selected = "Soil moisture")
    updateVarSelectInput(session,"spatial_temporal_scale_selected",selected = "Annual (Oct-Sep)")
    updateVarSelectInput(session,"spatial_impact_type_selected",selected = "30% Forest disturbance")
  })
  observeEvent(input$spatial_analysis_3_update2, {
    updateRadioButtons(session,"spatial_guided_analyses",selected = "spatial_analysis_4")
  })
  observeEvent(input$spatial_analysis_4_update1, {
    updateVarSelectInput(session,"spatial_var_selected_1",selected = "Supply efficiency ([runoff + baseflow]/precipitation)")
    updateVarSelectInput(session,"spatial_var_selected_2",selected = "Total evapotranspiration")
    updateVarSelectInput(session,"spatial_temporal_scale_selected",selected = "Annual (Oct-Sep)")
    updateVarSelectInput(session,"spatial_impact_type_selected",selected = "30% Forest disturbance")
  })
  observeEvent(input$spatial_analysis_4_update2, {
    updateVarSelectInput(session,"spatial_var_selected_1",selected = "Supply efficiency ([runoff + baseflow]/precipitation)")
    updateVarSelectInput(session,"spatial_var_selected_2",selected = "Total evapotranspiration")
    updateVarSelectInput(session,"spatial_temporal_scale_selected",selected = "Cool-Season (Oct-Mar)")
    updateVarSelectInput(session,"spatial_impact_type_selected",selected = "30% Forest disturbance")
  })
  observeEvent(input$spatial_analysis_4_update3, {
    updateVarSelectInput(session,"spatial_var_selected_1",selected = "Supply efficiency ([runoff + baseflow]/precipitation)")
    updateVarSelectInput(session,"spatial_var_selected_2",selected = "Total evapotranspiration")
    updateVarSelectInput(session,"spatial_temporal_scale_selected",selected = "Warm-Season (Apr-Sep)")
    updateVarSelectInput(session,"spatial_impact_type_selected",selected = "30% Forest disturbance")
  })
  observeEvent(input$spatial_analysis_conclusions_update1, {
    updateVarSelectInput(session,"spatial_var_selected_1",selected = "Total evapotranspiration")
    updateVarSelectInput(session,"spatial_var_selected_2",selected = "Soil evaporation")
    updateVarSelectInput(session,"spatial_temporal_scale_selected",selected = "Annual (Oct-Sep)")
    updateVarSelectInput(session,"spatial_impact_type_selected",selected = "30% Forest disturbance")
  })

  
  observeEvent(input$spatial_analyses_panels, {
    
    # Overarching research conclusions
    if (input$spatial_analyses_panels=="Overarching Research Conclusions") {
      updateVarSelectInput(session,"spatial_var_selected_1",selected = guided_analyses_spatial$spatial_analysis_conclusions$spatial_var_selected_1)
      updateVarSelectInput(session,"spatial_var_selected_2",selected = guided_analyses_spatial$spatial_analysis_conclusions$spatial_var_selected_2)
      updateVarSelectInput(session,"spatial_temporal_scale_selected",selected = guided_analyses_spatial$spatial_analysis_conclusions$spatial_temporal_scale_selected)
      updateVarSelectInput(session,"spatial_impact_type_selected",selected = guided_analyses_spatial$spatial_analysis_conclusions$spatial_impact_type_selected)
      output$spatial_analysis_conclusions_description<- renderUI({
        tagList(
          tags$li(HTML("Forest reductions augmented snowpacks and generally reduced evapotranspiration across the Colorado River Basin under climate change, leading to"),
                  actionLink("link_from_spatial_to_wat_ann2","increased streamflow relative to the case without disturbance.")),
          tags$li(actionLink("spatial_analysis_conclusions_update1","The impacts to evapotranspiration across the domain"),
                  HTML("included small increases in some mid-elevation regions (due to increased bare soil evaporation that offset transpiration declines; in line with prior observations)<sup>1</sup>"),
                  HTML("but more significant declines over key headwater regions (in line with observations of evapotranspiration delcines following stand-replacing fires).<sup>2</sup>")),
          tags$li(HTML("These variable effects with"),
                  actionLink("link_from_spatial_to_wat_ann3","more muted evapotranspriation decline at basin scale"),
                  HTML("futher highlights that forest disturbance impacts are diluted in large watersheds with spatially-variable landscapes.<sup>3-5</sup>")),
          tags$li(
            actionLink("link_from_spatial_to_wat_mon3","Higher ground snowpack and associated snowmelt increases in late winter to early spring months were the primary cause for streamflow increase"),
            HTML(", which is supported by prior work in the region<sup>6-9</sup> and by observed increases in ground snowpack in open canopy areas following forest disturbances across North America.<sup>10-14</sup>")),
          tags$li(HTML("The increases in water yield scaled with the forest disturbance amounts, confirming similar conclusions of prior efforts.<sup>15</sup>")),
          tags$li(actionLink("link_from_spatial_to_wat_ann5","Higher amounts of forest disturbances were sufficient were sufficient to reverse climate-driven supply efficiency declines and augment streamflow increases in the Warm/Wet case.")),
          tags$li(actionLink("link_from_spatial_to_wat_ann6","However, the effects were not enough to offset the high evapotranspiration of the Hot/Dry future (even at the scale of the 90% forest disturbance, which would require large forest impacts).")),
          tags$li(HTML("The overriding nature of increasingly water-limited conditions in the Hot/Dry climate reflect an imminent hydrologic paradigm shift, specifically the aridification occurring across the American Southwest.<sup>16,17</sup>")),
          tags$li(HTML("Forest disturbances under Hot/Dry conditions were insufficient to cause a full recovery of historical streamflow in the CRB but provide a more limited increase in flows in the face of climate change.")),
          tags$li(HTML("<code>As a result, the climate change uncertainty overwhelms the impact of forest disturbances on future streamflow.</code>")),
          br(),
          helpText(
            HTML("<b>References:</b>"),
            
            tags$ol(
              tags$li(htmlOutput("spatial_analysis_reed_et_al_2016")), # 1. Reed et al., 2016
              tags$li(htmlOutput("spatial_analysis_dore_et_al_2008")),# 2. Dore et al., 2008
              tags$li(htmlOutput("spatial_analysis_zhang_et_al_2017")), # 3. Zhang et al., 2017
              tags$li(htmlOutput("spatial_analysis_li_et_al_2017")),# 4. Li et al., 2017
              tags$li(htmlOutput("spatial_analysis_wang_et_al_2020")),# 5. Wang et al., 2020
              tags$li(htmlOutput("spatial_analysis_buma_and_livneh_2015")), # 6
              tags$li(htmlOutput("spatial_analysis_livneh_et_al_2015a")), # 7
              tags$li(htmlOutput("spatial_analysis_moreno_et_al_2016")), # 8
              tags$li(htmlOutput("spatial_analysis_zou_et_al_2010")), # 9
              tags$li(htmlOutput("spatial_analysis_boon_2007")), # 10
              tags$li(htmlOutput("spatial_analysis_boon_2012")),# 11. boon 2012
              tags$li(htmlOutput("spatial_analysis_broxton_et_al_2014")),# 12. broxton et al 2014
              tags$li(htmlOutput("spatial_analysis_harpold_et_al_2014")),# 13. harpold et al 2014
              tags$li(htmlOutput("spatial_analysis_harpold_et_al_2015")),# 14. harpold et al 2015
              tags$li(htmlOutput("spatial_analysis_williams_et_al_2022")), # 15
              tags$li(htmlOutput("spatial_analysis_overpeck_udall_2020")),# 16. Overpeck and Udall, 2020
              tags$li(htmlOutput("spatial_analysis_seager_et_al_2007"))# 17. Seager et al., 2007

              
              
            )
          )
        )
      })
    } else if (input$spatial_analyses_panels=="Water Management and Policy Implications") {
      
      # Water Management and Policy Implications
      updateVarSelectInput(session,"spatial_var_selected_1",selected = guided_analyses_spatial$spatial_analysis_implications$spatial_var_selected_1)
      updateVarSelectInput(session,"spatial_var_selected_2",selected = guided_analyses_spatial$spatial_analysis_implications$spatial_var_selected_2)
      updateVarSelectInput(session,"spatial_temporal_scale_selected",selected = guided_analyses_spatial$spatial_analysis_implications$spatial_temporal_scale_selected)
      updateVarSelectInput(session,"spatial_impact_type_selected",selected = guided_analyses_spatial$spatial_analysis_implications$spatial_impact_type_selected)
      output$spatial_analysis_implications_description<- renderUI({
        tagList(
          tags$li(HTML("Future streamflows in the Colorado River Basin were more sensitive to the range of uncertainty in climate change than from forest disturbances.")),
          tags$li(HTML("However, the latest National Climate Assessment indicates the Hot/Dry future will could be more likely if current emissions are not curtailed.<sup>1</sup>")),
          tags$li(HTML("While forest management such as prescribed fires and forest thinning (e.g., Zou <i>et al</i>, 2010) could partially offset the impacts of a Hot/Dry future, these would require large-scale, expensive, and sustained treatments that affect other ecosystem services.<sup>3</sup>")),
          tags$li(HTML("It is important to consider the"),
                  actionLink("link_from_spatial_to_forest_disturbances3","model assumptions of this research:"),
                  HTML("the streamflow benefits from permanent forest disturbance are idealized scenarios that do not account for forest recovery and its long-term impact on runoff.<sup>4</sup>")),
          tags$li(HTML("Based on these findings,"),
                  actionLink("link_from_spatial_to_stakeholder_engagement","stakeholders"),
                  HTML("nonetheless indicated that forest management and wildfire impacts should be considered when seeking water security, but that additional studies would be needed to verify the benefits indicated here.")),
          tags$li(HTML("Indeed, future research should consider modeling scenarios with targeted forest disturbances that mimic treatment options, timing, and their recovery through plant succession, as well as accounting for the changes in consumptive water use from LULC in urban and agricultural areas, as performed in Bohn <em>et al.</em> (2018b) and Wang and Vivoni (2022).")),
          br(),
          helpText(
            HTML("<b>References:</b>"),
            tags$ol(
              tags$li(htmlOutput("spatial_analysis_deangelo_et_al_2017")),
              tags$li(htmlOutput("spatial_analysis_zou_et_al_2010_2")),
              tags$li(htmlOutput("spatial_analysis_bennett_et_al_2009")),
              tags$li(htmlOutput("spatial_analysis_goeking_tarboton_2020")),
              tags$li(htmlOutput("spatial_analysis_bohn_et_al_2018b")),
              tags$li(htmlOutput("spatial_analysis_wang_vivoni_2022"))
            )
          )
        )
      })
    }
  })
## ----------------------------------Watershed-Analyses Monthly tab---------------------------------------## ----
  
  # plot description output
  output$wat_mon_plot_description <- renderText({
    plot_specs_wat_monthly_line$plot_description
  })
  # output$wat_mon_basin_description <- renderText({
  #   HTML("<b>",input$wat_mon_basin_selected," monthly average</br>")
  # })
  
  
  # plot description to other panels
  observeEvent(input$wat_mon_plot_description_to_freeform, {
    updateCollapse(session,"watershed_analyses_monthly_panels",open="Freeform Analysis")
  })
  observeEvent(input$wat_mon_plot_description_to_guided, {
    updateCollapse(session,"watershed_analyses_monthly_panels",open="Guided Analysis")
  })
  
  # output$dum_text <- renderText({
  #   paste(basin_dict[[input$wat_mon_basin_selected]]$stored_name," ",input$wat_mon_basin_selected," ",input$wat_mon_var_selected_1," ",input$wat_mon_var_selected_2," ",input$wat_mon_var_selected_3)
  # })
  # 
  # render plot
  output$wat_mon_plot <- renderPlotly({
    # create plot function input list
    wat_mon_basin_selected <- input$wat_mon_basin_selected
    wat_mon_vars_selected <- c(input$wat_mon_var_selected_1,input$wat_mon_var_selected_2,input$wat_mon_var_selected_3)
    plot_input_list <- list(
      "basin_selected" = wat_mon_basin_selected,
      "vars_selected" = wat_mon_vars_selected,
      "input_data" = basin_agg_clim_mmon
    )
    # run plot function
    fig <-plot_mean_mmon_lineplot(plot_input_list)

    
    return(fig)
  })
  
  # Main guided analyses
  observeEvent(input$wat_mon_analyses,{
    guided_analyses_wat_mon_controls = guided_analyses_wat_mon[[input$wat_mon_analyses]]
    updateVarSelectInput(session,"wat_mon_basin_selected",selected = guided_analyses_wat_mon_controls$wat_mon_basin_selected)
    updateVarSelectInput(session,"wat_mon_var_selected_1",selected = guided_analyses_wat_mon_controls$wat_mon_var_selected_1)
    updateVarSelectInput(session,"wat_mon_var_selected_2",selected = guided_analyses_wat_mon_controls$wat_mon_var_selected_2)
    updateVarSelectInput(session,"wat_mon_var_selected_3",selected = guided_analyses_wat_mon_controls$wat_mon_var_selected_3)
    
    # Update the analysis results description
    if (identical(input$wat_mon_analyses, "wat_mon_analysis_1")) {
      
      # Snowpack Impacts
      output$wat_mon_analysis_description<- renderUI({
        tagList(
          HTML("<b>Background:</b>"),
          HTML("First let’s compare the the impacts to mean monthly snowpack conditions across the basin."),
          br(),br(),
          HTML("<b>Climate Change Impacts:</b>"),
          tags$li(HTML("Click on legend items to hide the 10, 30, 60, and 90% disturbance cases (or click the green 'Climate Impact' button).")),
          tags$li(HTML("<code>Climate change reduced snow water equivalent (<i>SWE</i>) in all months, initiated earlier snowmelt (shifted peak <i>M</i> to one month earlier), and decreased sublimation (<i>E<sub>S</sub></i>) in both climate cases.</code>")),
          tags$li(HTML("Despite <i>SWE</i> reductions, <i>M</i> increased during winter (Dec.-Mar.) under the Warm/Wet climate only.")),
          tags$li(HTML("Larger <i>M</i> declines occurred during spring to early summer (Apr.-July) in both climates.")),
          br(),
          HTML("<b>Forest Disturbance Impacts under Climate Change:</b>"),
          tags$li(HTML("Click on legend items (or click the green 'Reset' button) to"),
                  actionLink("wat_mon_analysis_1_update1","turn all cases back on.")),
          tags$li(HTML("Forest disturbances increased <i>SWE</i> relative to the case without disturbance (‘0% Disturbance’), despite slight increases in sublimation (<i>E<sub>S</sub></i>).")),
          tags$li(HTML("This was due to canopy reductions and larger canopy spacing when"), 
                  actionLink("link_from_wat_mon_to_forest_disturbances1","grasses replace forests"),
                  HTML(", indicating a greater role of ground snowpack accumulation than loss of canopy shading.")),
          tags$li(HTML("<i>M</i> also decreaesd during early winter months, and increased during late winter to early spring months.")),
          tags$li(HTML("This difference in <i>M</i> impacts across months was due to higher ground snowpacks that delayed peak snowmelt.")),
          tags$li(HTML("This effect was more pronounced in the Warm/Wet case and led to a recovery of Baseline <i>SWE</i> (Feb.-Apr.) and <i>M</i> (Mar.-May) for the 60% and 90% forest disturbance cases.")),
          hr(),
          tags$li(actionLink("link_from_wat_mon_to_hydro_snow","Click here"), HTML("for more info on the modeled snowpack dynamics."))
        )
      })
      
    } else if (identical(input$wat_mon_analyses, "wat_mon_analysis_2")) {
      # Streamflow Impacts
      output$wat_mon_analysis_description<- renderUI({
        tagList(
          HTML("<b>Background:</b>"),
          HTML("Next let's assess the impacts on the streamflow hydrograph (mean monthly <i>Q</i>)."),
          br(),br(),
          HTML("<b>Climate Change Impacts:</b>"),
          tags$li(HTML("Click on legend items to hide the 10, 30, 60, and 90% disturbance cases (or click the green 'Climate Impact' button).")),
          tags$li(HTML("<code>The impact of climate change uncertainties <i>Q</i> were well represented by the climate bookends.</code>")),
          tags$li(HTML("While the Warm/Wet case increased <i>Q</i> (in Dec. to June), the Hot/Dry case decreased <i>Q</i> (in May to Jan.).")),
          br(),
          HTML("<b>Forest Disturbance Impacts under Climate Change:</b>"),
          tags$li(HTML("Click on legend items  (or click the green 'Reset' button) to"),
                  actionLink("wat_mon_analysis_2_update1","turn all cases back on.")),
          tags$li(HTML("Forest disturbances increased <i>Q</i> relative to the case without disturbance in late spring to early winter (despite slight <i>ET</i> increases in spring), but decreased <i>Q</i> in the early spring.")),
          tags$li(HTML("This difference was due to higher ground snowpacks ("),
                  actionLink("link_from_wat_mon_to_forest_disturbances2","with grasses"),
                  HTML(") and <i>M</i> during spring to early summer months under forest removal (despite"),
                  actionLink("wat_mon_analysis_2_update2",HTML("slight sublimation (<i>E<sub>S</sub></i>) increases")),
                  HTML(").")),
          tags$li(HTML("In the Warm/Wet case, <i>M</i> increase was sufficient to reverse the climate change effects on <i>Q</i> in key months for all forest disturbance cases and significantly increase <i>Q</i> on a"),
                  actionLink("wat_mon_analysis_2_update3","mean annual basis.")),
          tags$li(HTML("<code>Forest disturbances in the Hot/Dry case were sufficient to offset warming in some months, but not on an"), 
                  actionLink("wat_mon_analysis_2_update4","annual basis"),
                  HTML("(due to increasingly water-limited conditions).</code>")),
          tags$li(HTML("Effects were most pronounced in headwater regions ("),
                  actionLink("wat_mon_analysis_2_update5","Green"),
                  HTML(","),
                  actionLink("wat_mon_analysis_2_update6","Upper Colorado"),
                  HTML(", or"),
                  actionLink("wat_mon_analysis_2_update7","San Juan"),
                  HTML(") due to the larger area of disturbed forests at high elevations ("),
                  actionLink("link_from_wat_mon_to_watersheds2","more info here"),
                  HTML("), which is explored in the"),
                  actionLink("link_from_wat_mon_to_spatial_analyses2","Spatial-Analyses.")),
          
          )
      })
      
    } else if (identical(input$wat_mon_analyses, "wat_mon_analysis_conclusions")) {
      # Conclusions
      output$wat_mon_analysis_description<- renderUI({
        tagList(
          HTML("<b>Conclusions:</b>"),
          tags$li(HTML("Snowmelt increases in later winter to early spring months were the primary cause for streamflow increase, which is supported by prior work in the region<sup>1-3</sup> and by observed increases in ground snowpack following forest disturbances across North America.<sup>4-8</sup>")),
          tags$li(HTML("The increases in water yield scaled with the forest disturbance amounts, confirming similar conclusions of prior efforts.<sup>9</sup>")),
          tags$li(HTML("Forest reductions greater than 30%  were sufficient to reverse warming impacts to streamflow in key months in the Warm/Wet case.")),
          tags$li(HTML("Forest disturbances under Hot/Dry conditions inhibited a full recovery of historical streamflow in the basin but provide a more limited reduction in the overall effect of climate change.")),
          tags$li(HTML("As a result, the climate change uncertainty overwhelms the impact of forest disturbances on future streamflow.")),
          br(),
          HTML("<b>Next analysis step:</b>"),
          tags$li(HTML("Follow the guided analysis on the"),
                  actionLink("link_from_wat_mon_to_spatial_analyses3","Spatial-Analyses"),
                  HTML("page to explore how impacts varied across the basin and learn the overall conclusions and water resource management implications of this work.")),
          br(),
          helpText(
            HTML("<b>References:</b>"),
            tags$ol(
              tags$li(htmlOutput("wat_mon_analysis_buma_and_livneh_2015")),
              tags$li(htmlOutput("wat_mon_analysis_livneh_et_al_2015a")),
              tags$li(htmlOutput("wat_mon_analysis_moreno_et_al_2016")),
              tags$li(htmlOutput("wat_mon_analysis_boon_2007")),
              tags$li(htmlOutput("wat_mon_analysis_zou_et_al_2010")),
              tags$li(htmlOutput("wat_mon_analysis_biederman_et_al_2015")),
              tags$li(htmlOutput("wat_mon_analysis_brown_et_al_2014")),
              tags$li(htmlOutput("wat_mon_analysis_harpold_et_al_2014")),
              tags$li(htmlOutput("wat_mon_analysis_williams_et_al_2022"))
            )
          )
        )
      })
    }
    
  })
  
  # Guided analyses - subcomponents
  observeEvent(input$wat_mon_analysis_1_update1, {
    guided_analyses_wat_mon_controls = guided_analyses_wat_mon[[input$wat_mon_analyses]]
    updateVarSelectInput(session,"wat_mon_basin_selected",selected = "Upper Basin")
    updateVarSelectInput(session,"wat_mon_basin_selected",selected = guided_analyses_wat_mon_controls$wat_mon_basin_selected)
    updateVarSelectInput(session,"wat_mon_var_selected_1",selected = guided_analyses_wat_mon_controls$wat_mon_var_selected_1)
    updateVarSelectInput(session,"wat_mon_var_selected_2",selected = guided_analyses_wat_mon_controls$wat_mon_var_selected_2)
    updateVarSelectInput(session,"wat_mon_var_selected_3",selected = guided_analyses_wat_mon_controls$wat_mon_var_selected_3)
  })
  observeEvent(input$wat_mon_analysis_2_update1, {
    guided_analyses_wat_mon_controls = guided_analyses_wat_mon[[input$wat_mon_analyses]]
    updateVarSelectInput(session,"wat_mon_basin_selected",selected = "Upper Basin")
    updateVarSelectInput(session,"wat_mon_basin_selected",selected = guided_analyses_wat_mon_controls$wat_mon_basin_selected)
    updateVarSelectInput(session,"wat_mon_var_selected_1",selected = guided_analyses_wat_mon_controls$wat_mon_var_selected_1)
    updateVarSelectInput(session,"wat_mon_var_selected_2",selected = guided_analyses_wat_mon_controls$wat_mon_var_selected_2)
    updateVarSelectInput(session,"wat_mon_var_selected_3",selected = guided_analyses_wat_mon_controls$wat_mon_var_selected_3)
  })
  observeEvent(input$wat_mon_analysis_2_update2, {
    updateVarSelectInput(session,"wat_mon_var_selected_3",selected = "Sublimation")
  })
  observeEvent(input$wat_mon_analysis_2_update3, {
    navpage_name <- "Annual"
    updateNavbarPage(session, "pages",navpage_name)
    updateRadioButtons(session,"wat_ann_analyses",selected = "wat_ann_analysis_5")
    updateCollapse(session,"watershed_analyses_annual_panels",open="Guided Analysis")
    # updateRadioButtons(session,"wat_ann_plot_type_selected",selected = 2)
    # updateVarSelectInput(session,"wat_ann_basin_selected_1",selected = "San Juan")
    # updateVarSelectInput(session,"wat_ann_var_selected_1",selected = "Streamflow ([cubic km])")
    # updateVarSelectInput(session,"wat_ann_var_selected_2",selected = "Supply efficiency ([runoff + baseflow]/precipitation)")
    
  })
  observeEvent(input$wat_mon_analysis_2_update4, {
    navpage_name <- "Annual"
    updateNavbarPage(session, "pages",navpage_name)
    updateRadioButtons(session,"wat_ann_analyses",selected = "wat_ann_analysis_5")
    updateCollapse(session,"watershed_analyses_annual_panels",open="Guided Analysis")
  })
  observeEvent(input$wat_mon_analysis_2_update5, {
    updateVarSelectInput(session,"wat_mon_basin_selected",selected = "Green")
  })
  observeEvent(input$wat_mon_analysis_2_update6, {
    updateVarSelectInput(session,"wat_mon_basin_selected",selected = "Upper Colorado")
  })
  observeEvent(input$wat_mon_analysis_2_update7, {
    updateVarSelectInput(session,"wat_mon_basin_selected",selected = "San Juan")
  })
## ----------------------------------Scenario Overview tab---------------------------------------## ----
  

## ----------------------------------Precipitation Paritioning tab---------------------------------------## ----
  
  
  # render plot
  output$p_partitioning_fig <- renderPlotly({
    return(plot_p_partitioning_plot())
  })
  } # End of server logic
