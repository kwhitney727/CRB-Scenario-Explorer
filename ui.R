## --------------------------------------------------------------------------------------##
##
## Script name: ui.R
##
## Purpose of the script: The user interface script of CRB-Scenario-Explorer.
##
## @author: Dr. Kristen Whitney
##
## Created on Fri Sept 19 2022
##
##
## --------------------------------------------------------------------------------------##
##    Notes:
##    
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
library(plotly,quietly=TRUE,warn.conflicts = FALSE)
library(leaflet,quietly=TRUE,warn.conflicts = FALSE)
library(manipulateWidget,quietly=TRUE,warn.conflicts = FALSE) # sync leaflet
library(leaflet.minicharts,quietly=TRUE,warn.conflicts = FALSE)

# Source helper scripts
source("./helpfiles/helper_dictionaries.R")

## ----------------------------------Init Options---------------------------------------## ----
thematic_shiny(font = "auto")

ui <- fluidPage(
  tags$head(
    
  ),
  navbarPage(
  id = "pages",

## ----------------------------------Navigation bar logos with links---------------------------------------## ----
title = div("CRB-Scenario-Explorer",
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
                href = "https://github.com/kwhitney727/CRB-Scenario-Explorer",
                tags$img(
                  src = "GitHub_logo.png",
                  style = "position:fixed;right: 10px;top: 7px;padding-bottom:10px;",
                  height = 45
                )
              )
            )
),

windowTitle = "CRB-Scenario-Explorer",

## ----------------------------------Start defining Pages and Tabs------------------------------------------## ----

## -----------------------------------------Landing Page---------------------------------------------## ----
  tabPanel(
    "Home",
    icon = icon("house"),
    
    # Content
    fluidPage(
      HTML("<br>"),
      # banner
      div(class = "banner",
          tags$style(HTML("
                                      .banner{
                                      position: relative;
                                      # top:0%;right: 0%;left: 0%;
                                      background-image: url('webtool_banner.png');
                                      # background-repeat: no-repeat;
                                      background-size: cover;
                                      height: 160px;
                                      border-style: none!important;
                                      }"
          )
          )),

      HTML("<br/>"),
      fluidRow(
      # Figure
      br(),br(),
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
             h3("Guided analyses evaluate the sensitivity of future Colorado River Basin (CBR) hydrology to forest disturbances (wildfire, drought, pest-infestations) under climate change, based on a set of simulation scenarios from the Variable Infiltration Capacity model."),
      ),
      
      # Introduction to the CRB-Scenario-Explorer design and underlying research methods.
      column(12,hr()),
      column(12, align="center",
             h4(tags$p(HTML("CRB-Scenario-Explorer and the underlying research was designed by and for hydroclimate scientists and water resource decision-makers. Research method details can be found in the"),
                actionLink("link_from_landing_to_more_info","'More Info'"),
                HTML("pages and in <a href=\"https://ascelibrary.org/doi/full/10.1061/JWRMD5.WRENG-5905\">Whitney <i>et al</i>. (2023)</a>. A forethcoming publication will detail the methods for developing the CRB-Scenario-Explorer tool.")))
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
           plotlyOutput("wat_ann_plot"),
           br(),
           # Information Panels
           bsCollapse(id = "watershed_analyses_annual_panels",
                      open = "Figure Description",
                      bsCollapsePanel("Figure Description",
                                      htmlOutput("wat_ann_plot_description"),
                                      hr(),
                                      helpText(HTML("Notes:<br>- Move mouse over plot to highlight individual values. Click legend items to hide/show. Double-click legend items to isolate."),
                                               HTML("<br>- All plot settings can be manually adjusted in the"),
                                               actionLink("wat_ann_plot_description_to_freeform","'Freeform Analysis' panel"),
                                               HTML("below (e.g., selecting options to to visualize Upper Basin streamflow in million-acre feet [MAF])."),
                                               HTML("<br>- Follow the steps in the"),
                                               actionLink("wat_ann_plot_description_to_guided","'Guided Analysis' panel"),
                                               HTML("below to learn the findings at the mean annual watershed scale.")
                                               ),
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
                                          # selected = "wat_ann_analysis_conclusions",
                                          selected = character(0),
                                          inline=TRUE
                                          ),
                                        hr(),
                                        # Result/interpretation description
                                        uiOutput("wat_ann_analysis_description")
                                        ),
                                      style = "primary"),
                      bsCollapsePanel("Freeform Analysis",
                                      # Control Panel
                                      fluidRow(
                                        column(3,
                                               # h4("Main Control Panel"),
                                               selectInput(
                                                 "wat_ann_basin_selected_1",
                                                 label = "Select two basin regions:",
                                                 choices = basin_full_names,
                                                 selected = "Basin-wide"
                                                 ),
                                               selectInput(
                                                 "wat_ann_basin_selected_2",
                                                 label = NULL,
                                                 choices = basin_full_names,
                                                 selected = "Upper Basin"
                                                 )
                                               ),
                                        column(3,
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
                                                 )
                                               ),
                                        column(3,
                                               radioButtons("wat_ann_plot_type_selected",
                                                            label = "Select a plot type:",
                                                            choices = list("Mean annual values" = 1, "Changes in mean annual values, relative to Baseline (fluxes as percent changes)" = 2, "Changes in mean annual values, relative to Baseline (fluxes as aboslute differences)" = 3), 
                                                            selected = 1
                                                            )
                                               )
                                        ),
                                      style="info"
                                      ),
                      bsCollapsePanel("More Info",
                                      tags$li(HTML("More info on each basin region can be found at the"),
                                              actionLink("link_from_wat_ann_to_watersheds1a","More Info > Watersheds"),
                                              HTML("and"),
                                              actionLink("link_from_wat_ann_to_watersheds1b","More Info > Forest Disturbances > Watershed statistics"),
                                              HTML("pages.")
                                              ),
                                      tags$li(HTML("More info on the modelled scenarios can be found on"), 
                                              actionLink("link_from_wat_ann_to_scenario_overview","More Info > Scenario Overview"),
                                              HTML("page.")
                                              ),
                                      tags$li(HTML("More info on the model framework can be found on"), 
                                              actionLink("link_from_wat_ann_to_framework_overview1","More Info > Framework Overview"),
                                              HTML("page.")
                                              ),
                                      tags$li(HTML("Check out the"),
                                              actionLink("link_from_wat_ann_to_wat_month1","Monthly Watershed-Analyses"),
                                              HTML("to learn the impacts to streamflow timing and the underlying snowpack dynamics.")
                                              ),
                                      tags$li(HTML("Follow the guided analysis on the"),
                                              actionLink("link_from_wat_ann_to_spatial_analyses1","Spatial-Analyses"),
                                              HTML("page to compare how these changes were distributed across the basin and to learn the overall conclusions and water resource management implications of this work.")
                                              ),
                                      style="success"
                                      )
                      )
           )
         ),
## -----------------------------------------Watershed-Analyses Monthly page---------------------------------------------## ----
tabPanel("Monthly",
         id = "watershed_analyses_monthly",
         fluidRow(
           plotlyOutput("wat_mon_plot"),
           br(),
           
           # Information Panels
           bsCollapse(id = "watershed_analyses_monthly_panels",
                      open = "Figure Description",
                      bsCollapsePanel("Figure Description",
                                      htmlOutput("wat_mon_plot_description"),
                                      hr(),
                                      helpText(HTML("Notes: <br>- Move mouse over plot to highlight individual values. Click legend items to hide/show. Double-click legend items to isolate."),
                                               HTML("<br>- All plot settings can be manually adjusted in the"),
                                               actionLink("wat_mon_plot_description_to_freeform","'Freeform Analysis' panel"),
                                               HTML("below (e.g., selecting options to to visualize Upper Basin streamflow in million-acre feet [MAF])."),
                                               HTML("<br>- Comparison of the \'0% Disturbance\' case to the Baseline indicates the climate impacts."),
                                               HTML("<br>- Comparisons of the \'0% Disturbance\' case to any other disturbance case (10-90%) indicate the forest disturbance impacts."),
                                               HTML("<br>- Follow the steps in the"),
                                               actionLink("wat_mon_plot_description_to_guided","'Guided Analysis' panel"),
                                               HTML("below to learn the findings at the mean monthly watershed scale.")
                                               ),
                                      style="default"
                                      ),
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
                                          # selected = "wat_mon_analysis_conclusions",
                                          selected = character(0),
                                          inline=TRUE
                                        ),
                                        hr(),
                                        # Result/interpretation description
                                        uiOutput("wat_mon_analysis_description")
                                        
                                      ),
                                      style = "primary"),
                      bsCollapsePanel("Freeform Analysis",
                                      # Control Panel
                                      fluidRow(
                                        column(3,
                                               selectInput(
                                                 "wat_mon_basin_selected",
                                                 label = "Select a basin region:",
                                                 choices = basin_full_names,
                                                 selected = "Basin-wide"
                                               )
                                               ),
                                        column(3,
                                               selectInput(
                                                 "wat_mon_var_selected_1",
                                                 label = "Select three variables:",
                                                 choices = sort(var_visible_wat_mon),
                                                 selected = "Streamflow ([cubic km])"
                                               )),
                                        column(3,br(),
                                               selectInput(
                                                 "wat_mon_var_selected_2",
                                                 label = NULL,
                                                 choices = sort(var_visible_wat_mon),
                                                 selected = "Snowmelt"
                                               )),
                                        column(3,br(),
                                               selectInput(
                                                 "wat_mon_var_selected_3",
                                                 label = NULL,
                                                 choices = sort(var_visible_wat_mon),
                                                 selected = "Total evapotranspiration"
                                               )
                                        )
                                        ),
                                      style="info"),
                      bsCollapsePanel("More Info",
                                      tags$li(HTML("More info on each basin region can be found at the"), 
                                              actionLink("link_from_wat_mon_to_watersheds1a","More Info > Watersheds"),
                                              HTML("and"),
                                              actionLink("link_from_wat_mon_to_watersheds1b","More Info > Forest Disturbances > Watershed statistics"),
                                              HTML("pages.")),
                                      tags$li(HTML("More info on the modelled scenarios can be found on"),
                                              actionLink("link_from_wat_mon_to_scenario_overview1","More Info > Scenario Overview"),
                                              HTML("page.")),
                                      tags$li(HTML("More info on the model framework can be found on"),
                                              actionLink("link_from_wat_mon_to_framework_overview1","More Info > Framework Overview"),
                                              HTML("page.")),
                                      tags$li(HTML("Check out the"),
                                              actionLink("link_from_wat_mon_to_wat_ann1","Annual Watershed-Analyses"),
                                              HTML(".")),
                                      tags$li(HTML("Follow the guided analysis on the"),
                                              actionLink("link_from_wat_mon_to_spatial_analyses1","Spatial-Analyses"),
                                              HTML("page to compare how changes were distributed across the basin and to learn the overall conclusions and water resource management implications of this work.")
                                              ),

                                      style="success"
                                      )
                      )
           )
)

),

## -----------------------------------------Spatial-Analyses Tab---------------------------------------------## ----
tabPanel(
  "Spatial-Analyses",
  fluidRow(
    # Warm/Wet Tab
    tabsetPanel(
      id = "spatial_scenario_panels",
      tabPanel(
        id = "spatial_scenario_warm_wet",
        title = "Warm/Wet Climate",
        
        # Plot titles (variable names)
        fluidRow(
          column(6,
                 htmlOutput("spatial_plot_warmwet_var1")
                 ),
          column(6,
                 htmlOutput("spatial_plot_warmwet_var2")
                 )
          ),
        
        # Plots
        combineWidgetsOutput('spatial_scenario_maps_warmwet', width = "100%", height = "600px")
        ),
      
      # Hot/Dry Tab
      tabPanel(
        id = "spatial_scenario_hot_dry",
        title = "Hot/Dry Climate",
         
        # Plot titles (variable names)
        fluidRow(
          column(6,
                 htmlOutput("spatial_plot_hotdry_var1")
                 ),
          column(6,
                 htmlOutput("spatial_plot_hotdry_var2")
                 )
          ),
        
        # Plots
        combineWidgetsOutput('spatial_scenario_maps_hotdry', width = "100%", height = "600px")
        )
       )
    ),
  fluidRow(
    
    # Information Panels
    bsCollapse(id = "spatial_analyses_panels",
               open = "Figure Description",
               bsCollapsePanel("Figure Description",
                               htmlOutput("spatial_plot_description"),
                               hr(),
                               helpText(HTML("Notes:<br>- Move mouse over plot to highlight average values across each subbasin."),
                                        HTML("<br>- Click and drag on the map to move the position."),
                                        HTML("<br>- Click '+' or '-' icons or use your mouse scroll to zoom in/out.<br>- Click the magnifying glass icon to search for and highlight regions of interest."),
                                        
                                        HTML("<br>- All plot settings can be manually adjusted in the"),
                                        actionLink("spatial_plot_description_to_freeform","'Freeform Analysis' panel"),
                                        HTML("below."),
                                        HTML("<br>- Follow the steps in the"),
                                        actionLink("spatial_plot_description_to_guided","'Guided Analysis' panel"),
                                        HTML("below to learn the findings at the spatially-distributed scale."),
                                        HTML("<br>- The major findings across all analysis scales are listed in the"),
                                        actionLink("spatial_plot_description_to_conclusions","'Overarching Research Conclusions' panel."),
                                        HTML("<br>- The broader relevance of these findings are listed in the"),
                                        actionLink("spatial_plot_description_to_implications","'Water Management and Policy Implications' panel.")
                                        ),
                               style="default"),
               bsCollapsePanel("Guided Analysis",
                               fluidRow(
                                 
                                 # Analysis steps
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
                               style = "primary"),
               bsCollapsePanel("Overarching Research Conclusions",
                               style="warning",
                               uiOutput("spatial_analysis_conclusions_description")
                               ),
               bsCollapsePanel("Water Management and Policy Implications",
                               style="danger",
                               uiOutput("spatial_analysis_implications_description")
                               ),
               bsCollapsePanel("Freeform Analysis",
                               column(3,
                                      selectInput(
                                        "spatial_var_selected_1",
                                        label = "Select two variables:",
                                        choices = sort(var_visible_spatial),
                                        selected = "Snow water equivalent"
                                      ),
                                      selectInput(
                                        "spatial_var_selected_2",
                                        label = NULL,
                                        choices = sort(var_visible_spatial),
                                        selected = "Total evapotranspiration"
                                      )),
                               column(3,
                                      selectInput(
                                        "spatial_temporal_scale_selected",
                                        label = "Select a temporal average:",
                                        choices = names(spatial_input_argument_dictionary$temporal_scales),
                                        selected = "Annual (Oct-Sep)"
                                        )
                                      ),
                               column(3,
                                      selectInput(
                                        "spatial_impact_type_selected",
                                        label="Select impact type",
                                        choices = names(spatial_input_argument_dictionary$impact_scenarios),
                                        selected = "30% Forest disturbance"
                                      ),
                                      htmlOutput("spatial_plot_impact_description"),),
                               column(3,
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
                                      ),
                               htmlOutput("spatial_plot_forest_disturbance_sensitivity_vars"),
                               style="info"
                               ),
               bsCollapsePanel("More Info",
                               tags$li(HTML("More info on each basin region can be found at the"), 
                                       actionLink("link_from_spatial_to_watersheds1a","More Info > Watersheds"),
                                       HTML("and"),
                                       actionLink("link_from_spatial_to_watersheds1b","More Info > Forest Disturbances > Watershed statistics"),
                                       HTML("pages.")),
                               tags$li(HTML("More info on the modelled scenarios can be found on"),
                                       actionLink("link_from_spatial_to_scenario_overview1","More Info > Scenario Overview"),
                                       HTML("page.")),
                               tags$li(HTML("More info on the model framework can be found on"),
                                       actionLink("link_from_spatial_to_framework_overview1","More Info > Framework Overview"),
                                       HTML("page.")),
                               tags$li(HTML("Check out the Watershed-Analyses analyses at the mean"),
                                       actionLink("link_from_spatial_to_wat_ann1","annual"),
                                       HTML("or"),
                                       actionLink("link_from_spatial_to_wat_mon1","monthly"),
                                       HTML("scales.")
                                       ),
                               tags$li(HTML("Follow the"),
                                       actionLink("spatial_analysis_update1","Guided Analysis"),
                                       HTML("to learn the overall conclusions and water resource management implications of this work.")
                                       ),
                               
                               style="success"
               )
               
    )
  )
  
),

## -----------------------------------------More Info menu---------------------------------------------## ----
tabPanel(
  "More Info",
         fluidRow(
           column(
             width = 12, offset = 0,
         verticalTabsetPanel(
           id = "more_info_panels",
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
                                 tags$li(actionLink("link_from_scenario_to_climate_projections","Climate projections"),
                                         HTML("from downscaled general circulation model (GCM) products and"),
                                         HTML("two emissions scenarios (Representative Concentration Pathways"),
                                         HTML("4.5 and 8.5, or R45 and R85) for the Baseline (left) and Future"),
                                         HTML("(middle) simulations based on Warm/Wet (a,b) or Hot/Dry climates"),
                                         HTML("(c,d).<sup>1-3</sup>")
                                 ),
                                 tags$li(
                                   actionLink("link_from_scenario_to_forest_disturbances1","Land Cover Maps"),
                                         HTML("from the FORE-SCE land cover products including from historic"),
                                         HTML("year 2005 and Far-Future"),
                                         HTML("year 2099 under the A2 (economic-development, high population"),
                                         HTML("growth) scenario for the Baseline (left) and Future (middle)"),
                                         HTML(" simulations.<sup>4</sup>")
                                 ),
                                 tags$li(
                                   actionLink("link_from_scenario_to_forest_disturbances2","Forest Disturbances"),
                                         HTML("applied to the (b, d) Far-Future land cover conditions.")
                                 )
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
                               hr(),
                               helpText(HTML("More info can be found in <a href=\"https://ascelibrary.org/doi/full/10.1061/JWRMD5.WRENG-5905\">Whitney <i>et al</i>. (2023)</a>.")),
                               style = "primary"),
               bsCollapsePanel("References", 
                                  tags$ol(
                                   tags$li(htmlOutput("scenario_pierce_et_al_2014")),
                                   tags$li(htmlOutput("scenario_pierce_et_al_2015")),
                                   tags$li(htmlOutput("scenario_taylor_et_al_2012")), 
                                   tags$li(htmlOutput("scenario_sleeter_et_al_2012")),
                                   tags$li(htmlOutput("scenario_whitney_et_al_2023"))
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
                                         HTML("version 5.0 at the 1/16th degree resolution (~6 km).<sup>1,2</sup>")
                                 ),
                                 tags$li(HTML("We derived"),
                                         actionLink("link_from_framework_to_climate_projections","climate projections"),
                                         HTML("(daily precipitation and air"),
                                         HTML("temperature) from statistically-downscaled general"),
                                         HTML("circulation model (GCM) products for the period of 1950-2099.<sup>3-5</sup>")),
                                 tags$li(HTML("We estimated unobserved climate forcings and diurnal"),
                                         HTML("cycles of meteorological variables using"), 
                                         HTML("<a href=\"https://metsim.readthedocs.io/en/develop/\">MetSim</a>"),
                                         # actionLink("link_from_framework_to_met_model","MetSim"),
                                         HTML("with storm parameters based on"),
                                         HTML("meteorological station observations.<sup>6-9</sup>")),
                                 tags$li(HTML("We used historic and future projected"),
                                         actionLink("link_from_framework_to_land_cover","land cover maps"),
                                         HTML("from FORE-SCE products to update VIC land cover parameters,"),
                                         HTML("which include climatological monthly land cover parameters.<sup>10,11</sup>")),
                                 tags$li(HTML("We applied scenarios of"),
                                         actionLink("link_from_framework_to_forest_disturbances","forest disturbances"),
                                         HTML("to the future projected land cover parameters using a bottom-up approach.")),
                                 tags$li(HTML("Other"),
                                         actionLink("link_from_framework_to_model_parameters","model parameters"),
                                         HTML("included calibrated soil and baseflow parameters based on Xiao <em>et al.</em> (2018,2022), Livneh <em>et al.</em> (2015b), and Nijssen <em>et al.</em> (2001).")),
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
                               hr(),
                               HTML("The table below lists the hydrological processes in the model framework used in this work."),
                               tags$figure(
                                 align = "center",
                                 tags$img(
                                   src = vic_ex_images$framework_overview_table$image_src,
                                   width = vic_ex_images$framework_overview_table$image_width,
                                   alt = vic_ex_images$framework_overview_table$image_alt_text,
                                   height = vic_ex_images$framework_overview_table$image_height
                                 )
                               ),
                               hr(),
                               helpText(HTML("More info can be found in <a href=\"https://ascelibrary.org/doi/full/10.1061/JWRMD5.WRENG-5905\">Whitney <i>et al</i>. (2023)</a>.")),
                               
                               
                               style = "primary"),
               bsCollapsePanel("References + Source Code",
                               h5(HTML("<b>MetSim code:</b>"),
                                  htmlOutput("framework_metsim_code")),
                               h5(HTML("<b>VIC code:</b>"),
                                  htmlOutput("framework_vic_code")),
                               h5(HTML("<b>R-VIC code:</b>"),
                                  htmlOutput("framework_rvic_code")),
                               h5(HTML("<b>References:</b>")),
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
                                   tags$li(htmlOutput("framework_livneh_et_al_2015b")), 
                                   tags$li(htmlOutput("framework_nijssen_et_al_2001")),
                                   tags$li(htmlOutput("framework_lohmann_et_al_1996")),
                                   tags$li(htmlOutput("framework_lohmann_et_al_1998")),
                                   tags$li(htmlOutput("framework_bennett_et_al_2018a")),
                                   tags$li(htmlOutput("framework_bennett_et_al_2018b")),
                                   tags$li(htmlOutput("framework_usgs_et_al_2016a")),
                                   tags$li(htmlOutput("framework_andreadis_et_al_2009")),
                                   tags$li(htmlOutput("framework_liang_et_al_1999")),
                                   tags$li(htmlOutput("framework_cherkauer_lettenmaier_2003")),
                                   tags$li(htmlOutput("framework_wigmosta_et_al_1994")), 
                                   tags$li(htmlOutput("framework_franchini_pacciani_1991")),  
                                   tags$li(htmlOutput("framework_bohn_vivoni_2016")),
                                   tags$li(htmlOutput("framework_whitney_et_al_2023"))
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
    id = "more_info_hydro_model",
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
                                   tags$li(HTML("VIC forcing inputs included timeseries of hourly meteorology (total precipitation, air temperature, wind speed, radiation, humidity), which were estimated using a separate model ("),
                                           # actionLink("link_from_hydro_overview_to_met_model","MetSim"),
                                           HTML("<a href=\"https://metsim.readthedocs.io/en/develop/\">MetSim</a>"),
                                           HTML(").")),
                                   tags$li(HTML("VIC esimates the"), actionLink("link_from_hydro_overview_to_hydro_model_prec","partitioning of precipitation"), HTML("in to rain and snowfall using a temperature-based scheme.")),
                                   tags$li(HTML("All tiles within a cell receive the same rain and snowfall amounts.")),
                                   hr(),
                                   helpText(HTML("For More info on VIC, <a href=\"https://vic.readthedocs.io/en/master/Overview/ModelOverview/\">click here</a>")),
                                   
                                   style = "primary"),
                   bsCollapsePanel("Assumptions", 
                                   tags$li(HTML("Grid cells do not interact with each other (no sub-surface moisture transfer or recharge from soil to rivers), except in river routing (handled separately by,"),actionLink("link_from_hydro_overview_to_flow_rout","R-VIC"),HTML(").")),
                                   tags$li(HTML("This requires assumptions (e.g., vertical fluxes are much larger than horizontal).")),
                                   tags$li(HTML("This assumption is generally statisfied by the large grid cell size (1/16<sup>th o</sup> in our case, 1/8<sup>th o</sup> in most prior cases<sup>5-7</sup>).")),
                                   tags$li(HTML("This VIC application did not represent the consumptive water uses from projected urban and agricultural growth in our"),
                                                actionLink("link_from_hydro_overview_to_land_cover","land use land cover (LULC) scenarios"), 
                                                HTML("and their resulting impacts on the water balance.")),
                                   tags$li(HTML("While VIC can be modified to account for water use increases with urban and agricultural growth (e.g., Bohn et al., 2018b; Wang and Vivoni, 2022),"),
                                                actionLink("link_from_hydro_overview_to_stakeholder_engagement", "stakeholder interest"),
                                                HTML("was focused primarily on forest disturbances.")),
                                   tags$li(HTML("Furthermore, the water use requirements associated with the FORE-SCE projected agricultural growth might not be realistic given available water supplies.")),
                                   
                                   style = "warning"),
                   bsCollapsePanel("References + Source Code",
                                   h5(HTML("<b>VIC code:</b>"),
                                      htmlOutput("hydro_overview_vic_code")),
                                   h5(HTML("<b>References:</b>")),
                                   tags$ol(
                                     tags$li(htmlOutput("hydro_overview_liang_et_al_1994")),
                                     tags$li(htmlOutput("hydro_overview_andreadis_et_al_2009")), 
                                     tags$li(htmlOutput("hydro_overview_cherkauer_lettenmaier_2003")),
                                     tags$li(htmlOutput("hydro_overview_bohn_vivoni_2016")),
                                     tags$li(htmlOutput("hydro_overview_christensen_lettenmaier_2007")),
                                     tags$li(htmlOutput("hydro_overview_bureau_2012")),
                                     tags$li(htmlOutput("hydro_overview_vano_lettenmaier_2012")),
                                     tags$li(htmlOutput("hydro_overview_hamman_et_al_2018")),
                                     tags$li(htmlOutput("hydro_overview_bohn_et_al_2018b")),
                                     tags$li(htmlOutput("hydro_overview_wang_vivoni_2022"))
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
        br(),
        plotlyOutput("p_partitioning_fig"),
        br(),
        
        # Information Panels
        bsCollapse(id = "hydro_model_prec_info_panels", 
                   open = "Figure Description",
                   bsCollapsePanel("Figure Description", 
                                   tags$p(
                                     HTML("The VIC model uses a simple (linear) method to determine the percentage",
                                          "of liquid (rain) or solid (snow) precipitation",
                                          "based on hourly near surface air temperature (<i>T</i>).<sup>1</sup>"),
                                     helpText(HTML("If <i>T</i> ≤ -0.5<sup>o</sup>C, then precipitation falls 100% as snow.")),
                                     helpText(HTML("If <i>T</i> ≥ 0.5<sup>o</sup>C, the precipitation falls 100% as rain.")),
                                     helpText(HTML("Values in between are a linear interpolation between the two values.",
                                     "(e.g., simulated precipitation at -0.03<sup>o</sup>C produces 75% snow, 25% rain).")),
                                     helpText(HTML("<i>Note: Move mouse over plot to highlight individual values.</i>"))
                                   ),
                                   style = "default"),
                   bsCollapsePanel("More Info",
                                   tags$figure(
                                     align = "center",
                                     tags$img(
                                       src = vic_ex_images$elevation_bands$image_src,
                                       width = vic_ex_images$elevation_bands$image_width,
                                       alt = vic_ex_images$elevation_bands$image_alt_text,
                                       height = vic_ex_images$elevation_bands$image_height
                                     )
                                   ),
                                   helpText(HTML("Image from open access VIC documentation (<a href=\"http://vic.readthedocs.io/en/master/Overview/ModelOverview/\">http://vic.readthedocs.io/en/master/Overview/ModelOverview/</a>)")),
                                   tags$li("VIC simulates orographic effects on precipitation partitioning (and ",
                                           actionLink("link_from_hydro_p_partition_to_hydro_model_snow","snowpack processes"), 
                                           ")."),
                                   tags$li(HTML("This is important for representing the differences in <b>snow accumulation (and snowmelt) timing</b> between high and low elevations.")),
                                   tags$li(HTML("This is based on <b>user specified snow (elevation) bands</b> (and associated gridcell fractional area).")),
                                   tags$li(HTML("The mean grid cell temperature is lapsed to each elevation band (adjusted using a lapse rate of -6.5<sup>o</sup>C/km). Precipitation falls as either liquid or solid depending on the lapsed temperature (and "),
                                           actionLink("hydro_p_partition_update1",HTML("the precipitation phase air temperature thresholds [-0.5, 0.5<sup>o</sup>C]")),
                                           HTML(").")),
                                   hr(),
                                   helpText(HTML("For More info on the snow band formulation, <a href=\"https://vic.readthedocs.io/en/master/Overview/SnowBandsText/\">click here</a>")),
                                   style = "primary"),
                   bsCollapsePanel("Assumptions", 
                                   tags$li(HTML("VIC assumes that the near surface air temperature thresholds determining precipitation phase (-0.5, 0.5<sup>o</sup>C) do not vary across space.")),
                                   tags$li(HTML("However, observational and other modeling efforts indicate this threshold can vary across space and that better predictions are potentially achieved based on both humidity and near-surface air temperature.<sup>2-4")),
                                   style = "warning"),
                   bsCollapsePanel("References", 
                                   h5(HTML("<b>References:</b>")),
                                   # insert references
                                   tags$ol(
                                     tags$li(htmlOutput("p_partitioning_andreadis_et_al_2009")),
                                     tags$li(htmlOutput("p_partitioning_marks_et_al_2013")),
                                     tags$li(htmlOutput("p_partitioning_jennings_et_al_2018")),
                                     tags$li(htmlOutput("p_partitioning_harpold_et_al_2017")),
                                     tags$li(htmlOutput("p_partitioning_wang_et_al_2019"))
                                     ),
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
        helpText(HTML("Image from open access VIC documentation (<a href=\"http://vic.readthedocs.io/en/master/Overview/ModelOverview/\">http://vic.readthedocs.io/en/master/Overview/ModelOverview/</a>)")),
        
        # Information Panels
        bsCollapse(id = "hydro_model_snow_info_panels", 
                   open = "Figure Description",
                   bsCollapsePanel("Figure Description", 
                                   tags$p(
                                     HTML("VIC considers snow in several forms: ground snowpack, snow in the vegetation canopy, and on top of lake ice. VIC was improved with the snow vegetation canopy scheme of Cherkauer <em>et al.</em> (2003),"),
                                     HTML("and then later upgraded by Andreadis <em>et al.</em> (2009) with fully-balanced energy terms and representation of snow interception."),
                                     h5(HTML("<b>Snow of Vegetation Canopy:</b>")),
                                     tags$li(HTML("Amount intercepted is related to leaf area index (LAI).")),
                                     tags$li(HTML("Includes sublimation, drip and release to ground.")),
                                     tags$li(HTML("Does not include grasses (no canopy storage).")),
                                     h5(HTML("<b>Ground Snowpack:</b>")),
                                     tags$li(HTML("Uses two-layer energy-balance model at the snow surface (thin surface + pack layer).")),
                                     tags$li(HTML("Includes longwave, shortwave, sensible + latent heat, and convective energy.")),
                                     tags$li(HTML("Water can be added as rain, snow, drip/throughfall from canopy.")),
                                     tags$li(HTML("Albedo and snowpack size evolves with snow ages.")),
                                     hr(),
                                     helpText(HTML("For More info on the snow pack formulation, <a href=\"https://vic.readthedocs.io/en/master/Overview/SnowModelText/\">click here</a>"))
                                   ),
                                   style = "default"),
                   bsCollapsePanel("More Info", 
                                   tags$figure(
                                     align = "center",
                                     tags$img(
                                       src = vic_ex_images$elevation_bands$image_src,
                                       width = vic_ex_images$elevation_bands$image_width,
                                       alt = vic_ex_images$elevation_bands$image_alt_text,
                                       height = vic_ex_images$elevation_bands$image_height
                                     )
                                   ),
                                   helpText(HTML("Image from open access VIC documentation (<a href=\"http://vic.readthedocs.io/en/master/Overview/ModelOverview/\">http://vic.readthedocs.io/en/master/Overview/ModelOverview/</a>)")),
                                   tags$li("VIC simulates orographic effects on snowpack processes (and ",
                                           actionLink("link_from_hydro_model_snow_to_hydro_model_p_partitioning","precipitation partitioning"), 
                                           ")."),
                                   tags$li(HTML("This is important for representing the differences in <b>snow accumulation and snowmelt timing</b> between high and low elevations.")),
                                   tags$li(HTML("This is based on <b>user specified snow (elevation) bands</b> (and associated gridcell fractional area).")),
                                   tags$li(HTML("The mean grid cell temperature is lapsed to each elevation band (adjusted using a lapse rate of -6.5<sup>o</sup>C/km), and then used to solve the energy balance for each land cover tile.")),
                                   # tags$li(HTML("The snow band elevations are used to compute the snowpack processes using the following aggregation scheme:")),
                                   hr(),
                                   tags$figure(
                                     align = "center",
                                     tags$img(
                                       src = vic_ex_images$elevation_bands_aggregation$image_src,
                                       width = vic_ex_images$elevation_bands_aggregation$image_width,
                                       alt = vic_ex_images$elevation_bands_aggregation$image_alt_text,
                                       height = vic_ex_images$elevation_bands_aggregation$image_height
                                     )
                                   ),
                                   hr(),
                                   tags$figure(
                                     align = "center",
                                     tags$img(
                                       src = vic_ex_images$snowpack_evolution$image_src,
                                       width = vic_ex_images$snowpack_evolution$image_width,
                                       alt = vic_ex_images$snowpack_evolution$image_alt_text,
                                       height = vic_ex_images$snowpack_evolution$image_height
                                     )
                                   ),
                                   hr(),
                                   helpText(HTML("For More info on the snow band formulation, <a href=\"https://vic.readthedocs.io/en/master/Overview/SnowBandsText/\">click here</a>")),
                                   style = "primary"),
                   bsCollapsePanel("Assumptions",
                                   tags$figure(
                                     align = "center",
                                     tags$img(
                                       src = vic_ex_images$snowpack_assumptions$image_src,
                                       width = vic_ex_images$snowpack_assumptions$image_width,
                                       alt = vic_ex_images$snowpack_assumptions$image_alt_text,
                                       height = vic_ex_images$snowpack_assumptions$image_height
                                     )
                                   ),
                                   style = "warning"),
                   bsCollapsePanel("References", 
                                   h5(HTML("<b>References:</b>")),
                                   # insert references
                                   tags$ol(
                                     tags$li(htmlOutput("hydro_model_snowpack_andreadis_et_al_2009")),
                                     tags$li(htmlOutput("hydro_model_snowpack_cherkauer_et_al_2003")),
                                     tags$li(htmlOutput("hydro_model_snowpack_liang_et_al_1994")),
                                     tags$li(htmlOutput("hydro_model_snowpack_xiao_et_al_2022"))
                                   ),
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
                                     HTML("Total evapotranspiration (<i>ET</i>) is made up of four components for each"),
                                     actionLink("link_from_hydro_model_evap_to_hydro_model_elev_bands","elevation band"),
                                     HTML("and vegetation type. Canopy evaporation (<i>E<sub>c</sub></i>), plant transpiration (<i>T<sub>v</sub></i>), and bare soil evaporation (<i>E<sub>soil</sub></i>) use a"),
                                     actionLink("hydro_model_evap_update1",HTML("physically-based Penman Monteith approach")),
                                     HTML(".<sup>1</sup>"),
                                     actionLink("link_from_hydro_model_evap_to_snowpack","Sublimation"),
                                     HTML("is drawn from snowpacks stored in the vegetation canopy and on the ground using an energy-balance model.<sup>1-3</sup>")
                                     ),
                                   
                                   style = "default"),
                   bsCollapsePanel("More Info", 
                                   tags$figure(
                                     align = "center",
                                     tags$img(
                                       src = vic_ex_images$penman_monteith$image_src,
                                       width = vic_ex_images$penman_monteith$image_width,
                                       alt = vic_ex_images$penman_monteith$image_alt_text,
                                       height = vic_ex_images$penman_monteith$image_height
                                     ),
                                     hr(),
                                     tags$img(
                                       src = vic_ex_images$clumped_canopy$image_src,
                                       width = vic_ex_images$clumped_canopy$image_width,
                                       alt = vic_ex_images$clumped_canopy$image_alt_text,
                                       height = vic_ex_images$clumped_canopy$image_height
                                     )
                                   ),
                                   style = "primary"),
                   bsCollapsePanel("Assumptions", 
                                   tags$li(HTML("Net radiation (used for the"),
                                   actionLink("hydro_model_evap_update2",HTML("Penman Monteith approach")),
                                   HTML("and"),
                                   actionLink("link_from_hydro_model_evap_to_snowpack_assumptions","snowpack energy-balance model"),
                                   HTML(") is solved through an iterative procedure (until the initial and final values of surface temperature are within tolerance). Xiao <em>et al.</em> (2022) describes these processes in detail.")
                                   ),
                                   tags$li(
                                     actionLink("hydro_model_evap_update3",HTML("The clumped canopy scheme")),
                                     HTML("assumes a temporally constant vegetation fraction and climatological monthly leaf area index (LAI) values (both are spatially variable; LAI is plant specific), estimated from remote sensing products.")
                                           ),
                                   style = "warning"),
                   bsCollapsePanel("References", 
                                   h5(HTML("<b>References:</b>")),
                                   # insert references
                                   tags$ol(
                                     tags$li(htmlOutput("hydro_model_evap_liang_et_al_1994")),
                                     tags$li(htmlOutput("hydro_model_evap_andreadis_et_al_2009")),
                                     tags$li(htmlOutput("hydro_model_evap_cherkauer_et_al_2003")),
                                     tags$li(htmlOutput("hydro_model_evap_bohn_and_vivoni_2016")),
                                     tags$li(htmlOutput("hydro_model_evap_xiao_et_al_2022"))
                                   ),
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
                                     HTML("Surface runoff and soil infiltration is define by the variable infiltration capacity  (VIC) curve.<sup>1</sup>",
                                          "This accounts for heterogeneity in soil moisture storage capacities within each grid cell.",
                                          "The curve approximates the distribution of infiltration capacities (how much pore space exists) in all parts of the cell."),
                                     HTML("When a certain amount of water input falls over the cell during a given time step:"),
                                     tags$li(HTML("The water immediately infiltrates (no limit on infiltration rate) until either all water infiltrates or the soil (locally) reaches saturation.")),
                                     tags$li(HTML("The remainder of the influx produces runoff.")),
                                     hr(),
                                     helpText(HTML("Image adapted from open access VIC documentation (<a href=\"http://vic.readthedocs.io/en/master/Overview/ModelOverview/\">http://vic.readthedocs.io/en/master/Overview/ModelOverview/</a>)"))
                                              
                                   ),
                                   style = "default"),
                   bsCollapsePanel("More Info", 
                                   tags$figure(
                                     align = "center",
                                     tags$img(
                                       src = vic_ex_images$beta_parameter$image_src,
                                       width = vic_ex_images$beta_parameter$image_width,
                                       alt = vic_ex_images$beta_parameter$image_alt_text,
                                       height = vic_ex_images$beta_parameter$image_height
                                     )),
                                   style = "primary"),
                   bsCollapsePanel("Assumptions", 
                                   tags$li(HTML("Relies on an empirical"),
                                           actionLink("hydro_model_infil_runoff_update",HTML("VIC curve shape parameter")),
                                           HTML("(unqiue value for each land cover tile, typically calibrated based on observed river discharge).")
                                           ),
                                   tags$li(HTML("Infiltration is computed for the top two soil layers combined.")),
                                   style = "warning"),
                   bsCollapsePanel("References", 
                                   h5(HTML("<b>References:</b>")),
                                   # insert references
                                   tags$ol(
                                     tags$li(htmlOutput("hydro_model_infil_runoff_liang_et_al_1994"))
                                   ),
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
        br(),
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
                                     HTML("Subsurface flow (baseflow, <i>B</i>) is estimated using the <b>Arno baseflow model</b> (Franchini and Pacciani, 1991).")
                                   ),
                                   hr(),
                                   helpText(HTML("Image adapted from open access VIC documentation (<a href=\"http://vic.readthedocs.io/en/master/Overview/ModelOverview/\">http://vic.readthedocs.io/en/master/Overview/ModelOverview/</a>)")),
                                   style = "default"),
                   bsCollapsePanel("More Info",
                                   tags$li("Modeled baseflow is a function of soil moisture content in the lowest soil layer (layer 3 in our case)."),
                                   tags$li("The baseflow-soil moisture relationship is linear at low soil mositure contents (reduces the responsiveness of baseflow during dry conditions)."),
                                   tags$li("The baseflow-soil moisture relationship is non-linear at high soil mositure contents (rapid baseflow response during wet conditions)."),
                                   style = "primary"),
                   bsCollapsePanel("Assumptions", 
                                   tags$li(HTML("Baseflow is NOT groundwater recharge (VIC assumes groundwater recharge is 0). However, Rosenberg <i>et al.</i> (2013) found that use of a groundwater formulation had little impact on simulated streamflow in the Colorado River Basin.")),
                                   tags$li(HTML("Relies on empirical parameters that are unique to each grid cell (spatially-distributed, but do not vary for each land cover type).")),
                                   tags$li(HTML("Parameters (<i>W<sub>s</sub></i>, <i>D<sub>m</sub></i>, <i>D<sub>s</sub></i>) are typically calibrated based on observed river discharge.")),
                                   style = "warning"),
                   bsCollapsePanel("References",
                                   h5(HTML("<b>References:</b>")),
                                   # insert references
                                   tags$ol(
                                     tags$li(htmlOutput("hydro_model_baseflow_franchini_pacciani_1991")),
                                     tags$li(htmlOutput("hydro_model_baseflow_rosenberg_et_al_2013"))
                                   ),
                                   style = "info")
        )
        
      )
    )
  )
  )
  ),

# -----------------------------------------Streamflow Routing panel---------------------------------------------## ----
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
        src = vic_ex_images$rvic_channel_routing$image_src,
        width = vic_ex_images$rvic_channel_routing$image_width,
        alt = vic_ex_images$rvic_channel_routing$image_alt_text,
        height = vic_ex_images$rvic_channel_routing$image_height
      )
    ),
    br(),
    helpText(HTML("Image from open access R-VIC documentation (<a href=\"https://rvic.readthedocs.io/en/latest/about/model-overview/\">https://rvic.readthedocs.io/en/latest/about/model-overview/</a>)")),

    # Information Panels
    bsCollapse(id = "flow_rout_info_panels",
               open = "Figure Description",
               bsCollapsePanel("Figure Description",
                               tags$p(
                                 HTML("Simulated runoff and baseflow over each grid cell ("),
                                 actionLink("flow_rout_to_hydro_model","by the VIC hydrology model"),
                                 HTML(") was subsequently routed as streamflow using the R-VIC channel routing scheme.<sup>1,2</sup>"),
                                 br(),
                                 HTML("This routing scheme is a source-to-sink model that solves a linearized version of the Saint-Venant equations.")
                               ),
                               hr(),
                               helpText(HTML("More info can be found on the R-VIC documentation pages (<a href=\"https://rvic.readthedocs.io/en/latest/about/model-overview/\">https://rvic.readthedocs.io/en/latest/about/model-overview/</a>)")),
                               style = "default"),
               bsCollapsePanel("More Info",
                               tags$li("Routing occurs in two stages: (1) Routing of overland flow from a point of generation to the nearest channel within the grid cell. (2) Routing of channel flow through the network."),
                               tags$li("Utilizes Impulse Response Functions (IRFs; i.e. Unit-Hydrographs) for each stage to represent distribution of flow at the outlet point with respect to time from an impulse input at each source point."),
                               hr(),
                               helpText(actionLink("flow_rout_to_watersheds1","Navigate to the 'Watersheds' page"),HTML("for more info on the subbasin and channel delineations.")),
                               
                               helpText(HTML("More info can be found on the R-VIC documentation pages (<a href=\"https://rvic.readthedocs.io/en/latest/about/model-overview/\">https://rvic.readthedocs.io/en/latest/about/model-overview/</a>)")),
                               
                               style = "primary"),
               bsCollapsePanel("Assumptions",
                               # insert assumptions
                               h5(HTML("<b>Assumptions:</b>")),
                               tags$li("Impulse Response Functions (IRFs) are linear and time invariant."),
                               tags$li("A single, spatially uniform IRF is used for routing within the cell to the channel (stage 1 of routing; assumed similar throughout the basin)."),
                               tags$li("Spatially varying IRFs represent flow within the reaches of the channel (stage 2 of routing; non-similar throughout the basin)."),
                               tags$li("Water in channel does not re-enter grid cell water balance."),
                               tags$li("Assumes 'shallow water' flows (i.e., horizontal length scale >> vertical length scale)."),
                               tags$li("Ignores impacts of channel slope, friction slope, and water surface slope on flow."),
                               tags$li("Ignore losses or gains of water after initial runoff generation."),
                               tags$li("Flow is a linear superposition of the impulse response functions (IRFs; i.e., unit hydrographs)."),

                               h5(HTML("<b>Validity of Assumptions:</b>")),
                               tags$li(HTML("These assumptions are typically acceptable at large grid cell and basin scales.")),
                               tags$li(HTML("These conditions are broken in the case of over-bank flooding, high turbulence, or with any substantial loss/gain of water during transit")),
                               tags$li(HTML("Groundwater is not explicitly depicted. However, Rosenberg <i>et al.</i> (2013) found that use of a groundwater formulation had little impact on simulated streamflow in the Colorado River Basin.")),
                               
                               hr(),
                               helpText(HTML("More info can be found on the R-VIC documentation pages (<a href=\"https://rvic.readthedocs.io/en/latest/about/model-overview/\">https://rvic.readthedocs.io/en/latest/about/model-overview/</a>)")),
                               
                               style = "warning"),
               bsCollapsePanel("References",
                               h5(HTML("<b>References:</b>")),
                               tags$ol(
                                 tags$li(htmlOutput("flow_rout_lohmann_et_al_1996")),
                                 tags$li(htmlOutput("flow_rout_lohmann_et_al_1998")),
                                 tags$li(htmlOutput("flow_rout_rosenberg_et_al_2013"))
                                 
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
    id = "more_info_climate_proj",
    tabPanel(
      id= "clim_proj_plot",
      title = "Yearly changes",
      fluidRow(
        
      # Figure
      br(),
      tags$figure(
        align = "center",
        tags$img(
          src = vic_ex_images$climate_projections$image_src,
          width = vic_ex_images$climate_projections$image_width,
          alt = vic_ex_images$climate_projections$image_alt_text,
          height = vic_ex_images$climate_projections$image_height
        )
      ),
      br(),
      
      # Information Panels
      bsCollapse(id = "climate_projections_info_panels", 
                 open = "Figure Description",
                 bsCollapsePanel("Figure Description", 
                                 tags$p(
                                   HTML("Basin-averaged annual changes in (a) total precipitation (<i>ΔP</i>), and (b) air temperature (<i>ΔT</i>) in the Baseline (1976-2005) under historic emissions and in the future (2006-2099) under lower (Representative Concentration Pathway 4.5; R45) and higher (Representative Concentration Pathway 8.5; R85) emission scenarios."),
                                   hr(),
                                   HTML("Bold lines show the Warm/Wet (blue) and Hot/Dry (red) climate bookends, and shading shows the interquartile range (IQR; i.e., 25<sup>th</sup> to 75<sup>th</sup> percentiles) across the ensemble of eight climate models for each emission scenario (historic, or future R45 or R85). Grey boxes highlight the Baseline and Far-Future (2066-2095) periods. Annual changes are computed relative to the mean Baseline conditions.")
                                   
                                 ),
                                 style = "default"),
                 bsCollapsePanel("More Info", 
                                 tags$li(HTML("Climate model forcings were from statistically-downscaled GCM products<sup>1</sup> from the Climate Model Intercomparison Project 5 (CMIP5)<sup>2</sup> for RCPs 4.5 (R45) and 8.5 (R85), and initially included a subset of eight general circulation models (GCMs) that best reproduced historical conditions in the CRB.<sup>3</sup> ")),
                                 tags$li(actionLink("climate_proj_to_stakeholder1",HTML("Stakeholders proposed collapsing the effort to two climate bookends (a ‘worse or best case’ future)"))),
                                 tags$li(HTML("Based on"),
                                         actionLink("climate_proj_update1",HTML("comparisons of mean annual precipitation (<i>P</i>) and air temperature (<i>T</i>)")),
                                         HTML(", we selected downscaled climate forcings for 1976 to 2099 from two products: (1) CanESM2 under R45 emissions for the ‘Warm/Wet’ scenario, and (2) IPSL-CM5A-MR under the R85 emissions for the ‘Hot/Dry’ scenario.")),
                                 hr(),
                                 helpText(HTML("More info can be found in <a href=\"https://ascelibrary.org/doi/full/10.1061/JWRMD5.WRENG-5905\">Whitney <i>et al</i>. (2023)</a>.")),
                                 style = "primary"),
                 # bsCollapsePanel("Assumptions", 
                 #                 # insert assumptions
                 #                 style = "warning"),
                 bsCollapsePanel("References",
                                 h5(HTML("<b>References:</b>")),
                                 tags$ol(
                                   tags$li(htmlOutput("climate_proj_pierce_et_al_2014")), 
                                   tags$li(htmlOutput("climate_proj_taylor_et_al_2012")),
                                   tags$li(htmlOutput("climate_proj_gautam_mascaro_2018")),
                                   tags$li(htmlOutput("climate_proj_whitney_et_al_2023"))
                                 ),
                                 style = "info")
      )
      )
      ),
    tabPanel(
      id= "clim_proj_table",
      title = "Mean annual comparisons",
      tags$figure(
        align = "center",
        tags$img(
          src = vic_ex_images$climate_projections_table$image_src,
          width = vic_ex_images$climate_projections_table$image_width,
          alt = vic_ex_images$climate_projections_table$image_alt_text,
          height = vic_ex_images$climate_projections_table$image_height
        )
      ),
      # Information Panels
      bsCollapse(id = "climate_projections_table_info_panels", 
                 open = "Table Description",
                 bsCollapsePanel("Table Description", 
                                 tags$p(
                                   HTML("GCM values of mean annual precipitation (<i>P</i>) and air temperature (<i>T</i>) in the indicated basin regions for the Baseline (top) and Far-Future period under R45 (middle) and R85 (bottom). Changes relative to baseline ([% for <i>P</i>] and [<sup>o</sup>C for <i>T</i>]) in parentheses. Bolded values indicate the GCMs for the Warm/Wet (italic) and Hot/Dry (non-italic) cases."),
                                   hr(),
                                   helpText(HTML("More info on each basin region can be found at the"), 
                                           actionLink("climate_proj_to_watersheds1","More Info > Watersheds"),
                                           HTML("and"),
                                           actionLink("climate_proj_to_watersheds2","More Info > Forest Disturbances > Watershed statistics"),
                                           HTML("pages."))

                                   
                                 ),
                                 style = "default"),
                 bsCollapsePanel("More Info", 
                                 tags$li(HTML("Climate model forcings were from statistically-downscaled GCM products<sup>1</sup> of the Climate Model Intercomparison Project 5 (CMIP5)<sup>2</sup> for RCPs 4.5 (R45) and 8.5 (R85), and initially included a subset of eight general circulation models (GCMs) that best reproduced historical conditions in the CRB.<sup>3</sup> ")),
                                 tags$li(actionLink("climate_proj_to_stakeholder2",HTML("Stakeholders proposed collapsing the effort to two climate bookends (a ‘worse or best case’ future)"))),
                                 tags$li(HTML("Based on comparisons of mean annual precipitation (<i>P</i>) and air temperature (<i>T</i>), we selected downscaled climate forcings for 1976 to 2099 from two products: (1) CanESM2 under R45 emissions for the ‘Warm/Wet’ scenario, and (2) IPSL-CM5A-MR under the R85 emissions for the ‘Hot/Dry’ scenario.")),
                                 hr(),
                                 helpText(HTML("More info can be found in <a href=\"https://ascelibrary.org/doi/full/10.1061/JWRMD5.WRENG-5905\">Whitney <i>et al</i>. (2023)</a>.")),
                                 style = "primary"),
                 # bsCollapsePanel("Assumptions", 
                 #                 # insert assumptions
                 #                 style = "warning"),
                 bsCollapsePanel("References",
                                 h5(HTML("<b>References:</b>")),
                                 tags$ol(
                                   tags$li(htmlOutput("climate_proj_table_pierce_et_al_2014")), 
                                   tags$li(htmlOutput("climate_proj_table_taylor_et_al_2012")),
                                   tags$li(htmlOutput("climate_proj_table_gautam_mascaro_2018")),
                                   tags$li(htmlOutput("climate_proj_table_whitney_et_al_2023"))
                                 ),
                                 style = "info")
      )
      )
  )
),


## -----------------------------------------Forest Disturbances panel---------------------------------------------## ----
verticalTabPanel(
  title = "Forest Disturbances",
  #icon = icon("tree"),
  box_height= 0.1,
  
  # Content
  tabsetPanel(
    id = "more_info_forest_disturbances",
    tabPanel(
      id= "elevation_landcover_maps",
      title = "Overview",
      fluidRow(
        
        # Figure
        br(),
        tags$figure(
          align = "center",
          tags$img(
            src = vic_ex_images$elevation_landcover_maps$image_src,
            width = vic_ex_images$elevation_landcover_maps$image_width,
            alt = vic_ex_images$elevation_landcover_maps$image_alt_text,
            height = vic_ex_images$elevation_landcover_maps$image_height
          )
        ),
        br(),
        
        # Information Panels
        bsCollapse(id = "elevation_landcover_maps_info_panels", 
                   open = "Figure Description",
                   bsCollapsePanel("Figure Description", 
                                   tags$p(
                                     HTML("(a) Land cover map from the FORE-SCE (Sleeter <i>et al</i>., 2012) and INEGI (2013) products. (b) Elevations with subbasin delineations (black outlines) and their names, the location of the main basin outlet at Yuma, AZ, and the division of Upper and Lower Basin at Lees Ferry, AZ, from USGS (2016a). Red cross-hatching shows elevations ≥ 1,800 m."),
                                     hr(),
                                     helpText(actionLink("forest_disturb_update0","See 'More Info' panel"),HTML("below to learn how land cover and elevation were used to develop our forest disturbance scenarios.")),
                                     helpText(actionLink("forest_disturb_to_watersheds1","Navigate to the 'Watersheds' page"),HTML("for more info on the subbasin and channel delineations."))
                                   ),
                                   style = "default"),
                   bsCollapsePanel("More Info", 
                                   h5(HTML("<b>Elevation and land cover:</b>")),
                                   tags$li(HTML("Basin elevations range from 35 to 4391 m (above sea-level), with most high elevations contained in the Upper Basin (source area above Lees Ferry, AZ) where approximately 92% of streamflow originates as snowmelt.<sup>4</sup>")),
                                   tags$li(HTML("Land cover maps reveal that most land areas are characterized by shrub or scrub ecosystems (~59%), followed by various forest types (~23%), and grassland or herbaceous cover (11%).<sup>1,2</sup>")),
                                   tags$li(HTML("Future projections of land cover compositions were from the FOREcasting SCEnario (FORE-SCE)<sup>1</sup> products based on the review of Sohl <i>et al</i>. (2016).")), 
                                   tags$li(actionLink("forest_disturb_to_stakeholder1",HTML("Stakeholders agreed FORE-SCE products were the best available option for the modeling scenarios."))),
                                   tags$li(HTML("The FORE-SCE gridded resolution (250 m) was incorporated to our modeling framework (1/16<sup>o</sup>, or ~6 km).")),
                                   tags$li(HTML("We used FORE-SCE maps under historical conditions in year 2005 (shown above) to parameterize the Baseline period, and under the SRES A2 scenario from year 2099 for the Far-Future period.")),
                                   
                                   h5(HTML("<b>Forest disturbances:</b>")),
                                   tags$li(HTML("We further adjusted land cover conditions to test the sensitivity of hydrology to forest disturbances, based on"),
                                           actionLink("forest_disturb_to_stakeholder2",HTML("stakeholder interests."))), 
                                   tags$li(HTML("Scenarios included permanent conversion of all forest types at high elevations (≥; 1,800 m) to grasses (e.g., Haffey <i>et al</i>., 2018; Hurteau <i>et al</i>., 2014) by"),
                                           actionLink("forest_disturb_update1","differing percent reductions (10, 30, 60, or 90%).")),
                                   tags$li(HTML("We included the 30% conversion based on historical wildfire extents (Litschert <I>et al</i>., 2012), the 90% amount from estimated forest mortality rates by end-of-21st century (McDowell <i>et al</i>., 2016), and the 10% and 60% amounts given stakeholder preferences for a progressive range of impacts.")),
                                   hr(),
                                   helpText(actionLink("forest_disturb_update2","Click here"),HTML("for the land cover and elevation statistics across the watersheds")),
                                   helpText(actionLink("forest_disturb_update3","Click here"),HTML("for comparisons of forest and grass parameters.")),
                                   helpText(actionLink("forest_disturb_to_watersheds2","Navigate to the 'Watersheds' page"),HTML("for more info on the subbasin and channel delineations.")),
                                   hr(),
                                   helpText(HTML("More info can be found in <a href=\"https://ascelibrary.org/doi/full/10.1061/JWRMD5.WRENG-5905\">Whitney <i>et al</i>. (2023)</a>.")),
                                   style = "primary"),
                   bsCollapsePanel("Assumptions",
                                   # insert assumptions
                                   tags$li(HTML("The current VIC application does not represent the consumptive water uses from the projected urban and agricultural growth and their resulting impacts on the water balance.")),
                                   tags$li(HTML("While such LULC analyses are feasible (e.g., Bohn <i>et al</i>., 2018b; Wang and Vivoni, 2022),"),
                                           actionLink("forest_disturb_to_stakeholder4",HTML("stakeholder interest was focused primarily on forest disturbances."))),
                                   tags$li(HTML("Our modelled scenarios enabled analyses of the hydrologic sensitivity to high impact forest disturbances ("),actionLink("forest_disturb_to_stakeholder3",HTML("as requested by most stakeholders")),
                                           HTML("). These general disturbances are not tied to a specific cause or driver (e.g., wildfire, bark-beetle infestation, or planned thinning), since the likelihood of any individual disturbance type varies across the basin (Seidl <i>et al</i>., 2011).")),
                                   tags$li(HTML("The forest disturbances are also applied immediately in the future and are permanent (do not account for forest recovery and its long-term impact on runoff; e.g., Goeking and Tarboton, 2020).")),
                                   tags$li(HTML("The current VIC application also does not include a fully coupled land-atmosphere system. Thus, the meteorological forcings are not sensitive to the modeled forest disturbances.")),
                                   hr(),
                                   helpText(HTML("More info can be found in <a href=\"https://ascelibrary.org/doi/full/10.1061/JWRMD5.WRENG-5905\">Whitney <i>et al</i>. (2023)</a>.")),
                                   style = "warning"),
                   bsCollapsePanel("References",
                                   h5(HTML("<b>References:</b>")),
                                   tags$ol(
                                     tags$li(htmlOutput("forest_disturb_sleeter_et_al_2012")),
                                     tags$li(htmlOutput("forest_disturb_inegi_2013")),
                                     tags$li(htmlOutput("forest_disturb_usgs_et_al_2016a")),
                                     tags$li(htmlOutput("forest_disturb_lukas_payton_2020")),
                                     tags$li(htmlOutput("forest_disturb_sohl_et_al_2016")),
                                     tags$li(htmlOutput("forest_disturb_haffey_et_al_2018")),
                                     tags$li(htmlOutput("forest_disturb_hurteau_et_al_2014")),
                                     tags$li(htmlOutput("forest_disturb_litschert_et_al_2012")),
                                     tags$li(htmlOutput("forest_disturb_mcdowell_et_al_2016")),
                                     tags$li(htmlOutput("forest_disturb_bohn_et_al_2018b")),
                                     tags$li(htmlOutput("forest_disturb_wang_vivoni_2022")),
                                     tags$li(htmlOutput("forest_disturb_seidl_et_al_2011")),
                                     tags$li(htmlOutput("forest_disturb_goeking_tarboton_2020")),
                                     tags$li(htmlOutput("forest_disturb_whitney_et_al_2023_1"))
                                   ),
                                   style = "info")
        )
      )
    ),
    tabPanel(
      id= "watersheds_table",
      title = "Watershed statistics",
      tags$figure(
        align = "center",
        tags$img(
          src = vic_ex_images$elevation_landcover_table$image_src,
          width = vic_ex_images$elevation_landcover_table$image_width,
          alt = vic_ex_images$elevation_landcover_table$image_alt_text,
          height = vic_ex_images$elevation_landcover_table$image_height
        )
      ),
      # Information Panels
      bsCollapse(id = "elevation_landcover_table_info_panels", 
                 open = "Table Description",
                 bsCollapsePanel("Table Description", 
                                 tags$p(
                                   HTML("Average total forest fraction (<i>C<sub>v</sub></i>) at elevations ≥ 1,800 m across each internal watershed (subbasin) of the basin for the Baseline and Far-Future land cover conditions. Grass values are shown in parentheses. The total land area at elevations ≥ 1,800 m across each subbasin shown in the bottom row.")
                                   ),
                                 style = "default"),
                 bsCollapsePanel("More Info",
                                 helpText(actionLink("forest_disturb_update4","Click here"),HTML("for comparisons of forest and grass parameters.")),
                                 helpText(actionLink("forest_disturb_to_watersheds","Click here"),HTML("for More info on the internal watersheds (subbasins) of the basin.")),
                                 helpText(actionLink("forest_disturb_to_watersheds3","Navigate to the 'Watersheds' page"),HTML("for more info on the subbasin and channel delineations.")),
                                 hr(),
                                 helpText(HTML("More info can be found in <a href=\"https://ascelibrary.org/doi/full/10.1061/JWRMD5.WRENG-5905\">Whitney <i>et al</i>. (2023)</a>.")),
                                 style = "primary")
      )
    ),
    tabPanel(
      id= "parameter_figure_table",
      title = "Forest vs. grass parameters",
      tags$figure(
        align = "center",
        tags$img(
          src = vic_ex_images$parameters_table_figure$image_src,
          width = vic_ex_images$parameters_table_figure$image_width,
          alt = vic_ex_images$parameters_table_figure$image_alt_text,
          height = vic_ex_images$parameters_table_figure$image_height
        )
      ),
      # Information Panels
      bsCollapse(id = "parameter_figure_table_info_panels", 
                 open = "Figure Description",
                 bsCollapsePanel("Figure Description", 
                                 tags$p(
                                   tags$li(HTML("Monthly average values of <b>(a)</b> leaf area index (LAI), <b>(b)</b> albedo (<i>α</i>), and <b>(c)</b> canopy spacing (1- <i>f<sub>v</sub></i>) for forests and grasses, with printed mean annual values. Forest values show the average across all forest types weighted by the cover fractions (<i>C<sub>v</sub></i>).")),
                                   tags$li(HTML("<b>(d)</b> Forest parameter values of root depths and fractions for each soil layer, minimum stomatal resistance, architectural resistance, vegetation roughness length, and vegetation displacement height (grass values in parentheses). Forest values show the average across evergreen, deciduous, and mixed types, weighted by <i>C<sub>v</sub></i>.")),
                                   hr(),
                                   helpText("These represent the most influential vegetation parameters of grass and forest cover.")
                                   # helpText(actionLink("climate_proj_to_watersheds","Click here"),
                                   # HTML("for more info on the basin regions."))
                                 ),
                                 style = "default"),
                 bsCollapsePanel("More Info", 
                                 tags$li(HTML("Parameter values were obtained from the Baseline simulations of Xiao <i>et al</i>. (2022), which include soil and vegetation characteristics from Livneh <i>et al</i>. (2015b).")),
                                 tags$li(HTML("Vegetation fraction (<i>f<sub>v</sub></i>) describes the portion covered by grasses or trees, with bare soil (i.e., canopy spacing, or 1 - <i>f<sub>v</sub></i>) occupying the remainder.")),
                                 tags$li(HTML("Differences in the vegetation parameters (shown in the figure above) between short and tall vegetation affect evapotranspiration components, snow accumulation and ablation, and canopy interception in the model.")),
                                 tags$li(HTML("With higher forest disturbances, the average vegetation parameter values in the high elevation cells shifted towards the grass conditions")),
                                 hr(),
                                 helpText(HTML("More info can be found in <a href=\"https://ascelibrary.org/doi/full/10.1061/JWRMD5.WRENG-5905\">Whitney <i>et al</i>. (2023)</a>.")),
                                 style = "primary"),
                 bsCollapsePanel("References",
                                 h5(HTML("<b>References:</b>")),
                                 tags$ol(
                                   tags$li(htmlOutput("forest_disturb_xiao_et_al_2022")),
                                   tags$li(htmlOutput("forest_disturb_livneh_et_al_2015b")),
                                   tags$li(htmlOutput("forest_disturb_whitney_et_al_2023_2")),
                                 ),
                                 style = "info")
      )
    )
  )
),
## -----------------------------------------Watersheds panel---------------------------------------------## ----
verticalTabPanel(
  title = "Watersheds",
  box_height= 0.1,
  # Content
  fluidRow(
    # Figure
    tags$figure(
      align = "center",
      tags$img(
        src = vic_ex_images$watersheds_channels$image_src,
        width = vic_ex_images$watersheds_channels$image_width,
        alt = vic_ex_images$watersheds_channels$image_alt_text,
        height = vic_ex_images$watersheds_channels$image_height
      )
    ),
    
    # Information Panels
    bsCollapse(id = "watersheds_info_panels", 
               open = "Figure Description",
               bsCollapsePanel("Figure Description", 
                               tags$p(
                                 HTML("<b>(a)</b> Locations of internal watersheds (subbasins)."),
                                 HTML("<b>(b)</b> Channel network with stream orders and source area gage locations."),
                                 HTML("<b>(c)</b> Characterstics of each watershed source area, including:"),
                                 tags$li(HTML("Corresponding USGS gage locations,<sup>2</sup> and operations used to compute streamflows for certain source areas.")),
                                 tags$li(HTML("Total area of each source area in square-kilometers ([km<sup>2</sup>]).")),
                                 tags$li(HTML("Average elevation of each source area in meters above sea level ([m.a.s.l.]).<sup>1</sup>"))
                               ),
                               style = "default"),
               bsCollapsePanel("More Info", 
                               tags$li(HTML("The basin-wide domain encompasses about 630,000 km<sup>2</sup>, with headwaters in the Green River in Wyoming that flow through the river for about 2,253 km to northern México.")),
                               tags$li(actionLink("link_from_watersheds_to_stakeholders1","In consultation with basin water managers,"),
                                       HTML("we performed a model subbasin delineation for the source area above Imperial Dam and the Gila River subbasin in Arizona that yielded eight analysis subbasins (shown above).")),
                               tags$li(HTML("These subbasins correspond to sub-divisions by the USGS.<sup>2,3</sup>")),
                               tags$li(HTML("We used flow directions from the"),
                                       actionLink("link_from_watersheds_to_forest_disturbance_elevations","30 m National Elevation Dataset"),
                                       HTML(", USGS gaging stations, and Hydrologic Unit Codes as guides for subbasin and channel network delineation.<sup>1-3</sup>")
                               ),
                               tags$li(HTML("Three subbasins (Glen Canyon, Grand Canyon, and Lower Colorado) were defined as those areas draining to reaches between up- and down- stream gages and thus have streamflow values obtained by differencing (see subplot c above).")),
                               hr(),
                               helpText(
                                 actionLink("link_from_watersheds_to_forest_disturbances_watershed_stats","Click here"),
                                 HTML("for statistics of forest cover parameters over each watershed.")
                               ),
                               hr(),
                               helpText(HTML("More info can be found in <a href=\"https://ascelibrary.org/doi/full/10.1061/JWRMD5.WRENG-5905\">Whitney <i>et al</i>. (2023)</a>.")),
                               style = "primary"),
               # bsCollapsePanel("Assumptions", 
               #                 # insert assumptions
               #                 style = "warning"),
               bsCollapsePanel("References",
                               h5(HTML("<b>References:</b>")),
                               tags$ol(
                                 tags$li(htmlOutput("watersheds_usgs_et_al_2016a")), 
                                 tags$li(htmlOutput("watersheds_usgs_et_al_2016b")),
                                 tags$li(htmlOutput("watersheds_usgs_et_al_2019")),
                                 tags$li(htmlOutput("watersheds_whitney_et_al_2023"))
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
    br(),
    tags$figure(
      align = "center",
      tags$img(
        src = vic_ex_images$stakeholders$image_src,
        width = vic_ex_images$stakeholders$image_width,
        alt = vic_ex_images$stakeholders$image_alt_text,
        height = vic_ex_images$stakeholders$image_height
      )
    ),
    br(),
    # Information Panels
    bsCollapse(id = "stakeholder_engagement_info_panels", 
               open = "Figure Description",
               bsCollapsePanel("Figure Description", 
                               tags$p(
                                 HTML("To achieve applicable, comprehensive, timely, and accessible research for water resource decision-making,<sup>1,2</sup>"),
                                 HTML("we incorporated feedback from five “collaborative science, modelling, and decision” groups (or CoMods) comprised of water managers across the CRB (27 individuals from 13 agencies; "),
                                 actionLink("stakeholder_update1","listed in 'More Info' below"),
                                 HTML(") during each stage of our scenario development and appraisal process (shown in the figure above)."),
                                 HTML("Documentation of this process and resulting model approach is provided in the panel menu on the left, and briefly summarized"),
                                 actionLink("stakeholder_update2","in 'More Info' below"),
                                 HTML(".")
                               ),
                               style = "default"),
               bsCollapsePanel("More Info", 
                               tags$p(
                                 HTML("Each stage of our model scenario development and visualization process was informed by (ii) iterative feedback from water managers and other basin stakeholders (listed below),"),
                                 HTML("including evaluations of (i) the"),
                                 actionLink("stakeholder_to_climate_proj1","climate model futures to select bookends"),
                                 HTML(", (iii) the VIC simulated outcomes under the climate bookends when"),
                                 actionLink("stakeholder_to_forest_disturbance1","parameters were updated with FORE-SCE products,"),
                                 HTML("(iv) the VIC simulated outcomes under the climate bookends with"),
                                 actionLink("stakeholder_to_forest_disturbance2","alternative forest disturbances,"),
                                 HTML("(v) the decision-relevant analyses from the model framework (detailed below),"),
                                 HTML("and (vi) development of this CRB-Scenario-Explorer web-tool (detailed below).")
                               ),
                               hr(),
                               h5(HTML("<b>Stakeholder Agencies:</b>")),
                               tags$li("Arizona Department of Water Resources"),
                               tags$li("Central Arizona Project"),
                               tags$li("Colorado Department of Natural Resources"),
                               tags$li("Colorado River Board of California"),
                               tags$li("Colorado River District"),
                               tags$li("Colorado Water Conservation Board"),
                               tags$li("Denver Water"),
                               tags$li("Metropolitan Water District of Southern California"),
                               tags$li("New Mexico Interstate Stream Commission"),
                               tags$li("Southern Nevada Water Authority"),
                               tags$li("Upper Colorado River Commission"),
                               tags$li("U.S. Bureau of Reclamation"),
                               tags$li("Wyoming State Engineer’s Office"),
                               hr(),
                               h5(HTML("<b>Stakeholder reflections on scenario outcomes:</b>")),
                               HTML("When presented with scenario outcomes, stakeholders agreed that the results were “very timely”, accessible, and applicable for water resource decisions due to their involvement during our model design and implementation process. Stakeholders also indicated that our findings could be useful for policy discourse around forest management and wildfire impacts when seeking water security, especially if provided in a transparent way that clarifies how the model works and the limitations of the approach, as well as its abilities to visualize surface water impacts. We developed the CRB-Scenario-Explorer tool to meet this need, designed according to this feedback."),
                               hr(),
                               h5(HTML("<b>Stakeholder reflections on the CRB-Scenario-Explorer web-tool:</b>")),
                               HTML("We shared CRB-Scenario-Explorer with our stakeholders and held a final meeting to evaluate their user-experience and incorporate their recommendations to improve the tool. Feedback on the web-based tool included recommendations to expand the availability of model variables and re-organize layouts. We implemented these suggestions into the final CRB-Scenario-Explorer design. Participants confirmed that the documentation pages are “thorough,” “nicely organized” (i.e., easy-to-find and accessible), and sufficient for understanding the scenario construction process and the results in relation to parameter representation and assumptions.<br><br>When asked to reflect on the efficacy of the freeform and guided assessments at various scales offered by the tool, stakeholders agreed that: “The hybrid approach provides a great balance for understanding the modelling scenarios.” Similarly, it was noted that the web-based tool and underlying research “most certainly answers the question on forest disturbance impacts and how those impacts affect different water resource metrics.” Stakeholders also found it useful to switch between hybrid analysis modes to meet their needs, indicating for example, that visualizations showing Upper and Lower Basin streamflow in million-acre feet (MAF) “are in line with how we and other stakeholders assess water resources across the basin.”<br><br>Participants noted that the analysis interfaces can be used for briefing and reporting to board members and other executive leaders about the potential impacts from climate change and forest reduction scenarios. Stakeholders can also utilize the documentation pages to clarify the model framework capabilities and limitations."),
                               hr(),
                               helpText(HTML("More info can be found in <a href=\"https://ascelibrary.org/doi/full/10.1061/JWRMD5.WRENG-5905\">Whitney <i>et al</i>. (2023)</a>.")),
                               style = "primary"),
               # bsCollapsePanel("Assumptions", 
               #                 # insert assumptions
               #                 style = "warning"),
               bsCollapsePanel("References",
                               h5(HTML("<b>References:</b>")),
                               tags$ol(
                                 tags$li(htmlOutput("stakeholder_white_et_al_2010")),
                                 tags$li(htmlOutput("stakeholder_dunn_laing_2017")),
                                 tags$li(htmlOutput("stakeholder_whitney_et_al_2023"))
                               ),
                               style = "info")
    )
  )
) 
) # End of verticalTabsetPanel
) # end of column
) # end of fluidRow
) # end of Model Info tabPanel
) # End of More Info ----
)

