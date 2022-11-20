## --------------------------------------------------------------------------------------##
##
## Script name: ui.R
##
## Purpose of the script: The user interface script of the VIC-Explorer website package.
##
## @author: Kristen Whitney
##
## Created on Fri Sept 19 2022
##
## Copyright (c) Arizona State University, 2022
## Email: kmwhitne@asu.edu
##
## --------------------------------------------------------------------------------------##
##    Notes:
##    More information on this to come. 
##
## --------------------------------------------------------------------------------------##
## ----------------------------------Load packages and source scripts---------------------------------------## ----

# Load packages
library(shiny,quietly=TRUE,warn.conflicts = FALSE)
library(shinyWidgets,quietly=TRUE,warn.conflicts = FALSE)
library(thematic,quietly=TRUE,warn.conflicts = FALSE)
library(stringi,quietly=TRUE,warn.conflicts = FALSE)
library(stringr,quietly=TRUE,warn.conflicts = FALSE)
library(shinyBS,quietly=TRUE,warn.conflicts = FALSE)
# library(bslib, quietly = TRUE)
# library(shinythemes,quietly = TRUE)
# library(stringi,quietly=TRUE,warn.conflicts = FALSE)
# library(lubridate,quietly=TRUE,warn.conflicts = FALSE)
# library(dygraphs,quietly=TRUE,warn.conflicts = FALSE)
# library(tidyverse,quietly=TRUE,warn.conflicts = FALSE)
# library(RColorBrewer,quietly=TRUE,warn.conflicts = FALSE)
library(plotly,quietly=TRUE,warn.conflicts = FALSE)
library(leaflet,quietly=TRUE,warn.conflicts = FALSE)
library(manipulateWidget,quietly=TRUE,warn.conflicts = FALSE) # sync leaflet
library(leaflet.minicharts,quietly=TRUE,warn.conflicts = FALSE)
# library(ncdf4,quietly=TRUE,warn.conflicts = FALSE)
# library(stars,quietly=TRUE,warn.conflicts = FALSE)

# Source helper scripts
source("./helpfiles/helper_dictionaries.R")
# assign("model_data_options", model_data_options, envir=globalenv()) # Set as a global variable

## ----------------------------------Init Options---------------------------------------## ----
thematic_shiny(font = "auto")

ui <- fluidPage(
  tags$head(
    
  ),
  navbarPage(
  id = "pages",

## ----------------------------------Navigation bar logos with links---------------------------------------## ----
title = div("VIC-Explorer",
            div(
              tags$a(
                href = "https://hydrology.asu.edu/",
                tags$img(
                  src = 'ASU_logo.png',
                  style = "position:fixed;right: 185px;top: -1px;padding-bottom:19px;",
                  height = 71
                )
              ),
              tags$a(
                href = "https://appliedsciences.nasa.gov/what-we-do/water-resources",
                tags$img(
                  src = 'NASA_logo.png',
                  style = "position:fixed;right: 149px;top: 6px;padding-bottom:5px;",
                  height = 42
                )
              ),
              tags$a(
                href = "https://www.cap-az.com/",
                tags$img(
                  src = 'CAP_logo.png',
                  style = "position:fixed;right: 53px;top: 9px;padding-bottom:3px;",
                  height = 35
                )
              ),
              tags$a(
                href = "https://github.com/kwhitney727/VIC-Explorer",
                tags$img(
                  src = "GitHub_logo.png",
                  style = "position:fixed;right: 10px;top: 7px;padding-bottom:10px;",
                  height = 45
                )
              )
            )
),

windowTitle = "VIC-Explorer",
# position = "fixed-top",
# fluid = TRUE,
# collapsible = TRUE,
# id = 'tabs',

## ----------------------------------Start defining Pages and Tabs------------------------------------------## ----

## -----------------------------------------Landing Page---------------------------------------------## ----
  tabPanel(
    "Home",
    icon = icon("house"),
    
    # Content
    fluidPage(
      HTML("<br>"),
      # banner
      fluidRow(
      div(class = "banner",
          tags$style(HTML("
                                      .banner{
                                      position: relative;
                                      # top:0%;right: 0%;left: 0%;
                                      background-image: url('vic_explorer_banner.png');
                                      # background-repeat: no-repeat;
                                      background-size: cover;
                                      height: 130px;
                                      border-style: none!important;
                                      }"
          )
          )),

      HTML("<br/>"),
      
      # Figure
      column(12, align="center",
             tags$figure(
               align = "center",
               tags$img(
                 src = vic_ex_images$vic_data_pipeline$image_src,
                 width = vic_ex_images$vic_data_pipeline$image_width,
                 alt = vic_ex_images$vic_data_pipeline$image_alt_text,
                 height = vic_ex_images$vic_data_pipeline$image_height
               )
             )
      ),
      
      # Figure description
      column(12, align="center",
             h3("Guided VIC-Explorer analyses evaluate the sensitivity of future Colorado River Basin hydrology to forest disturbances (wildfire, drought, pest-infestations) under climate change, based on a set of VIC simulation scenarios.")
    ),
    column(12,hr()),

    # Button links
    column(3, align ="center",
           actionBttn("watershed_annual_button", "Annual Watershed Analyses", icon = icon("chart-simple"),style = "pill",
                      color = "default")),
    column(3, align ="center",
           actionBttn("watershed_monthly_button", "Monthly Watershed Analyses", icon = icon("chart-line"),style = "pill",
                      color = "default")),
    column(3, align ="center",
           actionBttn("spatial_button", "Spatial Analyses", icon = icon("magnifying-glass-chart"),style = "pill",
                      color = "default")),
    column(3, align ="center",
           actionBttn("more_info_button", "More Model Info", icon = icon("circle-info"),style = "pill",
                      color = "default"))
    
  )
    )
  ),
  


## -----------------------------------------Watershed-Analyses Menu---------------------------------------------## ----
navbarMenu(
  "Watershed-Analyses",

## -----------------------------------------Watershed-Analyses Annual page---------------------------------------------## ----
tabPanel("Annual",
         id = "watershed_analyses_annual",
         fluidRow(
           column(3,
                  wellPanel(
                    # h4("Main Control Panel"),
                    selectInput(
                      "wat_ann_basin_selected_1",
                      label = "Select two basin regions:",
                      choices = basin_full_names,
                      selected = "Basin-wide",
                    ),
                    selectInput(
                      "wat_ann_basin_selected_2",
                      label = NULL,
                      choices = basin_full_names,
                      selected = "Upper Basin"
                    ),
                    selectInput(
                      "wat_ann_var_selected_1",
                      label = "Select two variables:",
                      choices = sort(var_visible_wat_ann),
                      selected = "Snow water equivalent"
                    ),
                    selectInput(
                      "wat_ann_var_selected_2",
                      label = NULL,
                      choices = sort(var_visible_wat_ann),
                      selected = "Streamflow ([cubic km])"
                    ),
                    # br(),
                    radioButtons("wat_ann_plot_type_selected", label = "Select a plot type:",
                                 choices = list("Mean annual values" = 1, "Changes in mean annual values, relative to Baseline (fluxes as percent changes)" = 2, "Changes in mean annual values, relative to Baseline (fluxes as aboslute differences)" = 3), 
                                 selected = 1)
                  )
           ),
           column(9,
                  br(),br(),
                  plotlyOutput("wat_ann_plot")
           ),
         ),
         fluidRow(
           # Information Panels
           bsCollapse(id = "watershed_analyses_annual_panels",
                      open = "Figure Description",
                      bsCollapsePanel("Figure Description",
                                      htmlOutput("wat_ann_plot_description"),
                                      helpText(HTML("Note: Move mouse over plot to highlight individual values. Click legend items to hide/show. Double-click legend items to isolate.")),
                                      style="default"),
                      bsCollapsePanel("Guided Analysis",
                                      fluidRow(
                                        # analysis steps
                                        radioButtons(
                                          "wat_ann_analyses",
                                          label = "Choose an analysis step:",
                                          c(
                                            "1. Climate differences" = "wat_ann_analysis_1",
                                            "2. Snowpack impacts" = "wat_ann_analysis_2",
                                            "3. Evapotranspiration impacts" = "wat_ann_analysis_3",
                                            "4. Streamflow impacts" = "wat_ann_analysis_4",
                                            "5. Supply efficiency impacts" = "wat_ann_analysis_5",
                                            "6. Conclusions" = "wat_ann_analysis_conclusions"
                                          ),
                                          selected = "wat_ann_analysis_conclusions",
                                          inline=TRUE
                                        ),
                                        hr(),
                                        # Result/interpretation description
                                        uiOutput("wat_ann_analysis_description")

                                      ),
                                      style = "info"),
                      bsCollapsePanel("More Info",
                                      tags$li(HTML("More information on each basin region can be found on"), 
                                      actionLink("link_from_wat_ann_to_watersheds1","More Info > Watersheds"),
                                      HTML("page.")),
                                      tags$li(HTML("More information on the modelled scenarios can be found on"), 
                                              actionLink("link_from_wat_ann_to_scenario_overview","More Info > Model + Data > Scenario Overview"),
                                              HTML("page.")),
                                      tags$li(HTML("More information on the model framework can be found on"), 
                                              actionLink("link_from_wat_ann_to_framework_overview1","More Info > Model + Data > Framework Overview"),
                                              HTML("page.")),
                                      tags$li(HTML("Check out the"),
                                              actionLink("link_from_wat_ann_to_wat_month1","Monthly Watershed-Analyses"),
                                              HTML("to learn the impacts to streamflow timing and the underlying snowpack dynamics.")),
                                      tags$li(HTML("Follow the guided analysis on the"),
                                              actionLink("link_from_wat_ann_to_spatial_analyses1","Spatial-Analyses"),
                                              HTML("page to compare how these changes were distributed across the basin and to learn the overall conclusions and water resource management implications of this work.")),
                                      
                                      style="primary"
                      )
                                      
           )
         )
         
               

         

         
),
## -----------------------------------------Watershed-Analyses Monthly page---------------------------------------------## ----
tabPanel("Monthly",
         id = "watershed_analyses_monthly",
         fluidRow(
           column(3,
                  wellPanel(
                    # h4("Main Control Panel"),
                    selectInput(
                      "wat_mon_basin_selected",
                      label = "Select a basin region:",
                      choices = basin_full_names,
                      selected = "Basin-wide",
                    ),
                    selectInput(
                      "wat_mon_var_selected_1",
                      label = "Select three variables:",
                      choices = sort(var_visible_wat_mon),
                      selected = "Streamflow ([cubic km])"
                    ),
                    selectInput(
                      "wat_mon_var_selected_2",
                      label = NULL,
                      choices = sort(var_visible_wat_mon),
                      selected = "Snowmelt"
                    ),
                    selectInput(
                      "wat_mon_var_selected_3",
                      label = NULL,
                      choices = sort(var_visible_wat_mon),
                      selected = "Total evapotranspiration"
                    )
                    # # br(),
                    # radioButtons("wat_ann_plot_type_selected", label = "Select a plot type:",
                    #              choices = list("Mean annual values" = 1, "Changes in mean annual values, relative to Baseline (fluxes as percent changes)" = 2, "Changes in mean annual values, relative to Baseline (fluxes as aboslute differences)" = 3), 
                    #              selected = 1)
                  )
           ),
           column(9,
                  # br(),
                  # textOutput("dum_text"),
                  # br(),
                  plotlyOutput("wat_mon_plot")
           ),
         ),
         fluidRow(
           # Information Panels
           bsCollapse(id = "watershed_analyses_monthly_panels",
                      open = "Figure Description",
                      bsCollapsePanel("Figure Description",
                                      htmlOutput("wat_mon_plot_description"),
                                      helpText(HTML("Notes: <br>-Move mouse over plot to highlight individual values. Click legend items to hide/show. Double-click legend items to isolate.",
                                                    "<br>-Comparison of the \'0% Disturbance\' case to the Baseline",
                                                    "indicates the climate impacts.",
                                                    "<br>-Comparisons of the \'0% Disturbance\' case to any other disturbance case (10-90%)",
                                                    "indicate the forest disturbance impacts.")),
                                      style="default"),
                      bsCollapsePanel("Guided Analysis",
                                      fluidRow(
                                        # analysis steps
                                        radioButtons(
                                          "wat_mon_analyses",
                                          label = "Choose an analysis step:",
                                          c(
                                            "1. Snowpack Impacts" = "wat_mon_analysis_1",
                                            "2. Streamflow impacts" = "wat_mon_analysis_2",
                                            "3. Conclusions" = "wat_mon_analysis_conclusions"
                                            # "4. Implications and Assumptions" = "wat_mon_analysis_implications"
                                          ),
                                          selected = "wat_mon_analysis_conclusions",
                                          inline=TRUE
                                        ),
                                        hr(),
                                        # Result/interpretation description
                                        uiOutput("wat_mon_analysis_description")
                                        
                                      ),
                                      style = "info"),
                      bsCollapsePanel("More Info",
                                      tags$li(HTML("More information on each basin region can be found on"),
                                              actionLink("link_from_wat_mon_to_watersheds1","More Info > Watersheds"),
                                              HTML("page.")),
                                      tags$li(HTML("More information on the modelled scenarios can be found on"),
                                              actionLink("link_from_wat_mon_to_scenario_overview1","More Info > Model + Data > Scenario Overview"),
                                              HTML("page.")),
                                      tags$li(HTML("More information on the model framework can be found on"),
                                              actionLink("link_from_wat_mon_to_framework_overview1","More Info > Model + Data > Framework Overview"),
                                              HTML("page.")),
                                      tags$li(HTML("Check out the"),
                                              actionLink("link_from_wat_mon_to_wat_ann1","Annual Watershed-Analyses"),
                                              HTML(".")),
                                      tags$li(HTML("Follow the guided analysis on the"),
                                              actionLink("link_from_wat_mon_to_spatial_analyses1","Spatial-Analyses"),
                                              HTML("page to compare how changes were distributed across the basin and to learn the overall conclusions and water resource management implications of this work.")),

                                      style="primary"
                      )
                      
           )
         )
         
)

),

## -----------------------------------------Spatial-Analyses Tab---------------------------------------------## ----
tabPanel(
  "Spatial-Analyses",
  
  fluidRow(
    column(3,
           wellPanel(
             selectInput(
               "spatial_var_selected_1",
               label = "Select two variables:",
               choices = sort(var_visible_spatial),
               selected = "Total evapotranspiration"
             ),
             selectInput(
               "spatial_var_selected_2",
               label = NULL,
               choices = sort(var_visible_spatial),
               selected = "Snow water equivalent"
             ),
             selectInput(
               "spatial_temporal_scale_selected",
               label = "Select a temporal average:",
               choices = names(spatial_input_argument_dictionary$temporal_scales),
               selected = "Annual (Oct-Sep)"
             ),
             selectInput(
               "spatial_impact_type_selected",
               label="Select impact type",
               choices = names(spatial_input_argument_dictionary$impact_scenarios),
               selected = "30% forest disturbance"
             ),
             radioButtons(
               "spatial_basemap_on",
               label = "Basemap:",
               choices = list(
                 "on" = TRUE,
                 "off" = FALSE
               ),
               selected = FALSE
             ),
             radioButtons(
               "spatial_sync_maps",
               label = "Sync map zoom:",
               choices = list(
                 "on" = TRUE,
                 "off" = FALSE
               ),
               selected = FALSE
             )
           )
    ),
    column(9,
           # Separate tabs for Warm/Wet and Hot/Dry
           tabsetPanel(
             id = "spatial_scenario_panels",
             tabPanel(
               id = "spatial_scenario_warm_wet",
               title = "Warm/Wet Climate",
               
               # Plot titles (variable names)
               fluidRow(column(6,
                              htmlOutput("spatial_plot_warmwet_var1")
                        ),
                      column(6,
                             htmlOutput("spatial_plot_warmwet_var2")
               )),
               
               # Plots
               combineWidgetsOutput('spatial_scenario_maps_warmwet', width = "100%", height = "600px")
           ),
           tabPanel(
             id = "spatial_scenario_hot_dry",
             title = "Hot/Dry Climate",
             
             # Plot titles (variable names)
             fluidRow(column(6,
                             htmlOutput("spatial_plot_hotdry_var1")
             ),
             column(6,
                    htmlOutput("spatial_plot_hotdry_var2")
             )),
             
             # Plots
             combineWidgetsOutput('spatial_scenario_maps_hotdry', width = "100%", height = "600px")
             )
           )
    ),
  ),
  fluidRow(
    # Information Panels
    bsCollapse(id = "spatial_analyses_panels",
               open = "Figure Description",
               bsCollapsePanel("Figure Description",
                               htmlOutput("spatial_plot_description"),
                               helpText(HTML("Move mouse over plot to highlight average values across each subbasin.")),
                               style="default"),
               bsCollapsePanel("Guided Analysis",
                               fluidRow(
                                 # analysis steps
                                 radioButtons(
                                   "spatial_guided_analyses",
                                   label = "Choose an analysis step:",
                                   c(
                                     "1. Snowpack impacts" = "spatial_analysis_1",
                                     "2. Evapotranspiration impacts" = "spatial_analysis_2",
                                     "3. Flow supply impacts" = "spatial_analysis_3",
                                     "4. Supply efficiency impacts" = "spatial_analysis_4"
                                   ),
                                   selected = character(0),
                                   inline=TRUE
                                 ),
                                 hr(),
                                 # Result/interpretation description
                                 uiOutput("spatial_analysis_description")

                               ),
                               style = "info"),
               bsCollapsePanel("Overarching Research Conclusions",
                               style="warning",
                               uiOutput("spatial_analysis_conclusions_description")
               ),
               bsCollapsePanel("Water Management and Policy Implications",
                               style="danger",
                               uiOutput("spatial_analysis_implications_description")
               ),
               bsCollapsePanel("More Info",
                               tags$li(HTML("More information on each basin region can be found on"),
                                       actionLink("link_from_spatial_to_watersheds1","More Info > Watersheds"),
                                       HTML("page.")),
                               tags$li(HTML("More information on the modelled scenarios can be found on"),
                                       actionLink("link_from_spatial_to_scenario_overview1","More Info > Model + Data > Scenario Overview"),
                                       HTML("page.")),
                               tags$li(HTML("More information on the model framework can be found on"),
                                       actionLink("link_from_spatial_to_framework_overview1","More Info > Model + Data > Framework Overview"),
                                       HTML("page.")),
                               tags$li(HTML("Check out the Watershed-Analyses analyses at the mean"),
                                       actionLink("link_from_spatial_to_wat_ann1","annual"),
                                       HTML("or"),
                                       actionLink("link_from_spatial_to_wat_mon1","monthly"),
                                       HTML("scales.")
                                       ),
                               tags$li(HTML("Follow the"),
                                       actionLink("spatial_analysis_update1","Guided Analysis"),
                                       HTML("to learn the overall conclusions and water resource management implications of this work."),
                                       ),
                               
                               style="primary"
               )
               
    )
  )
  
),

## -----------------------------------------More Info menu---------------------------------------------## ----
navbarMenu(
  "More Info",
## -----------------------------------------Model + Data page---------------------------------------------## ----
tabPanel(
  "Model + Data",
         fluidRow(
           column(
             width = 12, offset = 0,
             # tags$h2("Model + Data"),
             # tags$p(
             #   "", uiOutput("active", container = tags$b)
             # ),
         verticalTabsetPanel(
           id = "model_data_panels",
           contentWidth = 10,
## -----------------------------------------Scenario Overview panel---------------------------------------------## ----
verticalTabPanel(
  title = "Scenario Overview",
  #icon = icon("layer-group"),
  box_height= 0.1,
  
  # Content
  fluidRow(
    # Figure
    tags$figure(
      align = "center",
      tags$img(
        src = vic_ex_images$scenario_overview$image_src,
        width = vic_ex_images$scenario_overview$image_width,
        alt = vic_ex_images$scenario_overview$image_alt_text,
        height = vic_ex_images$scenario_overview$image_height
      )
    ),
    
    # Information Panels
    bsCollapse(id = "scenario_overview_info_panels", 
               open = "Figure Description",
               bsCollapsePanel("Figure Description", 
                               tags$p(
                                 HTML("<b>The model scenarios used:</b>"),
                                 tags$li(actionLink("link_from_scenario_to_climate_projections","Climate Datasets"),
                                         HTML("from downscaled general circulation model (GCM) products and"),
                                         HTML("two emissions scenarios (Representative Concentration Pathways"),
                                         HTML("4.5 and 8.5, or R45 and R85) for the Baseline (left) and Future"),
                                         HTML("(middle) simulations based on Warm/Wet (a,b) or Hot/Dry climates"),
                                         HTML("(c,d).<sup>1-3</sup>")
                                 ),
                                 tags$li(actionLink("link_from_scenario_to_land_cover","Land Cover Maps"),
                                         HTML("from the FORE-SCE land cover products including from historic"),
                                         HTML("year 2005 and Far-Future"),
                                         HTML("year 2099 under the A2 (economic-development, high population"),
                                         HTML("growth) scenario for the Baseline (left) and Future (middle)"),
                                         HTML(" simulations.<sup>4</sup>")
                                 ),
                                 tags$li(actionLink("link_from_scenario_to_forest_disturbances","Forest Disturbances"),
                                         HTML("applied to the (b, d) Far-Future land cover conditions."),
                                 ),
                               ),
                               style = "default"),
               bsCollapsePanel("More Info", 
                               tags$li(HTML("These model scenarios were developed through a series of"),
                                       actionLink("link_from_scenario_to_stakeholder_engagement","Stakeholder Engagement"),
                                       HTML("activities, to ensure applicable"),
                                       HTML("results for water resource decision-making.")
                               ),
                               tags$li(HTML("Click the links in the 'Figure Description' panel (above) or navigate in the "),
                                       HTML("main menu on the left to learn more about each scenario component.")),
                               tags$li(HTML("See the"),
                                       actionLink("link_from_scenario_to_framework_overview","Framework Overview"), 
                                       HTML("page to learn how we implemented these scenarios.")),
                               style = "primary"),
               bsCollapsePanel("References", 
                                  tags$ol(
                                   tags$li(htmlOutput("scenario_pierce_et_al_2014")),
                                   tags$li(htmlOutput("scenario_pierce_et_al_2015")),
                                   tags$li(htmlOutput("scenario_taylor_et_al_2012")), 
                                   tags$li(htmlOutput("scenario_sleeter_et_al_2012"))
                                   ), style = "info")
    )
    
  )
),
## -----------------------------------------Framework Overview panel---------------------------------------------## ----
verticalTabPanel(
  title = "Framework Overview",
  #icon = icon("network-wired"),
  box_height= 0.1,
  
  # Content
  fluidRow(
    # Figure
    tags$figure(
      align = "center",
      tags$img(
        src = vic_ex_images$framework_overview$image_src,
        width = vic_ex_images$framework_overview$image_width,
        alt = vic_ex_images$framework_overview$image_alt_text,
        height = vic_ex_images$framework_overview$image_height
      )
    ),
    
    # Information Panels
    bsCollapse(id = "framework_overview_info_panels", 
               open = "Figure Description",
               bsCollapsePanel("Figure Description", 
                               tags$p(
                                 HTML("<b>Framework Overview:</b>"),
                                 tags$li(HTML("Our model framework was centered on the"), 
                                         actionLink("link_from_framework_to_hydro_model_overview","Variable Infiltration Capacity (VIC) hydrology model"),
                                         HTML("version 5.0 at the 1/16th degree resolution.<sup>1,2</sup>")
                                 ),
                                 tags$li(HTML("We derived"),
                                         actionLink("link_from_framework_to_climate_projections","climate projections"),
                                         HTML("(daily precipitation and air"),
                                         HTML("temperature) from statistically-downscaled general"),
                                         HTML("circulation model (GCM) products for the period of 1950-2099.<sup>3-5</sup>")),
                                 tags$li(HTML("We estimated unobserved climate forcings and diurnal"),
                                         HTML("cycles of meteorological variables using"), 
                                         actionLink("link_from_framework_to_met_model","MetSim"),
                                         HTML("with storm parameters based on"),
                                         HTML("meteorological station observations.<sup>6-9</sup>")),
                                 tags$li(HTML("We used historic and future projected"),
                                         actionLink("link_from_framework_to_land_cover","land cover maps"),
                                         HTML("from FORE-SCE products to update VIC land cover parameters,"),
                                         HTML("which include climatological monthly land cover parameters.<sup>10,11</sup>")),
                                 tags$li(HTML("We applied scenarios of"),
                                         actionLink("link_from_framework_to_forest_disturbances","forest disturabnces"),
                                         HTML("to the future projected land cover parameters using a bottom-up approach.")),
                                 tags$li(HTML("Other"),
                                         actionLink("link_from_framework_to_model_parameters","model parameters"),
                                         HTML("included calibrated soil and baseflow parameters based on Xiao <em>et al.</em> (2018,2022), Livneh <em>et al.</em> (2015), and Nijssen <em>et al.</em> (2001).")),
                                 tags$li(HTML("VIC simulated runoff and baseflow were subsequently routed"),
                                         HTML("as streamflow using"),
                                         actionLink("link_from_framework_to_flow_rout","R-VIC"),
                                         HTML(".<sup>16,17</sup>")),
                                 tags$li(HTML("We utilized streamflow routing parameters that were"),
                                         HTML("calibrated to"),
                                         actionLink("link_from_framework_to_watersheds","major watershed outlets"),
                                         HTML(".<sup>18,19</sup>")),
                                 tags$li(HTML("We used elevation datasets"),
                                         HTML("<sup>20</sup> to update the internal elevations"),
                                         HTML("and"),
                                         actionLink("link_from_framework_to_hydro_model_snow","elevation bands for computing lapse rates"),
                                         HTML("in VIC,<sup>21</sup> and to the discretize the"),
                                         HTML("R-VIC channel network"))
                               ),
                               style = "default"),
               bsCollapsePanel("More Info", 
                               tags$li(HTML("We designed and implemented a"),
                                       actionLink("link_from_framework_to_stakeholder_engagement","Stakeholder Engagement"),
                                       HTML("process to validate this Framework Overview,"),
                                       HTML("and to guide the design of our"),
                                       actionLink("link_from_framework_to_scenario_overview","modeled scenarios"),
                                       HTML(".")
                               ),
                               tags$li(HTML("Click the links in the 'Figure Description' panel (above) or navigate in the"),
                                       HTML("main menu on the left to learn more about each framework component.")),
                               style = "primary"),
               # bsCollapsePanel("Assumptions", 
               #                 # insert assumptions
               #                 style = "warning"),
               bsCollapsePanel("References",
                                 tags$ol(
                                   tags$li(htmlOutput("framework_liang_et_al_1994")),
                                   tags$li(htmlOutput("framework_hamman_et_al_2018")),
                                   tags$li(htmlOutput("framework_pierce_et_al_2014")), 
                                   tags$li(htmlOutput("framework_pierce_et_al_2015")),
                                   tags$li(htmlOutput("framework_taylor_et_al_2012")),
                                   tags$li(htmlOutput("framework_bennett_et_al_2020")),
                                   tags$li(htmlOutput("framework_bohn_et_al_2013")),
                                   tags$li(htmlOutput("framework_bohn_et_al_2019")),
                                   tags$li(htmlOutput("framework_bohn_et_al_2018")),
                                   tags$li(htmlOutput("framework_sleeter_et_al_2012")),
                                   tags$li(htmlOutput("framework_bohn_vivoni_2019")),
                                   tags$li(htmlOutput("framework_xiao_et_al_2018")),
                                   tags$li(htmlOutput("framework_xiao_et_al_2022")),
                                   tags$li(htmlOutput("framework_livneh_et_al_2015a")), 
                                   tags$li(htmlOutput("framework_nijssen_et_al_2001")),
                                   tags$li(htmlOutput("framework_lohmann_et_al_1996")),
                                   tags$li(htmlOutput("framework_lohmann_et_al_1998")),
                                   tags$li(htmlOutput("framework_bennett_et_al_2018a")),
                                   tags$li(htmlOutput("framework_bennett_et_al_2018b")),
                                   tags$li(htmlOutput("framework_usgs_et_al_2016a")),
                                   tags$li(htmlOutput("framework_andreadis_et_al_2009"))
                                 ),
                               style = "info")
    )
  )
),
## -----------------------------------------Meteorology Model panel---------------------------------------------## ----
verticalTabPanel(
  title = "Meteorology Model",
  #icon = icon("cloud-sun-rain"),
  box_height= 0.1,
  
  # Content
  fluidRow(
    # Figure
    tags$figure(
      align = "center",
      tags$img(
        src = vic_ex_images$met_model$image_src,
        width = vic_ex_images$met_model$image_width,
        alt = vic_ex_images$met_model$image_alt_text,
        height = vic_ex_images$met_model$image_height
      )
    ),
    
    # Information Panels
    bsCollapse(id = "met_model_info_panels", 
               open = "Figure Description",
               bsCollapsePanel("Figure Description", 
                               tags$p(
                                 HTML("<b>The meteorology model</b> ..."),
                                 ""
                               ),
                               style = "default"),
               bsCollapsePanel("More Info", 
                               tags$li("more info 1"),
                               tags$li("more info 2"),
                               style = "primary"),
               bsCollapsePanel("Assumptions", 
                               # insert assumptions
                               style = "warning"),
               bsCollapsePanel("References",
                               tags$ol(
                                 tags$li()
                                 ),
                               style = "info")
    )
  )
  
),
## -----------------------------------------Hydrology Model panel---------------------------------------------## ----
verticalTabPanel(
  title = "Hydrology Model",
  
  #icon = icon("arrows-spin"),
  box_height= 0.1,
  
  # Content
  fluidRow(
  tabsetPanel(
    id = "model_data_hydro_model",
    tabPanel(
      id = "hydro_model_overview",
      title = "Overview",
      
      # Content
      fluidRow(
        
        # Figure
        tags$figure(
          align = "center",
          tags$img(
            src = vic_ex_images$hydro_model$image_src,
            width = vic_ex_images$hydro_model$image_width,
            alt = vic_ex_images$hydro_model$image_alt_text,
            height = vic_ex_images$hydro_model$image_height
          )
        ),
        
        # Information Panels
        bsCollapse(id = "hydro_model_overview_info_panels", 
                   open = "Figure Description",
                   bsCollapsePanel("Figure Description", 
                                   tags$p(
                                     HTML("<b>The Variable Infiltration Capacity (VIC) hydrology model</b> is a regional model",
                                          "that solves the full water and energy balance on a regular grid.<sup>1</sup>"),
                                     tags$li(HTML("(a) Each cell is divided into land cover tiles atop a three-layer soil column. The number of tiles in a cell (n) depends on the land cover fraction (<em>C<sub>v</sub></em>).")),
                                     tags$li(HTML("(b,c) Tiles are modeled independently for"), 
                                             actionLink("link_from_hydro_overview_to_hydro_model_snow","snowpack"), 
                                             HTML(","), actionLink("link_from_hydro_overview_to_hydro_model_evap","evapotranspiration"), 
                                             HTML(","), 
                                             actionLink("link_from_hydro_overview_to_hydro_model_infil_runoff","soil moisture infiltration, runoff"), 
                                             HTML(", and"),  actionLink("link_from_hydro_overview_to_hydro_model_baseflow","baseflow"), 
                                             HTML("components.<sup>1-4</sup>.")),
                                     tags$li(HTML("(d) Fluxes and storages from tiles are averaged together (weighted by <em>C<sub>v</sub></em>) to yield the grid-cell average result."))
                                   ),
                                   style = "default"),
                   bsCollapsePanel("More Info", 
                                   tags$li(HTML("Inputs are timeseries of hourly meteorology (total precipitation, air temperature, wind speed, radiation, humidity), which are estimated using a separate model ("),actionLink("link_from_hydro_overview_to_met_model","MetSim"),HTML(").")),
                                   tags$li(HTML("VIC esimates the"), actionLink("link_from_hydro_overview_to_hydro_model_prec","partitioning of precipitation"), HTML("in to rain and snowfall using a temperature-based scheme.")),
                                   tags$li(HTML("All tiles within a cell receive the same rain and snowfall amounts.")),
                                   style = "primary"),
                   bsCollapsePanel("Assumptions", 
                                   tags$li(HTML("Grid cells do not interact with each other (no sub-surface moisture transfer or recharge from soil to rivers), except in river routing (handled separately by,"),actionLink("link_from_hydro_overview_to_flow_rout","R-VIC"),HTML(").")),
                                   tags$li(HTML("This requires assumptions (e.g., vertical fluxes are much larger than horizontal).")),
                                   tags$li(HTML("This assumption is generally statisfied by the large grid cell size (1/16<sup>th o</sup> in our case, 1/8<sup>th o</sup> in most prior cases<sup>5-7</sup>).")),
                                   br(),
                                   tags$li(HTML("The VIC application does not represent the consumptive water uses from projected urban and agricultural growth in our"),
                                                actionLink("link_from_hydro_overview_to_land_cover","land use land cover (LULC) scenarios"), 
                                                HTML("and their resulting impacts on the water balance.")),
                                   tags$li(HTML("While such LULC analyses are feasible (e.g., Bohn et al., 2018b; Wang and Vivoni, 2022),"),
                                                actionLink("link_from_hydro_overview_to_stakeholder_engagement", "stakeholder interest"),
                                                HTML("was focused primarily on forest disturbances.")),
                                   tags$li(HTML("Furthermore, the growth of these land cover types and associated consumptive water use might not be realistic given available water supplies.")),
                                   
                                   style = "warning"),
                   bsCollapsePanel("References + Source Code",
                                   h5(HTML("<b>VIC code:</b>"),
                                      htmlOutput("hydro_overview_vic_code")),
                                   h5(HTML("<b>References:</b>")),
                                   tags$ol(
                                     tags$li(htmlOutput("hydro_overview_liang_el_al_1994")),
                                     tags$li(htmlOutput("hydro_overview_andreadis_et_al_2009")), 
                                     tags$li(htmlOutput("hydro_overview_cherkauer_lettenmaier_2003")),
                                     tags$li(htmlOutput("hydro_overview_bohn_vivoni_2016")),
                                     tags$li(htmlOutput("hydro_overview_christensen_lettenmaier_2007")),
                                     tags$li(htmlOutput("hydro_overview_bureau_2012")),
                                     tags$li(htmlOutput("hydro_overview_vano_lettenmaier_2012")),
                                     tags$li(htmlOutput("hydro_overview_hamman_el_al_2018")),
                                     tags$li(htmlOutput("hydro_overview_bohn_el_al_2018b")),
                                     tags$li(htmlOutput("hydro_overview_wang_vivoni_2022")),
                                   ),
                                   style = "info")
        )
        
      )
      ),
    tabPanel(
      id = "hydro_model_prec",
      title = "Precipitation Partitioning",
      
      # Content
      fluidRow(
        # Figure
        tags$figure(
          align = "center",
          tags$img(
            src = vic_ex_images$hydro_model_prec$image_src,
            width = vic_ex_images$hydro_model_prec$image_width,
            alt = vic_ex_images$hydro_model_prec$image_alt_text,
            height = vic_ex_images$hydro_model_prec$image_height
          )
        ),
        
        # Information Panels
        bsCollapse(id = "hydro_model_prec_info_panels", 
                   open = "Figure Description",
                   bsCollapsePanel("Figure Description", 
                                   tags$p(
                                     HTML("Figure description",
                                          "")
                                   ),
                                   style = "default"),
                   bsCollapsePanel("More Info", 
                                   tags$li("more info 1"),
                                   tags$li("more info 2"),
                                   style = "primary"),
                   bsCollapsePanel("Assumptions", 
                                   tags$li(HTML("assumption 1")),
                                   style = "warning"),
                   bsCollapsePanel("References", h5(HTML("<b>References:</b>")),
                                   # insert references
                                   style = "info")
        )
      )
      
    ),
    tabPanel(
      id = "hydro_model_snow",
      title = "Snowpack",
      
      # Content
      fluidRow(
        # Figure
        tags$figure(
          align = "center",
          tags$img(
            src = vic_ex_images$hydro_model_snow$image_src,
            width = vic_ex_images$hydro_model_snow$image_width,
            alt = vic_ex_images$hydro_model_snow$image_alt_text,
            height = vic_ex_images$hydro_model_snow$image_height
          )
        ),
        
        # Information Panels
        bsCollapse(id = "hydro_model_snow_info_panels", 
                   open = "Figure Description",
                   bsCollapsePanel("Figure Description", 
                                   tags$p(
                                     HTML("Figure description",
                                          "")
                                   ),
                                   style = "default"),
                   bsCollapsePanel("More Info", 
                                   tags$li("more info 1"),
                                   tags$li("more info 2"),
                                   style = "primary"),
                   bsCollapsePanel("Assumptions", 
                                   tags$li(HTML("assumption 1")),
                                   style = "warning"),
                   bsCollapsePanel("References", h5(HTML("<b>References:</b>")),
                                   # insert references
                                   style = "info")
        )
        
      )
      
    ),
    tabPanel(
      id = "hydro_model_evap",
      title = "Evapotranspiration",
      
      # Content
      fluidRow(
        # Figure
        tags$figure(
          align = "center",
          tags$img(
            src = vic_ex_images$hydro_model_evap$image_src,
            width = vic_ex_images$hydro_model_evap$image_width,
            alt = vic_ex_images$hydro_model_evap$image_alt_text,
            height = vic_ex_images$hydro_model_evap$image_height
          )
        ),
        
        # Information Panels
        bsCollapse(id = "hydro_model_evap_info_panels", 
                   open = "Figure Description",
                   bsCollapsePanel("Figure Description", 
                                   tags$p(
                                     HTML("Figure description",
                                          "")
                                   ),
                                   style = "default"),
                   bsCollapsePanel("More Info", 
                                   tags$li("more info 1"),
                                   tags$li("more info 2"),
                                   style = "primary"),
                   bsCollapsePanel("Assumptions", 
                                   tags$li(HTML("assumption 1")),
                                   style = "warning"),
                   bsCollapsePanel("References", h5(HTML("<b>References:</b>")),
                                   # insert references
                                   style = "info")
        )
        
      )
    ),
    tabPanel(
      id = "hydro_model_infil_runoff",
      title = "Soil Infiltration/Runoff",
      
      # Content
      fluidRow(
        # Figure
        tags$figure(
          align = "center",
          tags$img(
            src = vic_ex_images$hydro_model_infil_runoff$image_src,
            width = vic_ex_images$hydro_model_infil_runoff$image_width,
            alt = vic_ex_images$hydro_model_infil_runoff$image_alt_text,
            height = vic_ex_images$hydro_model_infil_runoff$image_height
          )
        ),
        
        # Information Panels
        bsCollapse(id = "hydro_model_infil_runoff_info_panels", 
                   open = "Figure Description",
                   bsCollapsePanel("Figure Description", 
                                   tags$p(
                                     HTML("Figure description",
                                          "")
                                   ),
                                   style = "default"),
                   bsCollapsePanel("More Info", 
                                   tags$li("more info 1"),
                                   tags$li("more info 2"),
                                   style = "primary"),
                   bsCollapsePanel("Assumptions", 
                                   tags$li(HTML("assumption 1")),
                                   style = "warning"),
                   bsCollapsePanel("References", h5(HTML("<b>References:</b>")),
                                   # insert references
                                   style = "info")
        )
        
      )
    ),
    tabPanel(
      id = "hydro_model_baseflow",
      title = "Baseflow",
      
      # Content
      fluidRow(
        # Figure
        tags$figure(
          align = "center",
          tags$img(
            src = vic_ex_images$hydro_model_baseflow$image_src,
            width = vic_ex_images$hydro_model_baseflow$image_width,
            alt = vic_ex_images$hydro_model_baseflow$image_alt_text,
            height = vic_ex_images$hydro_model_baseflow$image_height
          )
        ),
        
        # Information Panels
        bsCollapse(id = "hydro_model_baseflow_info_panels", 
                   open = "Figure Description",
                   bsCollapsePanel("Figure Description", 
                                   tags$p(
                                     HTML("Figure description",
                                          "")
                                   ),
                                   style = "default"),
                   bsCollapsePanel("More Info", 
                                   tags$li("more info 1"),
                                   tags$li("more info 2"),
                                   style = "primary"),
                   bsCollapsePanel("Assumptions", 
                                   tags$li(HTML("assumption 1")),
                                   style = "warning"),
                   bsCollapsePanel("References", h5(HTML("<b>References:</b>")),
                                   # insert references
                                   style = "info")
        )
        
      )
    )
  ),
  )
  ),

## -----------------------------------------Streamflow Routing panel---------------------------------------------## ----
verticalTabPanel(
  title = "Streamflow Routing",
  #icon = icon("droplet"),
  box_height= 0.1,
  
  # Content
  fluidRow(
    # Figure
    tags$figure(
      align = "center",
      tags$img(
        src = vic_ex_images$flow_rout$image_src,
        width = vic_ex_images$flow_rout$image_width,
        alt = vic_ex_images$flow_rout$image_alt_text,
        height = vic_ex_images$flow_rout$image_height
      )
    ),
    
    # Information Panels
    bsCollapse(id = "flow_rout_info_panels", 
               open = "Figure Description",
               bsCollapsePanel("Figure Description", 
                               tags$p(
                                 HTML("<b>Streamflow routing description</b> ..."),
                                 ""
                               ),
                               style = "default"),
               bsCollapsePanel("More Info", 
                               tags$li("more info 1"),
                               tags$li("more info 2"),
                               style = "primary"),
               bsCollapsePanel("Assumptions", 
                               # insert assumptions
                               style = "warning"),
               bsCollapsePanel("References",
                               tags$ol(
                                 tags$li()
                               ),
                               style = "info")
    )
  )
  ),
## -----------------------------------------Climate Projections panel---------------------------------------------## ----
verticalTabPanel(
  title = "Climate Projections",
  #icon = icon("temperature-arrow-up"),
  box_height= 0.1,
  
  # Content
  tabsetPanel(
    tabPanel(
      id= "clim_proj_plot",
      title = "Plot",
      fluidRow(
        
      # Figure
      tags$figure(
        align = "center",
        tags$img(
          src = vic_ex_images$climate_projections$image_src,
          width = vic_ex_images$climate_projections$image_width,
          alt = vic_ex_images$climate_projections$image_alt_text,
          height = vic_ex_images$climate_projections$image_height
        )
      ),
      
      # Information Panels
      bsCollapse(id = "climate_projections_info_panels", 
                 open = "Figure Description",
                 bsCollapsePanel("Figure Description", 
                                 tags$p(
                                   HTML("<b>Climate projections description</b> ..."),
                                   ""
                                 ),
                                 style = "default"),
                 bsCollapsePanel("More Info", 
                                 tags$li("more info 1"),
                                 tags$li("more info 2"),
                                 style = "primary"),
                 bsCollapsePanel("Assumptions", 
                                 # insert assumptions
                                 style = "warning"),
                 bsCollapsePanel("References",
                                 tags$ol(
                                   tags$li()
                                 ),
                                 style = "info")
      )
      )
      ),
    tabPanel(
      id= "clim_proj_table",
      title = "Table",
      tags$figure(
        align = "center",
        tags$img(
          src = vic_ex_images$climate_projections$image_src,
          width = vic_ex_images$climate_projections$image_width,
          alt = vic_ex_images$climate_projections$image_alt_text,
          height = vic_ex_images$climate_projections$image_height
        )
      )
      )
  )
),
## -----------------------------------------Land Cover panel---------------------------------------------## ----
verticalTabPanel(
  title = "Land Cover Maps",
  #icon = icon("tree-city"),
  box_height= 0.1,
  
  # Content
  fluidRow(
    # Figure
    tags$figure(
      align = "center",
      tags$img(
        src = vic_ex_images$land_cover$image_src,
        width = vic_ex_images$land_cover$image_width,
        alt = vic_ex_images$land_cover$image_alt_text,
        height = vic_ex_images$land_cover$image_height
      )
    ),
    
    # Information Panels
    bsCollapse(id = "land_cover_info_panels", 
               open = "Figure Description",
               bsCollapsePanel("Figure Description", 
                               tags$p(
                                 HTML("<b>Land cover maps description</b> ..."),
                                 ""
                               ),
                               style = "default"),
               bsCollapsePanel("More Info", 
                               tags$li("more info 1"),
                               tags$li("more info 2"),
                               style = "primary"),
               bsCollapsePanel("Assumptions", 
                               # insert assumptions
                               style = "warning"),
               bsCollapsePanel("References",
                               tags$ol(
                                 tags$li()
                               ),
                               style = "info")
    )
  )
),
## -----------------------------------------Forest Disturbances panel---------------------------------------------## ----
verticalTabPanel(
  title = "Forest Disturbances",
  #icon = icon("tree"),
  box_height= 0.1,
  
  # Content
  fluidRow(
    # Figure
    tags$figure(
      align = "center",
      tags$img(
        src = vic_ex_images$forest_disturbances$image_src,
        width = vic_ex_images$forest_disturbances$image_width,
        alt = vic_ex_images$forest_disturbances$image_alt_text,
        height = vic_ex_images$forest_disturbances$image_height
      )
    ),
    
    # Information Panels
    bsCollapse(id = "forest_disturbances_info_panels", 
               open = "Figure Description",
               bsCollapsePanel("Figure Description", 
                               tags$p(
                                 HTML("<b>Streamflow routing description</b> ..."),
                                 ""
                               ),
                               style = "default"),
               bsCollapsePanel("More Info", 
                               tags$li("more info 1"),
                               tags$li("more info 2"),
                               style = "primary"),
               bsCollapsePanel("Assumptions", 
                               # insert assumptions
                               style = "warning"),
               bsCollapsePanel("References",
                               tags$ol(
                                 tags$li()
                               ),
                               style = "info")
    )
  )
),
## -----------------------------------------Model Parameters panel---------------------------------------------## ----
verticalTabPanel(
  title = "Model Parameters",
  #icon = icon("map"),
  box_height= 0.1,
  
  # Content
  fluidRow(
    # Figure
    tags$figure(
      align = "center",
      tags$img(
        src = vic_ex_images$model_parameters$image_src,
        width = vic_ex_images$model_parameters$image_width,
        alt = vic_ex_images$model_parameters$image_alt_text,
        height = vic_ex_images$model_parameters$image_height
      )
    ),
    
    # Information Panels
    bsCollapse(id = "model_parameters__info_panels", 
               open = "Figure Description",
               bsCollapsePanel("Figure Description", 
                               tags$p(
                                 HTML("<b>Model parameters description</b> ..."),
                                 ""
                               ),
                               style = "default"),
               bsCollapsePanel("More Info", 
                               tags$li("more info 1"),
                               tags$li("more info 2"),
                               style = "primary"),
               bsCollapsePanel("Assumptions", 
                               # insert assumptions
                               style = "warning"),
               bsCollapsePanel("References",
                               tags$ol(
                                 tags$li()
                               ),
                               style = "info")
    )
  )
),
## -----------------------------------------Stakeholder Engagement panel---------------------------------------------## ----
verticalTabPanel(
  title = "Stakeholder Engagement",
  #icon = icon("people-group"),
  box_height= 0.1,

  # Content
  fluidRow(
    # Figure
    tags$figure(
      align = "center",
      tags$img(
        src = vic_ex_images$stakeholders$image_src,
        width = vic_ex_images$stakeholders$image_width,
        alt = vic_ex_images$stakeholders$image_alt_text,
        height = vic_ex_images$stakeholders$image_height
      )
    ),
    
    # Information Panels
    bsCollapse(id = "stakeholder_engagement_info_panels", 
               open = "Figure Description",
               bsCollapsePanel("Figure Description", 
                               tags$p(
                                 HTML("<b>Stakeholder engagement description</b> ..."),
                                 ""
                               ),
                               style = "default"),
               bsCollapsePanel("More Info", 
                               tags$li("more info 1"),
                               tags$li("more info 2"),
                               style = "primary"),
               bsCollapsePanel("Assumptions", 
                               # insert assumptions
                               style = "warning"),
               bsCollapsePanel("References",
                               tags$ol(
                                 tags$li()
                               ),
                               style = "info")
    )
  )
) # add another comma here if adding an additional panel (structure commented below)
## -----------------------------------------End of Model + Data page---------------------------------------------## ----

) # End of verticalTabsetPanel
) # end of column
) # end of fluidPage
), # end of Model + Data page tabPanel
## -----------------------------------------Watersheds page---------------------------------------------## ----
tabPanel("Watersheds",
         # Content
         fluidRow(
           # Figure
           tags$figure(
             align = "center",
             tags$img(
               src = vic_ex_images$under_construction$image_src,
               width = vic_ex_images$under_construction$image_width,
               alt = vic_ex_images$under_construction$image_alt_text,
               height = vic_ex_images$under_construction$image_height
             )
           ),
           
           # Information Panels
           bsCollapse(id = "watersheds_info_panels", 
                      open = "Figure Description",
                      bsCollapsePanel("Figure Description", 
                                      tags$p(
                                        HTML("<b>Watersheds description</b> ..."),
                                        ""
                                      ),
                                      style = "default"),
                      bsCollapsePanel("More Info", 
                                      tags$li("more info 1"),
                                      tags$li("more info 2"),
                                      style = "primary"),
                      bsCollapsePanel("Assumptions", 
                                      # insert assumptions
                                      style = "warning"),
                      bsCollapsePanel("References",
                                      tags$ol(
                                        tags$li()
                                      ),
                                      style = "info")
           )
         )
), # end of Watersheds tabPanel
## -----------------------------------------About Us page---------------------------------------------## ----
tabPanel("About Us",
         # Content
         fluidRow(
           # Figure
           tags$figure(
             align = "center",
             tags$img(
               src = vic_ex_images$under_construction$image_src,
               width = vic_ex_images$under_construction$image_width,
               alt = vic_ex_images$under_construction$image_alt_text,
               height = vic_ex_images$under_construction$image_height
             )
           ),
           
           # Information Panels
           bsCollapse(id = "about_us_info_panels", 
                      open = "Our Team",
                      bsCollapsePanel("Our Team", 
                                      tags$p(
                                        HTML("<b>Our team description</b> ..."),
                                        ""
                                      ),
                                      style = "default"),
                      bsCollapsePanel("More Info", 
                                      tags$li("more info 1"),
                                      tags$li("more info 2"),
                                      style = "primary")
           )
         )
         
),
) # End of navbarMenu ----
)
)
