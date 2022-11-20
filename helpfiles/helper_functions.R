## --------------------------------------------------------------------------------------##
##
## Script name: helper_functions.R
##
## Purpose of the script: Creates helper functions for the VIC-Explorer website.
##
## @author: Kristen Whitney
##
## Created on Mon Oct 4, 2022
##
## Copyright (c) Arizona State University, 2022
## Email: kmwhitne@asu.edu
##
## --------------------------------------------------------------------------------------##
##    Notes:
##    More information on this to come. 
##
## --------------------------------------------------------------------------------------##
## ----------------------------------Load packages---------------------------------------##


## --------------------------Mean annual value (barchart) plots---------------------------------## ----
# create horizontal reference line function
hline <- function(y = 0,x=0, color = "black") {
  list(
    type = "line",
    x0 = 0+x,
    x1 = 0.4+x,
    xref = "paper",
    y0 = y,
    y1 = y,
    line = list(color = color, dash="dot")
  )
}

# bar plot function
plot_mean_ann_val_barplot <-function(plot_input_list){
  
  # unpack list of input arguments
  basins_selected<-plot_input_list$basins_selected
  vars_selected<-plot_input_list$vars_selected
  input_data<-plot_input_list$input_data
  time_plot<-c("Baseline","Period_3")
  
  
  # get y labels
  y_labels <- vector(mode="character",length=2)
  for (i in 1:2){
    if (var_info_dict[[plot_input_list$vars_selected[[i]]]]$flux_type) {
      y_labels[i] = paste("<i>",var_info_dict[[plot_input_list$vars_selected[[i]]]]$plot_var_str,"</i> [",var_info_dict[[plot_input_list$vars_selected[[i]]]]$units," yr<sup>-1</sup>]",sep="")
    } else {
      y_labels[i] = paste("<i>",var_info_dict[[plot_input_list$vars_selected[[i]]]]$plot_var_str,"</i> [",var_info_dict[[plot_input_list$vars_selected[[i]]]]$units,"]",sep="")
    }
  }
  
  # change climate names
  input_data <- input_data %>% 
    mutate(climate = dplyr::recode(climate, `Warm_Wet`="Warm/Wet", `Hot_Dry`="Hot/Dry"))
  
  # get x axis order
  xform <- list(categoryorder = "array",
                categoryarray = c("Warm/Wet", 
                                  "Hot/Dry"),
                title = "Climate Scenario"
  )
  
  # get annotations
  annotations = list( 
    list( 
      x = 0.25,  
      y = 1.01,  
      text = paste("<b>",basin_dict[[basins_selected[[1]]]]$full_name,"</b>"),  
      xref = "paper",  
      yref = "paper",  
      xanchor = "center",  
      yanchor = "bottom",  
      showarrow = FALSE 
    ),  
    list( 
      x = 0.75,  
      y = 1.01,  
      text = paste("<b>",basin_dict[[basins_selected[[2]]]]$full_name,"</b>"),  
      xref = "paper",  
      yref = "paper",  
      xanchor = "center",  
      yanchor = "bottom",  
      showarrow = FALSE 
    ),
      # list( 
      #   x = 0.005,  
      #   y = 0.945,  
      #   # text = paste("<b>(a)",var_info_dict[[vars_selected[[1]]]]$subplot_label,"</b>"),  
      #   text = "<b>(a)</b>", 
      #   xref = "paper",  
      #   yref = "paper",  
      #   xanchor = "left",  
      #   yanchor = "bottom",  
      #   showarrow = FALSE 
      # ),  
      # list( 
      #   x = 0.005,  
      #   y = 0.42,  
      #   # text = paste("<b>(b)",var_info_dict[[vars_selected[[2]]]]$subplot_label,"</b>"),  
      #   text = "<b>(b)</b>",  
      #   xref = "paper",  
      #   yref = "paper",  
      #   xanchor = "left",  
      #   yanchor = "bottom",  
      #   showarrow = FALSE 
      # ),
      # 
    
    
      list(
        x = 1.04,
        y= 0.07,
        text = paste("<b>Subplot key:</b><br><b>(top)</b>",var_info_dict[[vars_selected[[1]]]]$subplot_label,
                     "<br><b>(bottom)</b>",var_info_dict[[vars_selected[[2]]]]$subplot_label,
                     "<br><b>(left)</b>",basin_dict[[basins_selected[[1]]]]$full_name,
                     "<br><b>(right)</b>",basin_dict[[basins_selected[[2]]]]$full_name),
        font = list(size = 12),
        xref = "paper",  
        yref = "paper", 
        xanchor = "left",
        yanchor = "bottom",
        align = "left",
        showarrow = FALSE
      )
    )
  
  # get dataset for subplot 1 (basin 1, var 1)
  b1v1_data <- input_data %>%
    filter((basin_name %in% basin_dict[[basins_selected[[1]]]]$stored_name),(time %in% time_plot)) %>%
    # filter(!((time == "Period_3")&(lulc =="hist_0perc"))) %>%
    dplyr::select(time,{var_info_dict[[vars_selected[[1]]]]$stored_name},climate,lulc)     %>%
    pivot_wider(
      names_from = c(time,lulc),
      values_from = var_info_dict[[vars_selected[[1]]]]$stored_name,
      names_sep = "_"
    )
  
  # get dataset for subplot 2 (basin 1, var 2)
  b1v2_data <- input_data %>%
    filter((basin_name %in% basin_dict[[basins_selected[[1]]]]$stored_name),(time %in% time_plot)) %>%
    # filter(!((time == "Period_3")&(lulc =="hist_0perc"))) %>%
    dplyr::select(time,{var_info_dict[[vars_selected[[2]]]]$stored_name},climate,lulc)     %>%
    pivot_wider(
      names_from = c(time,lulc),
      values_from = var_info_dict[[vars_selected[[2]]]]$stored_name,
      names_sep = "_"
    )
  
  # get dataset for subplot 3 (basin 2, var 1)
  b2v1_data <- input_data %>%
    filter((basin_name %in% basin_dict[[basins_selected[[2]]]]$stored_name),(time %in% time_plot)) %>%
    # filter(!((time == "Period_3")&(lulc =="hist_0perc"))) %>%
    dplyr::select(time,{var_info_dict[[vars_selected[[1]]]]$stored_name},climate,lulc)     %>%
    pivot_wider(
      names_from = c(time,lulc),
      values_from = var_info_dict[[vars_selected[[1]]]]$stored_name,
      names_sep = "_"
    )
  
  # get dataset for subplot 4 (basin 2, var 2)
  b2v2_data <- input_data %>%
    filter((basin_name %in% basin_dict[[basins_selected[[2]]]]$stored_name),(time %in% time_plot)) %>%
    # filter(!((time == "Period_3")&(lulc =="hist_0perc"))) %>%
    dplyr::select(time,{var_info_dict[[vars_selected[[2]]]]$stored_name},climate,lulc)     %>%
    pivot_wider(
      names_from = c(time,lulc),
      values_from = var_info_dict[[vars_selected[[2]]]]$stored_name,
      names_sep = "_"
    )
  
  
  # create subplot 1
  b1v1 <-plot_ly(b1v1_data,x=~climate,y=~Baseline_hist_0perc,type='bar',name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Baseline_hist_0perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Baseline_hist_0perc,legendgroup='Baseline_hist_0perc',hovertemplate="%{y:.4f}")
  b1v1 <- b1v1 %>% add_trace(y=~Period_3_hist_0perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_hist_0perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_hist_0perc,legendgroup='Period_3_hist_0perc',hovertemplate="%{y:.4f}")
  b1v1 <- b1v1 %>% add_trace(y=~Period_3_a2_0perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_0perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_0perc,legendgroup='Period_3_a2_0perc',hovertemplate="%{y:.4f}")
  b1v1 <- b1v1 %>% add_trace(y=~Period_3_a2_10perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_10perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_10perc,legendgroup='Period_3_a2_10perc',hovertemplate="%{y:.4f}")
  b1v1 <- b1v1 %>% add_trace(y=~Period_3_a2_30perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_30perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_30perc,legendgroup='Period_3_a2_30perc',hovertemplate="%{y:.4f}")
  b1v1 <- b1v1 %>% add_trace(y=~Period_3_a2_60perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_60perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_60perc,legendgroup='Period_3_a2_60perc',hovertemplate="%{y:.4f}")
  b1v1 <- b1v1 %>% add_trace(y=~Period_3_a2_90perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_90perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_90perc,legendgroup='Period_3_a2_90perc',hovertemplate="%{y:.4f}")
  b1v1 <- b1v1 %>% layout(yaxis=list(title=y_labels[1]),xaxis=xform,barmode='group')
  # b1v1 <- b1v1 %>% add_trace(b1v1_data,x=~climate,y=~reflines,type='scatter',mode='lines',name='Baseline')
  # b1v1 <- b1v1 %>% layout(shapes=list())
  b1v1 <- b1v1 %>% layout(shapes=list(hline(y=b1v1_data$Baseline_hist_0perc[1],x=0.05),
                                      hline(y=b1v1_data$Baseline_hist_0perc[2],x=.55),
                                      list(type = "rect",
                                           fillcolor = "none", 
                                           line = list(color = "black",width=0.75), 
                                           # opacity = 0.3,
                                           x0 = 0, x1 = 1,
                                           xref = "paper",
                                           y0 = 0,
                                           y1 = 1.015,
                                           yref = "paper")
                                      )
                          )
  
  # create subplot 2
  b1v2 <-plot_ly(b1v2_data,x=~climate,y=~Baseline_hist_0perc,type='bar',name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Baseline_hist_0perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Baseline_hist_0perc,legendgroup='Baseline_hist_0perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b1v2 <- b1v2 %>% add_trace(y=~Period_3_hist_0perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_hist_0perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_hist_0perc,legendgroup='Period_3_hist_0perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b1v2 <- b1v2 %>% add_trace(y=~Period_3_a2_0perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_0perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_0perc,legendgroup='Period_3_a2_0perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b1v2 <- b1v2 %>% add_trace(y=~Period_3_a2_10perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_10perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_10perc,legendgroup='Period_3_a2_10perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b1v2 <- b1v2 %>% add_trace(y=~Period_3_a2_30perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_30perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_30perc,legendgroup='Period_3_a2_30perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b1v2 <- b1v2 %>% add_trace(y=~Period_3_a2_60perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_60perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_60perc,legendgroup='Period_3_a2_60perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b1v2 <- b1v2 %>% add_trace(y=~Period_3_a2_90perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_90perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_90perc,legendgroup='Period_3_a2_90perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b1v2 <- b1v2 %>% layout(yaxis=list(title=y_labels[2]),xaxis=xform,barmode='group',showlegend = FALSE)
  # b1v2 <- b1v2 %>% add_trace(b1v2_data,x=~climate,y=~reflines,type='scatter',mode='lines',name='Baseline')
  # b1v2 <- b1v2 %>% layout(shapes=list())
  b1v2 <- b1v2 %>% layout(shapes=list(hline(y=b1v2_data$Baseline_hist_0perc[1],x=0.05),
                                      hline(y=b1v2_data$Baseline_hist_0perc[2],x=.55),
                                      list(type = "rect",
                                           fillcolor = "none", 
                                           line = list(color = "black",width=0.75), 
                                           # opacity = 0.3,
                                           x0 = 0, x1 = 1,
                                           xref = "paper",
                                           y0 = 0,
                                           y1 = 1.015,
                                           yref = "paper")
                                      )
                          )
  
  # create subplot 3
  b2v1 <-plot_ly(b2v1_data,x=~climate,y=~Baseline_hist_0perc,type='bar',name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Baseline_hist_0perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Baseline_hist_0perc,legendgroup='Baseline_hist_0perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b2v1 <- b2v1 %>% add_trace(y=~Period_3_hist_0perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_hist_0perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_hist_0perc,legendgroup='Period_3_hist_0perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b2v1 <- b2v1 %>% add_trace(y=~Period_3_a2_0perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_0perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_0perc,legendgroup='Period_3_a2_0perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b2v1 <- b2v1 %>% add_trace(y=~Period_3_a2_10perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_10perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_10perc,legendgroup='Period_3_a2_10perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b2v1 <- b2v1 %>% add_trace(y=~Period_3_a2_30perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_30perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_30perc,legendgroup='Period_3_a2_30perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b2v1 <- b2v1 %>% add_trace(y=~Period_3_a2_60perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_60perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_60perc,legendgroup='Period_3_a2_60perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b2v1 <- b2v1 %>% add_trace(y=~Period_3_a2_90perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_90perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_90perc,legendgroup='Period_3_a2_90perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b2v1 <- b2v1 %>% layout(yaxis=list(title=y_labels[1]),xaxis=xform,barmode='group',showlegend = FALSE)
  # b2v1 <- b2v1 %>% add_trace(b2v1_data,x=~climate,y=~reflines,type='scatter',mode='lines',name='Baseline')
  # b2v1 <- b2v1 %>% layout(shapes=list())
  b2v1 <- b2v1 %>% layout(shapes=list(hline(y=b2v1_data$Baseline_hist_0perc[1],x=0.05),
                                      hline(y=b2v1_data$Baseline_hist_0perc[2],x=.55),
                                      list(type = "rect",
                                           fillcolor = "none", 
                                           line = list(color = "black",width=0.75), 
                                           # opacity = 0.3,
                                           x0 = 0, x1 = 1,
                                           xref = "paper",
                                           y0 = 0,
                                           y1 = 1.015,
                                           yref = "paper")
                                      )
                          )
  
  # create subplot 4
  b2v2 <-plot_ly(b2v2_data,x=~climate,y=~Baseline_hist_0perc,type='bar',name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Baseline_hist_0perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Baseline_hist_0perc,legendgroup='Baseline_hist_0perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b2v2 <- b2v2 %>% add_trace(y=~Period_3_hist_0perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_hist_0perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_hist_0perc,legendgroup='Period_3_hist_0perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b2v2 <- b2v2 %>% add_trace(y=~Period_3_a2_0perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_0perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_0perc,legendgroup='Period_3_a2_0perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b2v2 <- b2v2 %>% add_trace(y=~Period_3_a2_10perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_10perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_10perc,legendgroup='Period_3_a2_10perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b2v2 <- b2v2 %>% add_trace(y=~Period_3_a2_30perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_30perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_30perc,legendgroup='Period_3_a2_30perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b2v2 <- b2v2 %>% add_trace(y=~Period_3_a2_60perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_60perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_60perc,legendgroup='Period_3_a2_60perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b2v2 <- b2v2 %>% add_trace(y=~Period_3_a2_90perc,name=plot_specs_wat_ann_barchart$scenario_legendgroup_names$Period_3_a2_90perc,marker=plot_specs_wat_ann_barchart$scenario_marker_specs$Period_3_a2_90perc,legendgroup='Period_3_a2_90perc',showlegend = FALSE,hovertemplate="%{y:.4f}")
  b2v2 <- b2v2 %>% layout(yaxis=list(title=y_labels[1]),xaxis=xform,barmode='group',showlegend = FALSE)
  # b2v2 <- b2v2 %>% add_trace(b2v2_data,x=~climate,y=~reflines,type='scatter',mode='lines',name='Baseline')
  # b2v2 <- b2v2 %>% layout(shapes=list())
  b2v2 <- b2v2 %>% layout(shapes=list(hline(y=b2v2_data$Baseline_hist_0perc[1],x=0.05),
                                      hline(y=b2v2_data$Baseline_hist_0perc[2],x=.55),
                                      list(type = "rect",
                                           fillcolor = "none", 
                                           line = list(color = "black",width=0.75), 
                                           # opacity = 0.3,
                                           x0 = 0, x1 = 1,
                                           xref = "paper",
                                           y0 = 0,
                                           y1 = 1.015,
                                           yref = "paper")
                                      )
                          )
  
  fig <- subplot(b1v1,b2v1,b1v2,b2v2,shareY = T,shareX=T,nrows=2) %>% layout(showlegend = TRUE,
                                                                    annotations=annotations
                                                                    )
  
  return(fig)
}

## --------------------------Mean annual anomaly (scatter/line) plots---------------------------------## ----

# scatter/line plot function
plot_mean_ann_anomaly_lineplot <-function(plot_input_list){
  
  # unpack list of input arguments
  basins_selected<-plot_input_list$basins_selected
  vars_selected<-plot_input_list$vars_selected
  input_data<-plot_input_list$input_data
  plot_type<- plot_input_list$plot_type
  # wat_ann_center_on_zero<-plot_input_list$wat_ann_center_on_zero
  time_plot<-c("Baseline","Period_3")
  
  
  # get y labels and subplot titles
  y_labels <- vector(mode="character",length=2)
  basins_selected_stored <- vector(mode="character",length=2)
  vars_selected_stored <- vector(mode="character",length=2)
  for (i in 1:2){
    # y labels
    if (var_info_dict[[plot_input_list$vars_selected[[i]]]]$changes_as_a_percentage) {
      if (plot_type=="relative") {
        y_labels[i] = paste("<i>\u0394",var_info_dict[[plot_input_list$vars_selected[[i]]]]$plot_var_str,"</i> [%]",sep="")
      } else {
        y_labels[i] = paste("<i>\u0394",var_info_dict[[plot_input_list$vars_selected[[i]]]]$plot_var_str,"</i> [",var_info_dict[[plot_input_list$vars_selected[[i]]]]$units," yr<sup>-1</sup>]",sep="")
      }
      
    } else {
      y_labels[i] = paste("<i>\u0394",var_info_dict[[plot_input_list$vars_selected[[i]]]]$plot_var_str,"</i> [",var_info_dict[[plot_input_list$vars_selected[[i]]]]$units,"]",sep="")
    }
    
    # stored names
    basins_selected_stored[i] <- basin_dict[[basins_selected[[i]]]]$stored_name
    vars_selected_stored[i] <- var_info_dict[[vars_selected[[i]]]]$stored_name
  }
  
  # set xlabel
  x_label = "High-elevation forest disturbance amount"
  
  
  # # change climate names
  # input_data <- input_data %>% 
  #   mutate(climate = dplyr::recode(climate, `Warm_Wet`="Warm/Wet", `Hot_Dry`="Hot/Dry"))
  
  # get x axis order
  xform <- list(categoryorder = "array",
                categoryarray = c("Warm/Wet", 
                                  "Hot/Dry")
  )
  

  # Get annotations
  annotations = list(
    # list( 
    #   x = 0.005,  
    #   y = 0.945,  
    #   # text = paste("<b>(a)",var_info_dict[[vars_selected[[1]]]]$subplot_label,"</b>"),  
    #   text = "<b>(a)</b>", 
    #   xref = "paper",  
    #   yref = "paper",  
    #   xanchor = "left",  
    #   yanchor = "bottom",  
    #   showarrow = FALSE 
    # ),  
    # list( 
    #   x = 0.005,  
    #   y = 0.42,  
    #   # text = paste("<b>(b)",var_info_dict[[vars_selected[[2]]]]$subplot_label,"</b>"),  
    #   text = "<b>(b)</b>",  
    #   xref = "paper",  
    #   yref = "paper",  
    #   xanchor = "left",  
    #   yanchor = "bottom",  
    #   showarrow = FALSE 
    # ),
    list(
      x = 1.017,
      y= 0.2,
      text = paste("<i>Changes (\u0394) equal to (greater<br>than) zero imply a recovery of <br>(exceeding) Baseline amounts.</i>",
                   "<br><br><b>Subplot key:</b><br><b>(top)</b>",var_info_dict[[vars_selected[[1]]]]$subplot_label,
                   "<br><b>(bottom)</b>",var_info_dict[[vars_selected[[2]]]]$subplot_label),
      font = list(size = 11),
      xref = "paper",  
      yref = "paper", 
      xanchor = "left",
      yanchor = "bottom",
      align = "left",
      showarrow = FALSE
    )
  )
  
  # get data
  data_plot <- input_data %>%
    filter((basin_name %in% basins_selected_stored),(time %in% time_plot)) %>%
    filter(!((time == "Period_3")&(lulc =="hist_0perc"))) %>% 
    mutate(lulc = dplyr::recode(lulc, `a2_0perc`=10, `a2_10perc`=20,`a2_30perc`=40,`a2_60perc`=70,`a2_90perc`=100)) %>%
    dplyr::select(basin_name,{vars_selected_stored},climate,lulc) 
  
  # rename basins and variables generic values
  data_plot$basin_name[data_plot$basin_name==basins_selected_stored[1]] = "b1"
  data_plot$basin_name[data_plot$basin_name==basins_selected_stored[2]] = "b2"
  data_plot$v1 = data_plot[[vars_selected_stored[1]]]
  data_plot$v2 = data_plot[[vars_selected_stored[2]]]
  
  # # get global min/max values for each variable
  # v1_min<-floor(min(data_plot$v1))
  # v1_max<-ceiling(max(data_plot$v1))
  # v2_min<-floor(min(data_plot$v2))
  # v2_max<-ceiling(max(data_plot$v2))
  # if ((v1_min<0) & (v1_max>0)) {
  #   v1_range <- list(-1*max(abs(v1_min),abs(v1_max)),max(abs(v1_min),abs(v1_max)))
  # } else if (v1_min<0){
  #   v1_range <- list(v1_min,0)
  # } else if (v1_max>0){
  #   v1_range <- list(0,v1_max)
  # }
  # 
  # if ((v2_min<0) & (v2_max>0)) {
  #   v2_range <- list(-1*max(abs(v2_min),abs(v2_max)),max(abs(v2_min),abs(v2_max)))
  # } else if (v2_min<0){
  #   v2_range <- list(v2_min,0)
  # } else if (v2_max>0){
  #   v2_range <- list(0,v2_max)
  # }
  
  
  # pivot to wider
  data_plot<- data_plot %>% dplyr::select(-{vars_selected_stored}) %>%
    pivot_wider(
      names_from = c(basin_name,climate),
      values_from = c(v1,v2),
      names_sep = "_"
      
    )
  if (identical(basins_selected[1],basins_selected[2])) {
    plot_b2 = FALSE
  } else{
    plot_b2 = TRUE
  }
  
  
  # create subplot 1 (variable 1)
  p_v1 <- plot_ly(data_plot,x=~lulc,y=~v1_b1_Warm_Wet,name=paste(basin_dict[[basins_selected[[1]]]]$full_name,"(Warm/Wet)"),type='scatter',mode='lines+markers',legendgroup='b1_Warm_Wet',marker=plot_specs_wat_ann_change_line$marker_specs$b1_Warm_Wet,line=plot_specs_wat_ann_change_line$line_specs$b1_Warm_Wet,hovertemplate="%{y:.4f}") %>%
    add_trace(data_plot,x=~lulc,y=~v1_b1_Hot_Dry,name=paste(basin_dict[[basins_selected[[1]]]]$full_name,"(Hot/Dry)"),type='scatter',mode='lines+markers',legendgroup='b1_Hot_Dry',marker=plot_specs_wat_ann_change_line$marker_specs$b1_Hot_Dry,line=plot_specs_wat_ann_change_line$line_specs$b1_Hot_Dry,hovertemplate="%{y:.4f}")
  if (plot_b2) {
    p_v1 <- p_v1 %>% add_trace(data_plot,x=~lulc,y=~v1_b2_Warm_Wet,name=paste(basin_dict[[basins_selected[[2]]]]$full_name,"(Warm/Wet)"),type='scatter',mode='lines+markers',legendgroup='b2_Warm_Wet',marker=plot_specs_wat_ann_change_line$marker_specs$b2_Warm_Wet,line=plot_specs_wat_ann_change_line$line_specs$b2_Warm_Wet,hovertemplate="%{y:.4f}") %>%
      add_trace(data_plot,x=~lulc,y=~v1_b2_Hot_Dry,name=paste(basin_dict[[basins_selected[[2]]]]$full_name,"(Hot/Dry)"),type='scatter',mode='lines+markers',legendgroup='b2_Hot_Dry',marker=plot_specs_wat_ann_change_line$marker_specs$b2_Hot_Dry,line=plot_specs_wat_ann_change_line$line_specs$b2_Hot_Dry,hovertemplate="%{y:.4f}") 
  }
    p_v1 <- p_v1 %>% layout(yaxis=list(title=y_labels[1],
                      tickformat="+",
                      ticklen = 7,
                      ticks = "outside"),
           xaxis=list(title=x_label,
                      tickvals=list(10,20,40,70,100),
                      ticktext=list("0%","10%","30%","60%","90%"),
                      ticklen = 7,
                      ticks = "outside",
                      range=list(0,110)),
           shapes = list(
             list(type = "rect",
                  fillcolor = "none", line = list(color = "black",width=0.75), 
                  # opacity = 0.3,
                  x0 = 0, x1 = 1, xref = "paper",
                  y0 = 0, y1 = 1, yref = "paper")
           )
           #   list(type = "line",
           #        fillcolor = "none", line = list(color = "black",width=0.75), 
           #        # opacity = 0.3,
           #        x0 = 0, x1 = 1, xref = "paper",
           #        y0 = 0, y1 = 0, yref = "paper")
           # )
    )
  
  
  # create subplot 2 (variable 2)
  p_v2 <- plot_ly(data_plot,x=~lulc,y=~v2_b1_Warm_Wet,name=paste(basin_dict[[basins_selected[[1]]]]$full_name,"(Warm/Wet)"),type='scatter',mode='lines+markers',legendgroup='b1_Warm_Wet',marker=plot_specs_wat_ann_change_line$marker_specs$b1_Warm_Wet,line=plot_specs_wat_ann_change_line$line_specs$b1_Warm_Wet,showlegend=FALSE,hovertemplate="%{y:.4f}") %>%
    add_trace(data_plot,x=~lulc,y=~v2_b1_Hot_Dry,name=paste(basin_dict[[basins_selected[[1]]]]$full_name,"(Hot/Dry)"),type='scatter',mode='lines+markers',legendgroup='b1_Hot_Dry',marker=plot_specs_wat_ann_change_line$marker_specs$b1_Hot_Dry,line=plot_specs_wat_ann_change_line$line_specs$b1_Hot_Dry,showlegend=FALSE,hovertemplate="%{y:.4f}")
  if (plot_b2) {
    p_v2 <- p_v2 %>% add_trace(data_plot,x=~lulc,y=~v2_b2_Warm_Wet,name=paste(basin_dict[[basins_selected[[2]]]]$full_name,"(Warm/Wet)"),type='scatter',mode='lines+markers',legendgroup='b2_Warm_Wet',marker=plot_specs_wat_ann_change_line$marker_specs$b2_Warm_Wet,line=plot_specs_wat_ann_change_line$line_specs$b2_Warm_Wet,showlegend=FALSE,hovertemplate="%{y:.4f}") %>%
      add_trace(data_plot,x=~lulc,y=~v2_b2_Hot_Dry,name=paste(basin_dict[[basins_selected[[2]]]]$full_name,"(Hot/Dry)"),type='scatter',mode='lines+markers',legendgroup='b2_Hot_Dry',marker=plot_specs_wat_ann_change_line$marker_specs$b2_Hot_Dry,line=plot_specs_wat_ann_change_line$line_specs$b2_Hot_Dry,showlegend=FALSE,hovertemplate="%{y:.4f}")
  }
  p_v2 <- p_v2 %>% layout(yaxis=list(title=y_labels[2],
                      tickformat="+",
                      ticklen = 7,
                      ticks = "outside"),
           xaxis=list(title=x_label,
                      tickvals=list(10,20,40,70,100),
                      ticktext=list("0%","10%","30%","60%","90%"),
                      ticklen = 7,
                      ticks = "outside",
                      range=list(0,110)),
           shapes = list(
             list(type = "rect",
                  fillcolor = "none", line = list(color = "black",width=0.75), 
                  # opacity = 0.3,
                  x0 = 0, x1 = 1, xref = "paper",
                  y0 = 0, y1 = 1, yref = "paper")
           )
    )
  
  # # center on zero line
  # if(wat_ann_center_on_zero) {
  #   p_v1<- p_v1 %>% layout(yaxis=list(range=v1_range))
  #   p_v2<- p_v2 %>% layout(yaxis=list(range=v2_range))
  #   
  # }
  
  # create final figure
  fig <- subplot(p_v1,p_v2,shareX = T,nrows=2,titleY=TRUE) %>% layout(
    showlegend=TRUE,
    annotations=annotations
  )
  
  # fig <- subplot(p1,p3,p2,p4,shareY = T,nrows=2) %>% layout(showlegend = TRUE,annotations=subplot_annotations)
  
  return(fig)
}

## --------------------------Mean monthly (scatter/line) plots---------------------------------## ----

# scatter/line plot function
plot_mean_mmon_lineplot <-function(plot_input_list){
  
  # unpack list of input arguments
  basin_selected<-plot_input_list$basin_selected
  vars_selected<-plot_input_list$vars_selected
  input_data<-plot_input_list$input_data
  # wat_mon_center_on_zero<-plot_input_list$wat_mon_center_on_zero
  time_plot<-c("Baseline","Period_3")
  
  
  # get y labels and subplot titles
  y_labels <- vector(mode="character",length=length(vars_selected))
  basin_selected_stored <- basin_dict[[basin_selected]]$stored_name
  vars_selected_stored <- vector(mode="character",length=length(vars_selected))
  for (i in 1:length(vars_selected)){
    # y labels
    if (var_info_dict[[plot_input_list$vars_selected[[i]]]]$flux_type) {
      y_labels[i] = paste("<i>",var_info_dict[[plot_input_list$vars_selected[[i]]]]$plot_var_str,"</i> [",var_info_dict[[plot_input_list$vars_selected[[i]]]]$units," yr<sup>-1</sup>]",sep="")
    } else {
      y_labels[i] = paste("<i>",var_info_dict[[plot_input_list$vars_selected[[i]]]]$plot_var_str,"</i> [",var_info_dict[[plot_input_list$vars_selected[[i]]]]$units,"]",sep="")
    }
    
    # stored names
    vars_selected_stored[i] <- var_info_dict[[vars_selected[[i]]]]$stored_name
  }
  
  # set xlabel
  x_label = "Month"
  
  
  # # change climate names
  # input_data <- input_data %>% 
  #   mutate(climate = dplyr::recode(climate, `Warm_Wet`="Warm/Wet", `Hot_Dry`="Hot/Dry"))
  
  
  
  # get subplot name annotations
  annotations = list( 
    list( 
      x = 0.25,  
      y = 1.01,  
      text = paste("<b>Warm/Wet</b>"),  
      xref = "paper",  
      yref = "paper",  
      xanchor = "center",  
      yanchor = "bottom",  
      showarrow = FALSE 
    ),  
    list( 
      x = 0.75,  
      y = 1.01,  
      text = paste("<b>Hot/Dry</b>"),  
      xref = "paper",  
      yref = "paper",  
      xanchor = "center",  
      yanchor = "bottom",  
      showarrow = FALSE 
    ),
    list(
      x = 1.04,
      y= 0.07,
      text = paste("<b>Subplot key:</b><br><b>(top)</b>",var_info_dict[[vars_selected[[1]]]]$subplot_label,
                   "<br><b>(middle)</b>",var_info_dict[[vars_selected[[2]]]]$subplot_label,
                   "<br><b>(bottom)</b>",var_info_dict[[vars_selected[[3]]]]$subplot_label,
                   "<br><b>(left)</b> Warm/Wet",
                   "<br><b>(right)</b> Hot/Dry"),
      font = list(size = 12),
      xref = "paper",  
      yref = "paper", 
      xanchor = "left",
      yanchor = "bottom",
      align = "left",
      showarrow = FALSE
    )
    )
  
  # rename months to follow hydrologic calendar year
  hydro_month_order = c((10:12),(1:9))
  ann_month_order = (1:12)
  xlabel_str <- c('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec')
  xlabel_str<- xlabel_str[hydro_month_order]
  
  # input_data %>% mutate(month = recode(month,`1`=`10`,`2`=`11`,`3`=`12`,`4`=`1`,`5`=`2`,`6`=`3`,`7`=`4`,`8`=`5`,`9`=`6`,`10`=`7`,`11`=`8`,`12`=`9`))
  month_new <- input_data$month
  month_new[month_new %in% hydro_month_order] <- ann_month_order[match(month_new, hydro_month_order, nomatch = 0)]
  input_data$month_old <- input_data$month
  input_data$month <- month_new
  
  # rename basins, variables, and climates generic values
  input_data$v1 = input_data[[vars_selected_stored[1]]]
  input_data$v2 = input_data[[vars_selected_stored[2]]]
  input_data$v3 = input_data[[vars_selected_stored[3]]]
  
  input_data$climate[input_data$climate=="Warm_Wet"] = "c1"
  input_data$climate[input_data$climate=="Hot_Dry"] = "c2"
  
  # get dataset for subplot 1 (var 1, climate 1)
  v1c1_data <- input_data %>%
    filter((basin_name %in% basin_selected_stored),(time %in% time_plot),(climate %in% "c1")) %>%
    filter(!((time == "Period_3")&(lulc =="hist_0perc"))) %>%
    dplyr::select(v1,lulc,month)     %>%
    pivot_wider(
      names_from = c(lulc),
      values_from = v1,
      names_sep = "_"
    ) %>% arrange(month)
  
  # get dataset for subplot 2 (var 1, climate 2)
  v1c2_data <- input_data %>%
    filter((basin_name %in% basin_selected_stored),(time %in% time_plot),(climate %in% "c2")) %>%
    filter(!((time == "Period_3")&(lulc =="hist_0perc"))) %>%
    dplyr::select(v1,lulc,month)     %>%
    pivot_wider(
      names_from = c(lulc),
      values_from = v1,
      names_sep = "_"
    ) %>% arrange(month)
  
  # get dataset for subplot 3 (var 2, climate 1)
  v2c1_data <- input_data %>%
    filter((basin_name %in% basin_selected_stored),(time %in% time_plot),(climate %in% "c1")) %>%
    filter(!((time == "Period_3")&(lulc =="hist_0perc"))) %>%
    dplyr::select(v2,lulc,month)     %>%
    pivot_wider(
      names_from = c(lulc),
      values_from = v2,
      names_sep = "_"
    ) %>% arrange(month)
  
  # get dataset for subplot 4 (var 2, climate 2)
  v2c2_data <- input_data %>%
    filter((basin_name %in% basin_selected_stored),(time %in% time_plot),(climate %in% "c2")) %>%
    filter(!((time == "Period_3")&(lulc =="hist_0perc"))) %>%
    dplyr::select(v2,lulc,month)     %>%
    pivot_wider(
      names_from = c(lulc),
      values_from = v2,
      names_sep = "_"
    ) %>% arrange(month)
  
  
  # get dataset for subplot 5 (var 3, climate 1)
  v3c1_data <- input_data %>%
    filter((basin_name %in% basin_selected_stored),(time %in% time_plot),(climate %in% "c1")) %>%
    filter(!((time == "Period_3")&(lulc =="hist_0perc"))) %>%
    dplyr::select(v3,lulc,month)     %>%
    pivot_wider(
      names_from = c(lulc),
      values_from = v3,
      names_sep = "_"
    ) %>% arrange(month)
  
  # get dataset for subplot 6 (var 3, climate 2)
  v3c2_data <- input_data %>%
    filter((basin_name %in% basin_selected_stored),(time %in% time_plot),(climate %in% "c2")) %>%
    filter(!((time == "Period_3")&(lulc =="hist_0perc"))) %>%
    dplyr::select(v3,lulc,month)     %>%
    pivot_wider(
      names_from = c(lulc),
      values_from = v3,
      names_sep = "_"
    ) %>% arrange(month)
  
  
  # create subplot 1 (var 1, climate 1)
  p_v1c1 <- plot_ly(v1c1_data,x=~month,y=~hist_0perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$hist_0perc,
                    type='scatter',mode='lines',legendgroup='hist_0perc',
                    line=plot_specs_wat_monthly_line$line_specs$hist_0perc,hovertemplate="%{y:.4f}") %>%
    add_trace(v1c1_data,x=~month,y=~a2_0perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_0perc,
              type='scatter',mode='lines',legendgroup='a2_0perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_0perc,hovertemplate="%{y:.4f}") %>%
    add_trace(v1c1_data,x=~month,y=~a2_10perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_10perc,
              type='scatter',mode='lines',legendgroup='a2_10perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_10perc,hovertemplate="%{y:.4f}") %>%
    add_trace(v1c1_data,x=~month,y=~a2_30perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_30perc,
              type='scatter',mode='lines',legendgroup='a2_30perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_30perc,hovertemplate="%{y:.4f}") %>%
    add_trace(v1c1_data,x=~month,y=~a2_60perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_60perc,
              type='scatter',mode='lines',legendgroup='a2_60perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_60perc,hovertemplate="%{y:.4f}") %>%
    add_trace(v1c1_data,x=~month,y=~a2_90perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_90perc,
              type='scatter',mode='lines',legendgroup='a2_90perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_90perc,hovertemplate="%{y:.4f}") %>%
    layout(xaxis=list(tickvals =list(1,2,3,4,5,6,7,8,9,10,11,12),
                      ticktext=xlabel_str,
                      range = list(1,12),
                      ticklen = 7,
                      ticks = "outside",
                      title=x_label
    ),
    yaxis = list(
      title=y_labels[1],
      ticklen = 7,
      ticks = "inside"
    ),
    shapes = list(
      list(type = "rect",
           fillcolor = "none", line = list(color = "black",width=0.75), 
           # opacity = 0.3,
           x0 = 0, x1 = 1, xref = "paper",
           y0 = 0, y1 = 1, yref = "paper"))
    )
  
  # create subplot 2 (var 1, climate 2)
  p_v1c2 <- plot_ly(v1c2_data,x=~month,y=~hist_0perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$hist_0perc,
                    type='scatter',mode='lines',legendgroup='hist_0perc',
                    line=plot_specs_wat_monthly_line$line_specs$hist_0perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v1c2_data,x=~month,y=~a2_0perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_0perc,
              type='scatter',mode='lines',legendgroup='a2_0perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_0perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v1c2_data,x=~month,y=~a2_10perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_10perc,
              type='scatter',mode='lines',legendgroup='a2_10perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_10perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v1c2_data,x=~month,y=~a2_30perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_30perc,
              type='scatter',mode='lines',legendgroup='a2_30perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_30perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v1c2_data,x=~month,y=~a2_60perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_60perc,
              type='scatter',mode='lines',legendgroup='a2_60perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_60perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v1c2_data,x=~month,y=~a2_90perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_90perc,
              type='scatter',mode='lines',legendgroup='a2_90perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_90perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    layout(xaxis=list(tickvals =list(1,2,3,4,5,6,7,8,9,10,11,12),
                      ticktext=xlabel_str,
                      range = list(1,12),
                      ticklen = 7,
                      ticks = "outside",
                      title=x_label
    ),
    yaxis = list(
      title=y_labels[1],
      ticklen = 7,
      ticks = "inside"
    ),
    shapes = list(
      list(type = "rect",
           fillcolor = "none", line = list(color = "black",width=0.75), 
           # opacity = 0.3,
           x0 = 0, x1 = 1, xref = "paper",
           y0 = 0, y1 = 1, yref = "paper")))
  
  # create subplot 3 (var 2, climate 1)
  p_v2c1 <- plot_ly(v2c1_data,x=~month,y=~hist_0perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$hist_0perc,
                    type='scatter',mode='lines',legendgroup='hist_0perc',
                    line=plot_specs_wat_monthly_line$line_specs$hist_0perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v2c1_data,x=~month,y=~a2_0perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_0perc,
              type='scatter',mode='lines',legendgroup='a2_0perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_0perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v2c1_data,x=~month,y=~a2_10perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_10perc,
              type='scatter',mode='lines',legendgroup='a2_10perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_10perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v2c1_data,x=~month,y=~a2_30perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_30perc,
              type='scatter',mode='lines',legendgroup='a2_30perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_30perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v2c1_data,x=~month,y=~a2_60perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_60perc,
              type='scatter',mode='lines',legendgroup='a2_60perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_60perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v2c1_data,x=~month,y=~a2_90perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_90perc,
              type='scatter',mode='lines',legendgroup='a2_90perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_90perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    layout(xaxis=list(tickvals =list(1,2,3,4,5,6,7,8,9,10,11,12),
                      ticktext=xlabel_str,
                      range = list(1,12),
                      ticklen = 7,
                      ticks = "outside",
                      title=x_label
    ),
    yaxis = list(
      title=y_labels[2],
      ticklen = 7,
      ticks = "inside"
    ),
    shapes = list(
      list(type = "rect",
           fillcolor = "none", line = list(color = "black",width=0.75), 
           # opacity = 0.3,
           x0 = 0, x1 = 1, xref = "paper",
           y0 = 0, y1 = 1, yref = "paper")))
  
  # create subplot 4 (var 2, climate 2)
  p_v2c2 <- plot_ly(v2c2_data,x=~month,y=~hist_0perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$hist_0perc,
                    type='scatter',mode='lines',legendgroup='hist_0perc',
                    line=plot_specs_wat_monthly_line$line_specs$hist_0perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v2c2_data,x=~month,y=~a2_0perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_0perc,
              type='scatter',mode='lines',legendgroup='a2_0perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_0perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v2c2_data,x=~month,y=~a2_10perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_10perc,
              type='scatter',mode='lines',legendgroup='a2_10perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_10perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v2c2_data,x=~month,y=~a2_30perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_30perc,
              type='scatter',mode='lines',legendgroup='a2_30perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_30perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v2c2_data,x=~month,y=~a2_60perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_60perc,
              type='scatter',mode='lines',legendgroup='a2_60perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_60perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v2c2_data,x=~month,y=~a2_90perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_90perc,
              type='scatter',mode='lines',legendgroup='a2_90perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_90perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    layout(xaxis=list(tickvals =list(1,2,3,4,5,6,7,8,9,10,11,12),
                      ticktext=xlabel_str,
                      range = list(1,12),
                      ticklen = 7,
                      ticks = "outside",
                      title=x_label
    ),
    yaxis = list(
      title=y_labels[2],
      ticklen = 7,
      ticks = "inside"
    ),
    shapes = list(
      list(type = "rect",
           fillcolor = "none", line = list(color = "black",width=0.75), 
           # opacity = 0.3,
           x0 = 0, x1 = 1, xref = "paper",
           y0 = 0, y1 = 1, yref = "paper")))
  
  
  # create subplot 5 (var 3, climate 1)
  p_v3c1 <- plot_ly(v3c1_data,x=~month,y=~hist_0perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$hist_0perc,
                    type='scatter',mode='lines',legendgroup='hist_0perc',
                    line=plot_specs_wat_monthly_line$line_specs$hist_0perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v3c1_data,x=~month,y=~a2_0perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_0perc,
              type='scatter',mode='lines',legendgroup='a2_0perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_0perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v3c1_data,x=~month,y=~a2_10perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_10perc,
              type='scatter',mode='lines',legendgroup='a2_10perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_10perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v3c1_data,x=~month,y=~a2_30perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_30perc,
              type='scatter',mode='lines',legendgroup='a2_30perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_30perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v3c1_data,x=~month,y=~a2_60perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_60perc,
              type='scatter',mode='lines',legendgroup='a2_60perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_60perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v3c1_data,x=~month,y=~a2_90perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_90perc,
              type='scatter',mode='lines',legendgroup='a2_90perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_90perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    layout(xaxis=list(tickvals =list(1,2,3,4,5,6,7,8,9,10,11,12),
                      ticktext=xlabel_str,
                      range = list(1,12),
                      ticklen = 7,
                      ticks = "outside",
                      title=x_label
    ),
    yaxis = list(
      title=y_labels[3],
      ticklen = 7,
      ticks = "inside"
    ),
    shapes = list(
      list(type = "rect",
           fillcolor = "none", line = list(color = "black",width=0.75), 
           # opacity = 0.3,
           x0 = 0, x1 = 1, xref = "paper",
           y0 = 0, y1 = 1, yref = "paper")))
  
  # create subplot 6 (var 3, climate 2)
  p_v3c2 <- plot_ly(v3c2_data,x=~month,y=~hist_0perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$hist_0perc,
                    type='scatter',mode='lines',legendgroup='hist_0perc',
                    line=plot_specs_wat_monthly_line$line_specs$hist_0perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v3c2_data,x=~month,y=~a2_0perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_0perc,
              type='scatter',mode='lines',legendgroup='a2_0perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_0perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v3c2_data,x=~month,y=~a2_10perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_10perc,
              type='scatter',mode='lines',legendgroup='a2_10perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_10perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v3c2_data,x=~month,y=~a2_30perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_30perc,
              type='scatter',mode='lines',legendgroup='a2_30perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_30perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v3c2_data,x=~month,y=~a2_60perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_60perc,
              type='scatter',mode='lines',legendgroup='a2_60perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_60perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    add_trace(v3c2_data,x=~month,y=~a2_90perc,name=plot_specs_wat_monthly_line$scenario_legendgroup_names$a2_90perc,
              type='scatter',mode='lines',legendgroup='a2_90perc',
              line=plot_specs_wat_monthly_line$line_specs$a2_90perc,hovertemplate="%{y:.4f}",showlegend=FALSE) %>%
    layout(xaxis=list(tickvals =list(1,2,3,4,5,6,7,8,9,10,11,12),
                      ticktext=xlabel_str,
                      range = list(1,12),
                      ticklen = 7,
                      ticks = "outside",
                      title=x_label
    ),
    yaxis = list(
      title=y_labels[3],
      ticklen = 7,
      ticks = "inside"
    ),
    shapes = list(
      list(type = "rect",
           fillcolor = "none", line = list(color = "black",width=0.75), 
           # opacity = 0.3,
           x0 = 0, x1 = 1, xref = "paper",
           y0 = 0, y1 = 1, yref = "paper")))
  
  
  # create final figure
  fig <- subplot(p_v1c1,p_v1c2,p_v2c1,p_v2c2,p_v3c1,p_v3c2,shareX = T,shareY=T,nrows=length(vars_selected),titleY=TRUE) %>% layout(
    showlegend=TRUE,
    annotations=annotations
  )
  
  
  # fig <- subplot(p1,p3,p2,p4,shareY = T,nrows=2) %>% layout(showlegend = TRUE,annotations=subplot_annotations)
  
  return(fig)
}

## --------------------------Spatial map plots---------------------------------## ----


# function for map legend labels ----
myLabelFormat = function(...,signed=FALSE,relative_limits=FALSE,scale_range=NA,orig_val_range=NA,ndecimals=0){ 
  if((signed)&(relative_limits)){ 
    function(type = "numeric", cuts){ 
      cuts<-sprintf(paste0("%s%.",ndecimals,"f"), ifelse(cuts>0,"+",""), cuts)
      if (scale_range[1] == 0){
        if (orig_val_range[2]>scale_range[2]) {
          
          cuts[cuts==sprintf(paste0("%+.",ndecimals,"f"),scale_range[2])] <- paste("\u2265",cuts[cuts==sprintf(paste0("%+.",ndecimals,"f"),scale_range[2])],sep="")
        }
      } else if (scale_range[2]==0) {
        if (orig_val_range[1]<scale_range[1]) {
          cuts[cuts==scale_range[1]] <- paste("\u2264",cuts[cuts==scale_range[1]],sep="")
        }
      } else {
        if (orig_val_range[2]>scale_range[2]) {
          cuts[cuts==sprintf(paste0("%+.",ndecimals,"f"),scale_range[2])] <- paste("\u2265",cuts[cuts==sprintf(paste0("%+.",ndecimals,"f"),scale_range[2])],sep="")
        }
        if (orig_val_range[1]<scale_range[1]) {
          cuts[cuts==scale_range[1]] <- paste("\u2264",cuts[cuts==scale_range[1]],sep="")
        }
      }
      cuts
    } 
  } else if(signed) {
    function(type = "numeric", cuts){ 
      cuts<-sprintf("%s%f", ifelse(cuts>0,"+",""), cuts)
      cuts
    }
  } else if (relative_limits) {
    function(type = "numeric", cuts){
      cuts[cuts==scale_range[1]] <- paste("\u2265",cuts[cuts==scale_range[1]],sep="")
      cuts[cuts==scale_range[2]] <- paste("\u2264",cuts[cuts==scale_range[2]],sep="")
      cuts
    }
  } else{
    labelFormat(...)
  }
}


# map function ----
plot_spatial_map <-function(plot_input_list){
  
  # unpack list of input arguments
  var_selected <- plot_input_list$var_selected
  temporal_scale_selected <- plot_input_list$temporal_scale_selected
  impact_type_selected <- plot_input_list$impact_type_selected
  climate_scenario <- plot_input_list$climate_scenario
  subbasin_aggs <- plot_input_list$subbasin_aggs
  basemap_on <- plot_input_list$basemap_on
  time_plot<-c("Period_3")
  
  # get secondary arguments based on input arguments and argument dictionary
  var_stored_name <- var_info_dict[[var_selected]]$stored_name
  base_string <- var_info_dict[[var_selected]]$map_basin_label_base_string
  ndecimals <- var_info_dict[[var_selected]]$map_legend_ndecimals
  impact_type_stored_name <- spatial_input_argument_dictionary$impact_scenarios[[impact_type_selected]]$stored_name
  lulc_stored <- spatial_input_argument_dictionary$impact_scenarios[[impact_type_selected]]$lulc_stored
  scale_units <- spatial_input_argument_dictionary$temporal_scales[[temporal_scale_selected]]$scale_legend_units
  input_prefix = spatial_input_argument_dictionary$impact_scenarios[[impact_type_selected]]$input_file_prefix
  input_suffix = spatial_input_argument_dictionary$impact_scenarios[[impact_type_selected]]$input_file_suffix[[climate_scenario]]
  
  # get file input name ----
  file_path_open <- paste0(spatial_input_argument_dictionary$input_file_directory,
                           input_prefix,
                           input_suffix)
  

  # get legend title ----
  if (var_info_dict[[var_selected]]$flux_type) {
    legend_title <- paste("<em>\u0394",var_info_dict[[var_selected]]$plot_var_str,"</em> [",var_info_dict[[var_selected]]$units,"/",scale_units,"]",sep="")
  } else {
    legend_title <- paste("<em>\u0394",var_info_dict[[var_selected]]$plot_var_str,"</em> [",var_info_dict[[var_selected]]$units,"]",sep="")
  }
  
  # get subbasin aggragated value labels
  flux_type_i <- var_info_dict %>% list.filter(stored_name==var_stored_name) %>% list.mapv(flux_type)
  subbasin_mean_vals <- do.call(sprintf, c(fmt = base_string, as.list(subbasin_aggs %>% filter(basin_name %in% subbasin_stored_names,time==time_plot,climate==climate_scenario,lulc==lulc_stored) %>% dplyr::select(as.name(var_stored_name)))))
  
  if (!(identical(var_info_dict[[var_selected]]$units,"-"))) {
    units_i <- var_info_dict %>% list.filter(stored_name==var_stored_name) %>% list.mapv(units)
    if (flux_type_i) {
      subbasin_mean_vals <- paste(subbasin_mean_vals, units_i,"/",scale_units, sep=" ")
    } else{
      subbasin_mean_vals <- paste(subbasin_mean_vals, units_i, sep=" ")
    }
  }
  subbasin_labels <- lapply(seq(length(subbasin_full_names)), function(i) {
    paste0('<b>',subbasin_full_names[i],
           ' average</b>:', 
           '<br>&nbsp&nbsp&nbsp',
           subbasin_mean_vals[i])
  })
  
  
  
  # load raster -----
  rasterDF <- raster(file_path_open,varname=var_stored_name)
  rasterDF <- readAll(rasterDF)
  
  # setup initial plot colors -----
  if (identical(impact_type_stored_name,"climate_impact")) {
    change_thres <- var_info_dict[[var_selected]]$climate_change_thres 
  } else {
    change_thres <- var_info_dict[[var_selected]]$forest_change_thres 
  }
  
  scale_range <- c(-1*change_thres,change_thres)
  color_selected <- var_info_dict[[var_selected]]$change_color 
  vals_no_na <- rasterDF@data@values[!is.na(rasterDF@data@values)]
  orig_val_range <- range(vals_no_na)  
  if ((grepl("rev",color_selected)) | (( (orig_val_range[1]>=0) | (orig_val_range[2]<=0) ) & (identical(color_selected,"BrBG"))) ) {
  # if ((grepl("rev",color_selected))) {
    reverse_pallette=TRUE
    color_selected<-str_remove(color_selected, "_rev")
    x <- sum((vals_no_na <= change_thres)&(vals_no_na >= (-1*change_thres)))
    rampcols <- colorRampPalette(colors = rev(brewer.pal(11,color_selected)), space = "Lab")(x)
    mypal <- colorNumeric(palette = rampcols, domain = scale_range,na.color="transparent",alpha=1.0)
  } else {
    reverse_pallette=FALSE
    mypal <- colorNumeric(color_selected, domain = scale_range)
    rampcols<- color_selected
  }
  
  # set values to be centered on the threshold limits -----
  # vals_no_na <- rasterDF@data@values[!is.na(rasterDF@data@values)]
  # orig_val_range <- range(vals_no_na)
  rasterDF@data@values[rasterDF@data@values <  (-1*change_thres)] = (-1*change_thres)
  rasterDF@data@values[rasterDF@data@values > change_thres] = change_thres
  
  # adjust plot colors according to scale_range, orig_val_range and reverse_pallette argument -----
  if (orig_val_range[1]>=0) {
    scale_range<-c(0,change_thres)
    x <- sum((vals_no_na <= change_thres)&(vals_no_na >= (-1*change_thres)))
    if (reverse_pallette) {
      rampcols <- colorRampPalette(colors = brewer.pal(11,color_selected)[6:11], space = "Lab")(x)
    } else {
      rampcols <- colorRampPalette(colors = rev(brewer.pal(11,color_selected)[1:6]), space = "Lab")(x)
    }
    
    mypal <- colorNumeric(palette = rampcols, domain = scale_range,na.color="transparent",alpha=1.0)
    
  } else if (orig_val_range[2]<=0) {
    scale_range<-c(-1*change_thres,0)
    x <- sum((vals_no_na <= change_thres)&(vals_no_na >= (-1*change_thres)))
    # if (reverse_pallette) {
    rampcols <- colorRampPalette(colors = brewer.pal(11,color_selected)[1:6], space = "Lab")(x)
    # } else {
    #   rampcols <- colorRampPalette(colors = rev(brewer.pal(11,color_selected)[6:11]), space = "Lab")(x)
    # }
    mypal <- colorNumeric(palette = rampcols, domain = scale_range,na.color="transparent",alpha=1.0)
  }
  
  
  # create the plot -----
  bounds_adjust_lat <- 1.1
  bounds_adjust_lon <- 1.4
  bounds[1] <- bounds[1] + bounds_adjust_lon
  bounds[2] <- bounds[2] + bounds_adjust_lat
  bounds[3] <- bounds[3] - bounds_adjust_lon
  bounds[4] <- bounds[4] - bounds_adjust_lat
  nbins <- var_info_dict[[var_selected]]$change_nbins 
  fig<-leaflet(options = leafletOptions(zoomSnap = 0.05, zoomDelta=0.05)) %>%
    addPolygons(data= subbasins,
                color ="#444444",
                fillColor = "transparent",
                weight=1,
                smoothFactor = 0.5,
                opacity=1.0,
                label = ~ lapply(subbasin_labels, htmltools::HTML),
                labelOptions = (interactive = TRUE),
    ) %>%
    leafem::addGeoRaster(rasterDF,layerID="values",project=TRUE,colorOptions=leafem::colorOptions(palette=rampcols,na.color="transparent",domain = scale_range),opacity=1,autozoom=FALSE) %>%
    leaflet::addLegend(position="bottomright",pal=mypal,values=scale_range,bins=nbins,title=legend_title,labFormat=myLabelFormat(signed=TRUE,relative_limits=TRUE,scale_range=scale_range,orig_val_range=orig_val_range,ndecimals=ndecimals)) %>%
    addMouseCoordinates() %>%
    setView(lng= bounds[1]+((bounds[3]-bounds[1])/2)+0.5,lat=bounds[2]+((bounds[4]-bounds[2])/2)+0.25,zoom=5.65) #%>%
    # fitBounds(bounds[1],bounds[2],bounds[3],bounds[4])
  
  # add basemap
  if (basemap_on) {
    fig <- fig %>% addTiles() %>%
      setView(lng= bounds[1]+((bounds[3]-bounds[1])/2)+0.5,lat=bounds[2]+((bounds[4]-bounds[2])/2)+0.25,zoom=5.65) #%>%
  }
  
  return(fig)
}
