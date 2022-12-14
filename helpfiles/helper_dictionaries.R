## --------------------------------------------------------------------------------------##
##
## Script name: helper_dictionaries.R
##
## Purpose of the script: Creates main dictionary/list objects for the VIC-Explorer website.
##
## @author: Kristen Whitney
##
## Created on Mon Oct 3, 2022
##
## Copyright (c) Arizona State University, 2022
## Email: kmwhitne@asu.edu
##
## --------------------------------------------------------------------------------------##
##    Notes:
##    More information on this to come. 
##
## --------------------------------------------------------------------------------------##


## --------------------------Static images dictionary---------------------------------## ----
vic_ex_images <- list(
  "vic_data_pipeline" = list(
    image_src = "vic_data_pipeline.jpg",
    image_width = "auto",
    image_height = "500",
    image_alt_text = "Scenario Overview"
  ),
  "scenario_overview" = list(
    image_src = "scenario_overview.jpg",
    image_width = "auto",
    image_height = "500",
    image_alt_text = "Scenario Overview"
  ),
  "framework_overview" = list(
    image_src = "framework_overview.jpg",
    image_width = "auto",
    image_height = "450",
    image_alt_text = "Model Framework"
    
  ),
  "climate_projections" = list(
    image_src = "timeseries.yearly_anomalies.climate_bookends.jpg",  # To include table 1 from JWRPM
    image_width = "auto",
    image_height = "400",
    image_alt_text = "Under Construction"
  ),
  "climate_projections_table" = list(
    image_src = "vic_climate_proj_table.jpg",  # To include table 1 from JWRPM
    image_width = "auto",
    image_height = "650",
    image_alt_text = "Under Construction"
  ),
  "hydro_model" = list(
    image_src = "vic_schematic.jpg",
    image_width = "auto",
    image_height = "550",
    image_alt_text = "Under Construction"
  ),
  "watersheds_channels" = list(
    image_src = "watersheds_channels.jpg",
    image_width = "auto",
    image_height = "450",
    image_alt_text = "Under Construction"
  ),
  "rvic_channel_routing" = list(
    image_src = "rvic_schematic_for_web.png",
    image_width = "auto",
    image_height = "500",
    image_alt_text = "Under Construction"
  ),
  "elevation_landcover_maps" = list(
    image_src = "elevation_foresce_landcover.jpg",
    image_width = "auto",
    image_height = "650",
    image_alt_text = "elevation and subbasins"
  ),
  "elevation_landcover_table" = list(
    image_src = "elevation_landcover_table.jpg",
    image_width = "auto",
    image_height = "500",
    image_alt_text = "elevation and subbasins"
  ),
  "parameters_table_figure" = list(
    image_src = "parameters_table_figure.jpg",
    image_width = "auto",
    image_height = "600",
    image_alt_text = "elevation and subbasins"
  ),
  "stakeholders" = list(
    image_src = "stakeholder_engagement.jpg",
    image_width = "auto",
    image_height = "325",
    image_alt_text = "stakeholder engagment"
  ),
  "hydro_model_snow" = list(
    image_src = "vic_snow_model_schematic.png", 
    image_width = "auto",
    image_height = "450",
    image_alt_text = "VIC snow model schematic"
  ),
  "hydro_model_evap" = list(
    image_src = "vic_evapotranspiration.jpg",  
    image_width = "auto",
    image_height = "240",
    image_alt_text = "VIC model evapotranspiration components"
  ),
  "hydro_model_infil_runoff" = list(
    image_src = "vic_infiltration_runoff.jpg",
    image_width = "auto",
    image_height = "500",
    image_alt_text = "Under Construction"
  ),
  "hydro_model_baseflow" = list(
    image_src = "vic_baseflow.jpg",  # to include a VIC model schematic
    image_width = "auto",
    image_height = "475",
    image_alt_text = "Under Construction"
  ),
  "under_construction" = list(
    image_src = "under_construction.jpg",  
    image_width = "auto",
    image_height = "450",
    image_alt_text = "Under Construction"
  ),
  "elevation_bands" = list(
    image_src = "vic_elevation_bands_with_varnames.jpg",  
    image_width = "auto",
    image_height = "650",
    image_alt_text = "VIC elevation bands"
  ),
  "elevation_bands_aggregation" = list(
    image_src = "vic_elevation_bands_aggregation.jpg",  
    image_width = "auto",
    image_height = "360",
    image_alt_text = "VIC elevation band aggregations."
  ),
  "snowpack_evolution" = list(
    image_src = "vic_snowpack_evolution.jpg",  
    image_width = "auto",
    image_height = "230",
    image_alt_text = "VIC snowpack albedo and size evolution."
  ),
  "snowpack_assumptions" = list(
    image_src = "vic_snowpack_assumptions.jpg",  
    image_width = "auto",
    image_height = "575",
    image_alt_text = "VIC snowpack process details and assumptions"
  ),
  "clumped_canopy" = list(
    image_src = "vic_clumped_canopy.jpg",
    image_width = "auto",
    image_height = "320",
    image_alt_text = "VIC model clumped canopy scheme for ET estimations"
  ),
  "penman_monteith" = list(
    image_src = "vic_penman_monteith.jpg",
    image_width = "auto",
    image_height = "420",
    image_alt_text = "Penman Monteith approach for VIC ET estimation"
  ),
  "beta_parameter" = list(
    image_src = "vic_beta_parameter.jpg",
    image_width = "auto",
    image_height = "600",
    image_alt_text = "VIC curve shape parameter (beta)"
  )
  
)


## --------------------------References dictionary---------------------------------## ----
references_and_code <- list(
  
  "metsim_code" = "MetSim (Bennett <em>et al.</em>, 2020; <a href=\"https://github.com/UW-Hydro/MetSim\">github.com/UW-Hydro/MetSim</a>).",
  "rvic_code" = "R-VIC (Lohmann <em>et al.</em>, 1996, 1998; <a href=\"https://github.com/UW-Hydro/RVIC\">github.com/UW-Hydro/RVIC</a>).",
  "vic_code" = "VIC version 5.0 (Hamman <em>et al.</em>,2018; <a href=\"https://github.com/UW-Hydro/VIC\">github.com/UW-Hydro/VIC</a>).",
  "hamman_el_al_2018" = "Hamman <em>et al.</em>, 2018. <em>Geosci. Model Dev.</em> 11: 3481–3496. <a href=\"https://doi.org/10.5194/gmd-11-3481-2018\">doi.org/10.5194/gmd-11-3481-2018</a>.",
  "liang_el_al_1994" = "Liang <em>et al.</em>, 1994. <em>Geophys. Res.</em> 199 (D7): 14415. <a href=\"https://doi.org/10.1029/94JD00483\">doi.org/10.1029/94JD00483</a>.",
  "andreadis_et_al_2009" = "Andreadis <em>et al.</em>, 2009. <em>Water Resour. Res.</em> 45: W05429. <a href=\"https://doi.org/10.1029/2008WR007042\">doi.org/10.1029/2008WR007042</a>.",           # upgraded snow overstory scheme w/ fully-balance energy terms and snow interception
  "cherkauer_lettenmaier_2003" = "Cherkauer and Lettenmaier, 2003. <em>J. Geophys. Res.</em> 108 (D22): 8858. <a href=\"https://doi.org/10.1029/2003JD003575\">doi.org/10.1029/2003JD003575</a>.",    # snow overstory/frozen soil
  "cherkauer_et_al_2003" = "Cherkauer <em>et al.</em>, 2003. <em>Glob. Planet. Change.</em> 38 (1–2): 151–159. <a href=\"https://doi.org/10.1016/S0921-8181(03)00025-0\">doi.org/10.1016/S0921-8181(03)00025-0</a>.",
  "bohn_vivoni_2016" = "Bohn and Vivoni, 2016. <em>Water Resour. Res.</em> 52 (1): 358–384. <a href=\"https://doi.org/10.1016/S0921-8181(03)00025-0\">doi.org/10.1016/S0921-8181(03)00025-0</a>.",                  # clumped canopy scheme
  "bureau_2012" = "Bureau of Reclamation, 2012. <em>Colorado River Basin water supply and demand study.</em> Washington, D.C. <a href=\"https://www.usbr.gov/watersmart/bsp/docs/finalreport/ColoradoRiver/CRBS_Executive_Summary_FINAL.pdf\">https://www.usbr.gov/watersmart/bsp/docs/finalreport/ColoradoRiver/CRBS_Executive_Summary_FINAL.pdf</a>.",
  "christensen_lettenmaier_2007" = "Christensen and Lettenmaier, 2007. <em>HESS</em> 11: 1417–1434. <a href=\"https://doi.org/10.5194/hess-11-1417-2007\">doi.org/10.5194/hess-11-1417-2007</a>.",
  "vano_lettenmaier_2012" = "Vano and Lettenmaier, 2012. <em>J. Hydrometeorol.</em> 13: 932–949. <a href=\"https://doi.org/10.1175/JHM-D-11-069.1\">doi.org/10.1175/JHM-D-11-069.1</a>.",
  "pierce_et_al_2014" = "Pierce <em>et al.</em>, 2014. <em>J. Hydrometeorol.</em> 15: 2558–2585. <a href=\"https://doi.org/10.1175/JHM-D-14-0082.1\">doi.org/10.1175/JHM-D-14-0082.1</a>.",
  "pierce_et_al_2015" = "Pierce <em>et al.</em>, 2015. <em>BAMS</em> 16: 2421–2442. <a href=\"https://doi.org/10.1175/JHM-D-14-0236.1\">doi.org/10.1175/JHM-D-14-0236.1</a>.",
  "taylor_et_al_2012" = "Taylor <em>et al.</em>, 2012. <em>BAMS</em> 93: 485–498. <a href=\"https://doi.org/10.1175/BAMS-D-11-00094.1\">doi.org/10.1175/BAMS-D-11-00094.1</a>.",
  "sleeter_et_al_2012" = "Sleeter <em>et al.</em>, 2012. <em>Glob. Environ. Change</em> 22: 896–914. <a href=\"https://doi.org/10.1016/j.gloenvcha.2012.03.008\">doi.org/10.1016/j.gloenvcha.2012.03.008</a>.",
  
  "bennett_et_al_2020" ="Bennett <em>et al.</em>, 2020. <em>J. Open Source Softw.</em> 5 (47): 2042. <a href=\"https://doi.org/10.21105/joss.02042\">doi.org/10.21105/joss.02042</a>.",
  "bohn_et_al_2013" ="Bohn <em>et al.</em>, 2013. <em>Agric. For. Meteorol.</em> 176: 38–49. <a href=\"https://doi.org/10.1016/j.agrformet.2013.03.003\">doi.org/10.1016/j.agrformet.2013.03.003</a>.",
  "bohn_et_al_2019" ="Bohn <em>et al.</em>, 2019. <em>J. Hydrometeorol.</em> 20 (2): 298–317. <a href=\"https://doi.org/10.1175/JHM-D-18-0203.1\">doi.org/10.1175/JHM-D-18-0203.1</a>.",
  "bohn_et_al_2018a" ="[dataset] Bohn <em>et al.</em>, 2018a. <em>Zenodo.</em> <a href=\"https://doi.org/10.5281/zenodo.1402223 \">doi.org/10.5281/zenodo.1402223</a>. (Accessed September 14, 2018)",
  "bohn_vivoni_2019" ="Bohn and Vivoni, 2019. <em>Sci. Data.</em> 6: 144. <a href=\"https://doi.org/10.1038/s41597-019-0150-2\">doi.org/10.1038/s41597-019-0150-2</a>.",
  "xiao_et_al_2018" ="Xiao <em>et al.</em>, 2018. <em>Water Resour. Res.</em> 54: 6739–6756. <a href=\"https://doi.org/10.1029/2018WR023153\">doi.org/10.1029/2018WR023153</a>.",
  "xiao_et_al_2022" ="Xiao <em>et al.</em>, 2022. <em>HESS.</em> 26 (21): 5627–5646. <a href=\"https://doi.org/10.5194/hess-26-5627-2022\">doi.org/10.5194/hess-26-5627-2022</a>.",
  "livneh_et_al_2015b" ="Livneh <em>et al.</em>, 2015b. <em>Sci. Data.</em> 2: 150042. <a href=\"https://doi.org/10.1038/sdata.2015.42\">doi.org/10.1038/sdata.2015.42</a>.",
  "livneh_et_al_2015a" ="Livneh <em>et al.</em>, 2015a. <em>J. Hydrol.</em> 523: 196–210. <a href=\"https://doi.org/10.1016/j.jhydrol.2015.01.039\">doi.org/10.1016/j.jhydrol.2015.01.039</a>.",
  "nijssen_et_al_2001" ="Nijssen <em>et al.</em>, 2001. <em>J. Clim.</em> 14: 1790–1808. <a href=\"https://doi.org/10.1175/1520-0442(2001)014<1790:GREOSM>2.0.CO;2\">doi.org/10.1175/1520-0442(2001)014<1790:GREOSM>2.0.CO;2</a>.",
  "lohmann_et_al_1996" ="Lohmann <em>et al.</em>, 1996. <em>Tellus.</em> 48 (5): 708–721. <a href=\"https://doi.org/10.3402/tellusa.v48i5.12200\">doi.org/10.3402/tellusa.v48i5.12200</a>.",
  "lohmann_et_al_1998" ="Lohmann <em>et al.</em>, 1998. <em>Hydrol. Sci. J.</em> 43: 131–141. <a href=\"https://doi.org/10.1080/02626669809492107\">doi.org/10.1080/02626669809492107</a>.",
  "bennett_et_al_2018a" ="Bennett <em>et al.</em>, 2018a. <em>HESS.</em> 22: 709–725. <a href=\"https://doi.org/10.5194/hess-22-709-2018\">doi.org/10.5194/hess-22-709-2018</a>.",
  "bennett_et_al_2018b" ="Bennett <em>et al.</em>, 2018b. <em>Water Resour. Res.</em> 54: 132–149. <a href=\"https://doi.org/10.1002/2017WR020471\">doi.org/10.1002/2017WR020471</a>.",
  "usgs_et_al_2016a" ="[dataset] U.S. Geological Survey (USGS), 2016a. <em>USGS National Elevation Dataset (NED) 1 arcsecond downloadable data collection from The National Map 3D Elevation Program (3DEP) - National Geospatial Data Asset (NGDA) National Elevation Data Set (NED).</em> <a href=\"https://www.usgs.gov/core-science-systems/ngp/tnm-delivery\">https://www.usgs.gov/core-science-systems/ngp/tnm-delivery</a>. (Accessed January 1, 2018)",
  "usgs_et_al_2016b" ="[dataset] U.S. Geological Survey (USGS), 2016b. <em>National Water Information System data available to the World Wide Web (USGS Water Data for the Nation)</em> <a href=\"http://waterdata.usgs.gov/nwis/\">http://waterdata.usgs.gov/nwis/</a>. (Accessed January 1, 2018)",
  "usgs_et_al_2019" ="[dataset] U.S. Geological Survey (USGS), 2019. <em>USGS Watershed Boundary Dataset (WBD) for 2-digit Hydrologic Unit.</em> <a href=\"ftp://rockyftp.cr.usgs.gov/vdelivery/Datasets/Staged/Hydrography/WBD/HU2/Shape/\">ftp://rockyftp.cr.usgs.gov/vdelivery/Datasets/Staged/Hydrography/WBD/HU2/Shape/</a>. (Accessed October 15, 2018)",
  
  "wang_vivoni_2022" ="Wang and Vivoni, 2022. <em>J. Am. Water Resour. Assoc.</em> 58 (3): 370–387. <a href=\"https://doi.org/10.1111/1752-1688.13005\">doi.org/10.1111/1752-1688.13005</a>.",
  "bohn_et_al_2018b" = "Bohn <em>et al.</em>, 2018b. <em>Environ. Res. Lett.</em> 13: 114005. <a href=\"https://doi.org/10.1088/1748-9326/aae53e\">doi.org/10.1088/1748-9326/aae53e</a>.",
  "williams_et_al_2022" = "Williams <em>et al.</em>, 2022. <em>PNAS</em> 119 (10): e2114069119. <a href=\"https://doi.org/10.1073/pnas.2114069119\">doi.org/10.1073/pnas.2114069119</a>.",
  "biederman_et_al_2022" = "Biederman <em>et al.</em>, 2022. <em>Water Resour. Res.</em> 58: e2021WR030687. <a href=\"https://doi.org/10.1029/2021WR030687\">doi.org/10.1029/2021WR030687</a>.",
  "buma_and_livneh_2015" = "Buma and Livneh, 2015. <em>For. Sci.</em> 61 (5): 895–903. <a href=\"https://doi.org/10.5849/forsci.14-164\">doi.org/10.5849/forsci.14-164</a>.",
  "moreno_et_al_2016" = "Moreno <em>et al.</em>, 2016. <em>Hydrol. Earth Syst. Sci.</em> 20: 1241–1267. <a href=\"https://doi.org/10.5194/hess-20-1241-2016\">doi.org/10.5194/hess-20-1241-2016</a>.",
  "boon_2007" = "Boon, 2007. <em>J. Ecosyst. Manage.</em> 8: 1–13. <a href=\"https://jem-online.org/forrex/index.php/jem/article/view/369\">doi.org/10.22230/jem.2007v8n3a369</a>.",
  "zou_et_al_2010" = "Zou <em>et al.</em>, 2010. <em>For. Ecol. Manag.</em> 259 (7): 1268–1276. <a href=\"https://doi.org/10.1016/j.foreco.2009.08.005\">doi.org/10.1016/j.foreco.2009.08.005</a>.",
  "biederman_et_al_2015" = "Biederman <em>et al.</em>, 2015. <em>Water Resour. Res.</em> 51: 9775–9789. <a href=\"https://doi.org/10.1002/2015WR017401\">doi.org/10.1002/2015WR017401</a>.",
  "brown_et_al_2014" = "Brown <em>et al.</em>, 2014. <em>Hydrol. Process.</em> 28: 3326–3340. <a href=\"https://doi.org/10.1002/hyp.9870\">doi.org/10.1002/hyp.9870</a>.",
  "harpold_et_al_2014" = "Harpold <em>et al.</em>, 2014. <em>Ecohydrol.</em> 7: 440–452. <a href=\"https://doi.org/10.1002/eco.1363\">doi.org/10.1002/eco.1363</a>.",
  "vivoni_et_al_2008" = "Vivoni <em>et al.</em>, 2008. <em>Geophys. Res. Lett.</em> 35: L22403. <a href=\"https://doi.org/10.1029/2008GL036001\">doi.org/10.1029/2008GL036001</a>.",
  
  "deangelo_et_al_2017" = "DeAngelo <em>et al.</em>, 2017. In <em>Climate Science Special Report: Fourth National Climate Assessment, Volume I</em> [Wuebbles, D. J. <em>et al.</em> (eds.)], 393–410. Washington, DC, USA: U.S. Global Change Research Program. <a href=\"https://doi.org/10.7930/J0M32SZG\">doi.org/10.7930/J0M32SZG</a>.",
  "bennett_et_al_2009" = "Bennett <em>et al.</em>, 2009. <em>Ecol.</em> 12 (12): 1394–1404. <a href=\"https://doi.org/10.1111/j.1461-0248.2009.01387.x\">doi.org/10.1111/j.1461-0248.2009.01387.x</a>.",
  "goeking_tarboton_2020" = "Goeking and Tarboton, 2020. <em>J. For.</em> 118 (2): 172–192. <a href=\"https://doi.org/10.1093/jofore/fvz069\">doi.org/10.1093/jofore/fvz069</a>.",
  "marks_et_al_2013" = "Marks <em>et al.</em>, 2013. <em>Adv. Water Resour.</em> 55: 98–110. <a href=\"http://dx.doi.org/10.1016/j.advwatres.2012.11.012\">dx.doi.org/10.1016/j.advwatres.2012.11.012</a>.",
  "jennings_et_al_2018" = "Jennings <em>et al.</em>, 2018. <em>Nat. Commun.</em> 9: 1148. <a href=\"https://doi.org/10.1038/s41467-018-03629-7\">doi.org/10.1038/s41467-018-03629-7</a>.",
  "harpold_et_al_2017" = "Harpold <em>et al.</em>, 2017. <em>Hydrol. Earth Syst. Sci.</em> 21: 1–22. <a href=\"https://doi.org/10.5194/hess-21-1-2017\">doi.org/10.5194/hess-21-1-2017</a>.",
  "wang_et_al_2019" = "Wang <em>et al.</em>, 2019. <em>Washington: American Geophysical Union</em> 46 (23): 13825–13835. <a href=\"https://doi.org/10.1029/2019GL085722\">doi.org/10.1029/2019GL085722</a>.",
  "franchini_pacciani_1991" = "Franchini and Pacciani, 1991. <em>J. Hydrol.</em> 122 (1–4): 161–219. <a href=\"https://doi.org/10.1016/0022-1694(91)90178-K\">doi.org/10.1016/0022-1694(91)90178-K</a>.",
  "gautam_mascaro_2018" = "Gautam and Mascaro, 2018. <em>Int. J. of Climatol.</em> 38: 3861–3877. [first page–last page]. <a href=\"https://doi.org/10.1002/joc.5540\">doi.org/10.1002/joc.5540</a>.",
  "inegi_2013" = "INEGI, 2013. “Conjunto de datos vectoriales de Uso del Suelo y Vegetación, Escala 1: 250 000, Serie V (Capa Unión).” . <a href=\"https://www.inegi.org.mx/app/biblioteca/ficha.html?upc=702825007024\">inegi.org.mx/app/biblioteca/ficha.html?upc=702825007024</a>.",
  "lukas_payton_2020" = "Lukas and Payton, 2020. <em>Colorado River Basin Climate and Hydrology: State of the Science</em> U. Colorado: Western Water Assessment. <a href=\"https://doi.org/10.25810/3hcv-w477\">doi.org/10.25810/3hcv-w477</a>.",
  "sohl_et_al_2016" = "Sohl <em>et al.</em>, 2016. <em>Ecol. Modell.</em> 337: 181–297. <a href=\"https://doi.org/10.1016/j.ecolmodel.2016.07.016\">doi.org/10.1016/j.ecolmodel.2016.07.016</a>.",
  "haffey_et_al_2018" = "Haffey <em>et al.</em>, 2018. <em>Fire Ecol.</em> 14 (1): 143–163. <a href=\"https://doi.org/10.4996/fireecology.140114316\">doi.org/10.4996/fireecology.140114316</a>.",
  "hurteau_et_al_2014" = "Hurteau <em>et al.</em>, 2014. <em>For. Ecol. Manag.</em> 327: 280–289. <a href=\"http://dx.doi.org/10.1016/j.foreco.2013.08.007\">doi.org/10.1016/j.foreco.2013.08.007</a>.",
  "litschert_et_al_2012" = "Litschert <em>et al.</em>, 2012. <em>For. Ecol. Manag.</em> 269: 124–133. <a href=\"https://doi.org/10.1016/j.foreco.2011.12.024\">doi.org/10.1016/j.foreco.2011.12.024</a>.",
  "mcdowell_et_al_2016" = "McDowell <em>et al.</em>, 2016. <em>Nat. Clim. Change.</em> 6: 295–300. <a href=\"https://doi.org/10.1038/nclimate2873\">doi.org/10.1038/nclimate2873</a>.",
  "seidl_et_al_2011" = "Seidl <em>et al.</em>, 2011. <em>Ecol. Modell.</em> 222 (4): 903–924. <a href=\"https://doi.org/10.1016/j.ecolmodel.2010.09.040\">doi.org/10.1016/j.ecolmodel.2010.09.040</a>.",
  "rosenberg_et_al_2013" = "Rosenberg <em>et al.</em>, 2013. <em>Hydrol. Earth Syst. Sci.</em> 17: 1475–1491. <a href=\"https://doi.org/10.5194/hess-17-1475-2013\">doi.org/10.5194/hess-17-1475-2013</a>.",
  "white_et_al_2010" = "White <em>et al.</em>, 2010. <em>Sci. Public Pol.</em> 37 (3): 219–232. <a href=\"https://doi.org/10.3152/030234210X497726\">doi.org/10.3152/030234210X497726</a>.",
  "dunn_laing_2017" = "Dunn and Laing, 2017. <em>Environ. Sci. & Pol.</em> 76: 146–152. <a href=\"https://doi.org/10.1016/j.envsci.2017.07.005\">doi.org/10.1016/j.envsci.2017.07.005</a>.",
  "reed_et_al_2016" = "Reed <em>et al.</em>, 2016. <em>Theor. Appl. Climatol.</em> 131: 153–165. <a href=\"https://doi.org/10.1007/s00704-016-1965-9\">doi.org/10.1007/s00704-016-1965-9</a>.",
  "dore_et_al_2008" = "Dore <em>et al.</em>, 2008. <em>Glob. Chang. Biol.</em> 14 (8): 1801–1820. <a href=\"https://doi.org/10.1111/j.1365-2486.2008.01613.x\">doi.org/10.1111/j.1365-2486.2008.01613.x</a>.",
  "zhang_et_al_2017" = "Zhang <em>et al.</em>, 2017. <em>J. Hydrol.</em> 546: 44–59. <a href=\"https://doi.org/10.1016/j.jhydrol.2016.12.040\">doi.org/10.1016/j.jhydrol.2016.12.040</a>.",
  "li_et_al_2017" = "Li <em>et al.</em>, 2017. <em>Ecohydrol.</em> 10: e1838. <a href=\"https://doi.org/10.1002/eco.1838\">doi.org/10.1002/eco.1838</a>.",
  "wang_et_al_2020" = "Wang <em>et al.</em>, 2020. <em>J. Hydrol.</em> 590: 125387. <a href=\"https://doi.org/10.1016/j.jhydrol.2020.125387\">doi.org/10.1016/j.jhydrol.2020.125387</a>.",
  "boon_2012" = "Boon, 2012. <em>Ecohydrol.</em> 5: 279–285. <a href=\"https://doi.org/10.1002/eco.212\">doi.org/10.1002/eco.212</a>.",
  "broxton_et_al_2014" = "Broxton <em>et al.</em>, 2014. <em>Ecohydrol.</em> 8 (6): 1073–1094. <a href=\"https://doi.org/10.1002/eco.1565\">doi.org/10.1002/eco.1565</a>.",
  "harpold_et_al_2015" = "Harpold <em>et al.</em>, 2015. <em>Hydrol.</em> 29 (12): 2782–2798. <a href=\"https://doi.org/10.1002/hyp.10400\">doi.org/10.1002/hyp.10400</a>.",
  "overpeck_udall_2020" = "Overpeck and Udall, 2020. <em>J. Hydrometeorol.</em> 15: 2558–2585. <a href=\"https://doi.org/10.1175/JHM-D-14-0082.1\">doi.org/10.1175/JHM-D-14-0082.1</a>.",
  "seager_et_al_2007" = "Seager <em>et al.</em>, 2007. <em>Science.</em> 316 (5828): 1181–1184. <a href=\"https://doi.org/10.1126/science.1139601\">doi.org/10.1126/science.1139601</a>."
  
  
  # general structure:
  # "[in text citation]" = "[first author] <em>et al.</em>, [year]. <em>[journal abbreviation]</em> [vol] ([issue]): [first page–last page]. <a href=\"[doi full url]\">[doi short url]</a>."
  
  )

## --------------------------Watersheds dictionary---------------------------------## ----
# Notes: Could add total basin area list item (requires pre-computed values or use of basin masks and domain file)
subbasin_full_names <- c("Green","Upper Colorado","San Juan","Glen Canyon","Little Colorado","Grand Canyon","Lower Colorado","Gila")
subbasin_stored_names <- stri_replace_all_regex(subbasin_full_names,pattern=c("Colorado"),replacement = c("Colo"))
subbasin_stored_names <- str_replace_all(subbasin_stored_names,fixed(" "), "")
subbasin_full_names <- paste(subbasin_full_names, " subbasin", sep="")
# basin_stored_names <- append(subbasin_stored_names,c("CRB","MiddleColo","UpperBasin","LowerBasin"))
# basin_full_names<- append(subbasin_full_names,c("Basin-wide","Middle Colorado (Grand Canyon + Little Colorado subbasins)","Upper Basin","Lower Basin"))
basin_stored_names <- append(subbasin_stored_names,c("CRB","UpperBasin","LowerBasin"))
basin_full_names<- append(subbasin_full_names,c("Basin-wide","Upper Basin","Lower Basin"))

basin_dict <-list()
# subbasin_dict <-list()
for(i in 1:length(basin_full_names)) {
  if ((grepl("subbasin",basin_full_names[i])) & (!grepl("subbasins",basin_full_names[i]))){
    is_subbasin=TRUE
    basin_full_names[i] <- str_replace_all(basin_full_names[i],fixed(" subbasin"), "")
    # assign(basin_full_names[i],list("stored_name"=basin_stored_names[i],"full_name"=basin_full_names[i]))
    # subbasin_dict[[basin_full_names[i]]] <- get(basin_full_names[i])
  } else {
    is_subbasin=FALSE
  }
  assign(basin_full_names[i],list("stored_name"=basin_stored_names[i],"full_name"=basin_full_names[i],"is_subbasin"=is_subbasin))
  basin_dict[[basin_full_names[i]]] <- get(basin_full_names[i])
}
reordered_names <- c("Basin-wide","Upper Basin","Lower Basin","Green","Upper Colorado","San Juan","Glen Canyon","Little Colorado","Grand Canyon","Lower Colorado","Gila")
basin_dict <- basin_dict[reordered_names]
# subbasin_full_names <- str_replace_all(subbasin_full_names,fixed(" subbasin"), "")

## --------------------------Variables dictionary---------------------------------## ----
Canopy_moisture_interception <- list(stored_name="OUT_WDEW",
                                     description="Total moisture interception storage in canopy",
                                     plot_var_str = 'WDEW',
                                     units="mm",
                                     subplot_label = "Canopy moisture",
                                     flux_type = FALSE,
                                     changes_as_a_percentage = FALSE, # compute the anomaly as a percentage of Baseline (TRUE) or as an absolute difference relative to Baseline (FALSE)
                                     mann_color="YlGnBu",
                                     change_color="BrBG",
                                    climate_change_thres=20,
                                    forest_change_thres=10,
                                    change_nbins=11,
                                    map_basin_label_base_string = "%+.2f",
                                    map_legend_ndecimals = 0)   
Canopy_snow_interception <- list(stored_name="OUT_SNOW_CANOPY",
                                 description="Snow interception storage in canopy",
                                 plot_var_str = 'SWE<sub>can</sub>',
                                 units="mm",
                                 subplot_label = "Canopy snow",
                                 flux_type = FALSE,
                                 changes_as_a_percentage = FALSE,
                                 mann_color="YlGnBu",
                                 change_color="BrBG",
                                 climate_change_thres=20,
                                 forest_change_thres=10,
                                 change_nbins=11,
                                 map_basin_label_base_string = "%+.2f",
                                 map_legend_ndecimals = 0)
Snow_water_equivalent <- list(stored_name="OUT_SWE",
                              description="Snow water equivalent in snow pack (including vegetation-intercepted snow)",
                              plot_var_str = 'SWE',
                              units="mm",
                              subplot_label = "Snow water equivalent",
                              flux_type = FALSE,
                              changes_as_a_percentage = FALSE,
                              mann_color="YlGnBu",
                              change_color="BrBG",
                              climate_change_thres=50,
                              forest_change_thres=25,
                              change_nbins=11,
                              map_basin_label_base_string = "%+.2f",
                              map_legend_ndecimals = 0)
Surface_albedo <- list(stored_name="OUT_ALBEDO",
                       description="Average surface albedo",
                       plot_var_str = '&alpha;',
                       units="fraction",
                       subplot_label = "Surface albedo",
                       flux_type = FALSE,
                       changes_as_a_percentage = FALSE,
                       mann_color="Spectral_rev",
                       change_color="Spectral",
                       climate_change_thres=50,
                       forest_change_thres=50,
                       change_nbins=11,
                       map_basin_label_base_string = "%+.2f",
                       map_legend_ndecimals = 0)
Air_temperature <- list(stored_name="OUT_AIR_TEMP",
                        description="Air temperature",
                        plot_var_str = 'T',
                        subplot_label = "Air temperature",
                        flux_type = FALSE,
                        units="<sup>o</sup>C",
                        changes_as_a_percentage = FALSE,
                        mann_color="YlOrRd",
                        change_color="Spectral",
                        climate_change_thres=9,
                        forest_change_thres=9,
                        change_nbins=11,
                        map_basin_label_base_string = "%+.2f",
                        map_legend_ndecimals = 0)
Surface_temperature <- list(stored_name="OUT_SURF_TEMP",
                            description="Surface temperature",
                            plot_var_str = 'T<sub>surf</sub>',
                            units="<sup>o</sup>C",
                            subplot_label = "Surface temperature",
                            flux_type = FALSE,
                            changes_as_a_percentage = FALSE,
                            mann_color="YlOrRd",
                            change_color="RdYlBu",
                            climate_change_thres=9,
                            forest_change_thres=9,
                            change_nbins=11,
                            map_basin_label_base_string = "%+.2f",
                            map_legend_ndecimals = 0)
Total_soil_moisture <- list(stored_name="OUT_SOIL_MOIST_TOTAL",
                            description="Total soil moisture across all three layers",
                            plot_var_str = 'SM',
                            units="mm",
                            subplot_label = "Soil moisture",
                            flux_type = FALSE,
                            changes_as_a_percentage = FALSE,
                            mann_color="YlGnBu",
                            change_color="BrBG",
                            climate_change_thres=200,
                            forest_change_thres=100,
                            change_nbins=11,
                            map_basin_label_base_string = "%+.2f",
                            map_legend_ndecimals = 0)
Total_precipitation <- list(stored_name="OUT_PREC",
                            description="Total precipitation",
                            plot_var_str = 'P',
                            subplot_label = "Total precipitation",
                            units="mm",
                            flux_type = TRUE,
                            changes_as_a_percentage = TRUE,
                            mann_color="YlGnBu",
                            change_color="BrBG",
                            climate_change_thres=200,
                            forest_change_thres=50,
                            change_nbins=11,
                            map_basin_label_base_string = "%+.2f",
                            map_legend_ndecimals = 0)
Rainfall <- list(stored_name="OUT_RAINF",
                 description="Rainfall",
                 plot_var_str = 'P<sub>R</sub>',
                 units="mm",
                 subplot_label = "Rainfall",
                 flux_type = TRUE,
                 changes_as_a_percentage = TRUE,
                 mann_color="YlGnBu",
                 change_color="BrBG",
                 climate_change_thres=100,
                 forest_change_thres=25,
                 change_nbins=11,
                 map_basin_label_base_string = "%+.2f",
                 map_legend_ndecimals = 0)
Snowfall <- list(stored_name="OUT_SNOWF",
                 description="Snowfall",
                 plot_var_str = 'P<sub>S</sub>',
                 units="mm",
                 subplot_label = "Snowfall",
                 flux_type = TRUE,
                 changes_as_a_percentage = TRUE,
                 mann_color="YlGnBu",
                 change_color="BrBG",
                 climate_change_thres=100,
                 forest_change_thres=25,
                 change_nbins=11,
                 map_basin_label_base_string = "%+.2f",
                 map_legend_ndecimals = 0)
Total_evapotranspiration <- list(stored_name="OUT_EVAP",
                                 description="Total net evapotranspiration (including sublimation)",
                                 plot_var_str = 'ET',
                                 units="mm",
                                 subplot_label = "Total evapotranspiration",
                                 flux_type = TRUE,
                                 changes_as_a_percentage = TRUE,
                                 mann_color="YlGnBu",
                                 change_color="BrBG",
                                 climate_change_thres=200,
                                 forest_change_thres=25,
                                 change_nbins=11,
                                 map_basin_label_base_string = "%+.2f",
                                 map_legend_ndecimals = 0)
Canopy_evaporation <- list(stored_name="OUT_EVAP_CANOP",
                           description="Net evaporation from canopy interception",
                           plot_var_str = 'E<sub>c</sub>',
                           units="mm",
                           subplot_label = "Canopy evaporation",
                           flux_type = TRUE,
                           changes_as_a_percentage = TRUE,
                           mann_color="YlGnBu",
                           change_color="BrBG",
                           climate_change_thres=20,
                           forest_change_thres=10,
                           change_nbins=11,
                           map_basin_label_base_string = "%+.2f",
                           map_legend_ndecimals = 0)
Plant_transpiration <- list(stored_name="OUT_TRANSP_VEG",
                            description="Net transpiration from vegetation",
                            plot_var_str = 'T<sub>v</sub>',
                            units="mm",
                            subplot_label = "Transpiration",
                            flux_type = TRUE,
                            changes_as_a_percentage = TRUE,
                            mann_color="YlGnBu",
                            change_color="BrBG",
                            climate_change_thres=30,
                            forest_change_thres=30,
                            change_nbins=11,
                            map_basin_label_base_string = "%+.2f",
                            map_legend_ndecimals = 0)
Soil_evaporation <- list(stored_name="OUT_EVAP_BARE",
                         description="Net evaporation from bare soil",
                         plot_var_str = 'E<sub>soil</sub>',
                         units="mm",
                         subplot_label = "Soil evaporation",
                         flux_type = TRUE,
                         changes_as_a_percentage = TRUE,
                         mann_color="YlGnBu",
                         change_color="BrBG",
                         climate_change_thres=30,
                         forest_change_thres=30,
                         change_nbins=11,
                         map_basin_label_base_string = "%+.2f",
                         map_legend_ndecimals = 0)
Runoff <- list(stored_name="OUT_RUNOFF",
               description="Surface runoff",
               plot_var_str = 'R',
               units="mm",
               subplot_label = "Runoff",
               flux_type = TRUE,
               changes_as_a_percentage = TRUE,
               mann_color="YlGnBu",
               change_color="BrBG",
               climate_change_thres=50,
               forest_change_thres=25,
               change_nbins=11,
               map_basin_label_base_string = "%+.2f",
               map_legend_ndecimals = 0)
Baseflow <- list(stored_name="OUT_BASEFLOW",
                 description="Baseflow out of the bottom layer",
                 plot_var_str = 'BF',
                 units="mm",
                 subplot_label = "Baseflow",
                 flux_type = TRUE,
                 changes_as_a_percentage = TRUE,
                 mann_color="YlGnBu",
                 change_color="BrBG",
                 climate_change_thres=50,
                 forest_change_thres=25,
                 change_nbins=11,
                 map_basin_label_base_string = "%+.2f",
                 map_legend_ndecimals = 0)
Snowmelt <- list(stored_name="OUT_SNOW_MELT",
                 description="Snow melt",
                 plot_var_str = 'M',
                 units="mm",
                 subplot_label = "Snowmelt",
                 flux_type = TRUE,
                 changes_as_a_percentage = TRUE,
                 mann_color="YlGnBu",
                 change_color="BrBG",
                 climate_change_thres=100,
                 forest_change_thres=25,
                 change_nbins=11,
                 map_basin_label_base_string = "%+.2f",
                 map_legend_ndecimals = 0)
Soil_inflow <- list(stored_name="OUT_INFLOW",
                    description="Moisture that reaches top of soil column",
                    plot_var_str = 'I',
                    units="mm",
                    subplot_label = "Soil inflow",
                    flux_type = TRUE,
                    changes_as_a_percentage = TRUE,
                    mann_color="YlGnBu",
                    change_color="BrBG",
                    climate_change_thres=100,
                    forest_change_thres=50,
                    change_nbins=11,
                    map_basin_label_base_string = "%+.2f",
                    map_legend_ndecimals = 0)
Potential_evapotranspiration <- list(stored_name="OUT_PET",
                                     description="Potential evapotranspiration (= area-weighted sum of potential transpiration and potential soil evaporation). Potential transpiration is computed using the Penman-Monteith eqn with architectural resistance and LAI of the current veg cover.",
                                     plot_var_str = 'PET',
                                     units="mm",
                                     subplot_label = "Potential evapotranspiration",
                                     flux_type = TRUE,
                                     changes_as_a_percentage = TRUE,
                                     mann_color="YlGnBu",
                                     change_color="BrBG_rev",
                                     climate_change_thres=400,
                                     forest_change_thres=200,
                                     change_nbins=11,
                                     map_basin_label_base_string = "%+.2f",
                                     map_legend_ndecimals = 0)
Streamflow_cubic_km <- list(stored_name="streamflow_cubic_km",
                            description="Streamflow (channel routed runoff and baseflow)",
                            plot_var_str = 'Q',
                            units="km<sup>3</sup>",
                            subplot_label = "Streamflow",
                            flux_type = TRUE,
                            changes_as_a_percentage = TRUE)
Streamflow_maf <- list(stored_name="streamflow_maf",
                       description="Streamflow (channel routed runoff and baseflow)",
                       plot_var_str = 'Q',
                       units="MAF",
                       subplot_label = "Streamflow",
                       flux_type = TRUE,
                       changes_as_a_percentage = TRUE)
Total_runoff_baseflow <- list(stored_name="OUT_RUNOFF_BASEFLOW_SUM",
                             description="Total runoff + baseflow",
                             plot_var_str = 'RBF',
                             units="mm",
                             subplot_label = "Runoff + baseflow",
                             flux_type = TRUE,
                             changes_as_a_percentage = TRUE,
                             mann_color="YlGnBu",
                             change_color="BrBG",
                             climate_change_thres=100,
                             forest_change_thres=50,
                             change_nbins=11,
                             map_basin_label_base_string = "%+.2f",
                             map_legend_ndecimals = 0)
Sublimation <- list(stored_name="OUT_SUB_SNOW",
                    description="Snowpack sublimation",
                    plot_var_str = 'E<sub>s</sub>',
                    units="mm",
                    subplot_label = "Sublimation",
                    flux_type = TRUE,
                    changes_as_a_percentage = TRUE,
                    mann_color="YlGnBu",
                    change_color="BrBG",
                    climate_change_thres=20,
                    forest_change_thres=10,
                    change_nbins=11,
                    map_basin_label_base_string = "%+.2f",
                    map_legend_ndecimals = 0)
Runoff_efficiency <- list(stored_name="R_efficiency",
                          description="Runoff efficiency (runoff per precipitation)",
                          plot_var_str = 'RE',
                          subplot_label = "Runoff efficiency",
                          units="-",
                          flux_type = FALSE,
                          changes_as_a_percentage = TRUE,
                          mann_color="YlGnBu",
                          change_color="BrBG",
                          climate_change_thres=0.06,
                          forest_change_thres=0.06,
                          change_nbins=11,
                          map_basin_label_base_string = "%+.3f",
                          map_legend_ndecimals = 2)
Baseflow_efficiency <- list(stored_name="BF_efficiency",
                            description="Baseflow efficiency (baseflow per precipitation)",
                            plot_var_str = 'BFE',
                            subplot_label = "Baseflow efficiency",
                            units="-",
                            flux_type = FALSE,
                            changes_as_a_percentage = TRUE,
                            mann_color="YlGnBu",
                            change_color="BrBG",
                            climate_change_thres=0.06,
                            forest_change_thres=0.06,
                            change_nbins=11,
                            map_basin_label_base_string = "%+.3f",
                            map_legend_ndecimals = 2)
Runoff_baseflow_efficiency <- list(stored_name="R_BF_efficiency",
                                   description="Total runoff and baseflow efficiency (total runoff + baseflow per precipitation)",
                                   plot_var_str = 'RBFE',
                                   units="-",
                                   subplot_label = "Efficiency",
                                   flux_type = FALSE,
                                   changes_as_a_percentage = TRUE,
                                   mann_color="YlGnBu",
                                   change_color="BrBG",
                                   climate_change_thres=0.06,
                                   forest_change_thres=0.06,
                                   change_nbins=11,
                                   map_basin_label_base_string = "%+.3f",
                                   map_legend_ndecimals = 2)
Rainfall_fraction <- list(stored_name="OUT_RAINFRACT",
                          description="Fraction of precipitation as rainfall",
                          plot_var_str = 'RF',
                          units="-",
                          subplot_label = "Rainfall fraction",
                          flux_type = FALSE,
                          changes_as_a_percentage = TRUE,
                          mann_color="YlOrRd",
                          change_color="RdYlBu",
                          climate_change_thres=0.15,
                          forest_change_thres=0.15,
                          change_nbins=11,
                          map_basin_label_base_string = "%+.3f",
                          map_legend_ndecimals = 2)
Evaporative_index <- list(stored_name="EI",
                          description="Evaporative index (actual evapotranspiration per total precipitation)",
                          plot_var_str = 'EI',
                          subplot_label = "Evaporative index",
                          units="-",
                          flux_type = FALSE,
                          changes_as_a_percentage = TRUE,
                          mann_color="YlGnBu",
                          change_color="BrBG",
                          climate_change_thres=0.06,
                          forest_change_thres=0.06,
                          change_nbins=11,
                          map_basin_label_base_string = "%+.3f",
                          map_legend_ndecimals = 2)
Dryness_index <- list(stored_name="DI",
                      description="Dryness index (potential evapotranspiration per total precipitation)",
                      plot_var_str = 'DI',
                      units="-",
                      subplot_label = "Dryness index",
                      flux_type = FALSE,
                      changes_as_a_percentage = TRUE,
                      mann_color="YlGnBu",
                      change_color="BrBG",
                      climate_change_thres=0.06,
                      forest_change_thres=0.06,
                      change_nbins=11,
                      map_basin_label_base_string = "%+.3f",
                      map_legend_ndecimals = 2)
var_info_dict <- list("Canopy water"=Canopy_moisture_interception,
                      "Canopy snow"=Canopy_snow_interception,
                      "Snow water equivalent"=Snow_water_equivalent,
                      "Surface albedo"=Surface_albedo,
                      "Air temperature"=Air_temperature,
                      "Surface temperature"=Surface_temperature,
                      "Soil moisture"=Total_soil_moisture,
                      "Total precipitation"=Total_precipitation,
                      "Rainfall"=Rainfall,
                      "Snowfall"=Snowfall,
                      "Total evapotranspiration"=Total_evapotranspiration,
                      "Canopy evaporation"=Canopy_evaporation,
                      "Plant transpiration"=Plant_transpiration,
                      "Soil evaporation"=Soil_evaporation,
                      "Runoff"=Runoff,
                      "Baseflow"=Baseflow,
                      "Snowmelt"=Snowmelt,
                      "Soil inflow"=Soil_inflow,
                      "Potential evapotranspiration"=Potential_evapotranspiration,
                      "Streamflow ([cubic km])"=Streamflow_cubic_km,
                      "Streamflow ([MAF])"=Streamflow_maf,
                      "Flow supply (runoff + baseflow)"=Total_runoff_baseflow,
                      "Sublimation"=Sublimation,
                      "Runoff efficiency (R/P)"=Runoff_efficiency,
                      "Baseflow efficiency (BF/P)"=Baseflow_efficiency,
                      "Efficiency ([runoff + baseflow]/precipitation)"=Runoff_baseflow_efficiency,
                      "Rainfall fraction (rain/P)"=Rainfall_fraction,
                      "Evaporative index (ET/P)"=Evaporative_index,
                      "Dryness index (PET/P)"=Dryness_index
)

## --------------------------Dictionaries of visible variables for each analysis type---------------------------------## ----
var_visible_wat_ann <- c(
  "Streamflow ([cubic km])",
  "Streamflow ([MAF])",
  "Snow water equivalent",
  "Total evapotranspiration",
  "Flow supply (runoff + baseflow)",
  "Total precipitation",
  "Rainfall",
  "Snowfall",
  "Air temperature",
  # "Canopy water",
  # "Canopy snow",
  "Canopy evaporation",
  "Sublimation",
  "Snowmelt",
  "Plant transpiration",
  "Soil evaporation",
  "Efficiency ([runoff + baseflow]/precipitation)"
  )

var_visible_wat_mon <- c(
  "Streamflow ([cubic km])",
  "Streamflow ([MAF])",
  "Snow water equivalent",
  "Total evapotranspiration",
  "Flow supply (runoff + baseflow)",
  "Total precipitation",
  "Rainfall",
  "Snowfall",
  "Air temperature",
  # "Canopy water",
  # "Canopy snow",
  "Canopy evaporation",
  "Sublimation",
  "Snowmelt",
  "Plant transpiration",
  "Soil evaporation"
  # "Efficiency ([runoff + baseflow]/precipitation)"
)

var_visible_spatial <- c(
  "Snow water equivalent",
  "Total evapotranspiration",
  "Flow supply (runoff + baseflow)",
  "Total precipitation",
  "Rainfall",
  "Snowfall",
  "Soil moisture",
  "Air temperature",
  # "Canopy water",
  # "Canopy snow",
  "Canopy evaporation",
  "Sublimation",
  "Snowmelt",
  "Plant transpiration",
  "Soil evaporation",
  "Efficiency ([runoff + baseflow]/precipitation)"
)
## --------------------------Dictionaries of plot settings for each analysis type---------------------------------## ----

plot_specs_wat_ann_barchart<-list(
  "scenario_marker_specs"=list(
    "Baseline_hist_0perc" = list(color=rgb(0,0,0),line=list(color=rgb(0,0,0),width=1)),
    "Period_3_hist_0perc" = list(color=rgb(0.9000,0.9000,0.9000)),
    "Period_3_a2_0perc" =list(color=rgb( 0,0.4470,0.7410)),
    "Period_3_a2_10perc" = list(color=rgb(0.8500,0.3250,0.0980)),
    "Period_3_a2_30perc" = list(color=rgb(0.9290,0.6940,0.1250)),
    "Period_3_a2_60perc" = list(color=rgb(0.4940,0.1840,0.5560)),
    "Period_3_a2_90perc" =list(color=rgb(0.4660,0.6740,0.1880))
  ),
  "scenario_legendgroup_names"=list(
    "Baseline_hist_0perc" = 'Baseline',
    "Period_3_hist_0perc"= 'Far-Future Climate-only',
    "Period_3_a2_0perc" = 'Far-Future Climate + LULC (0% Disturbance)',
    "Period_3_a2_10perc" = 'Far-Future Climate + LULC (10% Disturbance)',
    "Period_3_a2_30perc" = 'Far-Future Climate + LULC (30% Disturbance)',
    "Period_3_a2_60perc" = 'Far-Future Climate + LULC (60% Disturbance)',
    "Period_3_a2_90perc" = 'Far-Future Climate + LULC (90% Disturbance)'
  ),
  "plot_description" = paste("Mean annual values in the Baseline (1976-2005)",
                             "and Far-Future (2066-2095) periods for different land-use",
                             "land-cover (LULC) scenarios under Warm/Wet and",
                             "Hot/Dry climates. The \'Far-Future Climate-Only\' scenario used Baseline LULC (no change in LULC).",
                             "Other Far-Future scenarios included high-elevation forest disturbances (reduced by 0%, 10%, 30%, 60%, or 90%),",
                             "applied to Far-Future LULC.",
                             "Dotted horizontal lines show",
                             "Baseline values as a reference.")
)

plot_specs_wat_ann_change_line<-list(
  "marker_specs"=list(
    "b1_Warm_Wet" = list(size=10,symbol="circle-open",color=rgb(0,0,0),line=list(width=2)),
    "b1_Hot_Dry" = list(size=10,symbol="square-open",color=rgb(0,0,0),line=list(width=2)),
    "b2_Warm_Wet" =list(size=10,symbol="circle-open",color=rgb(0.8500,0.3250,0.0980),line=list(width=2)),
    "b2_Hot_Dry" = list(size=10,symbol="square-open",color=rgb(0.8500,0.3250,0.0980),line=list(width=2))
  ),
  "line_specs"=list(
    "b1_Warm_Wet" = list(color=rgb(0,0,0)),
    "b1_Hot_Dry" = list(color=rgb(0,0,0),dash = 'dash'),
    "b2_Warm_Wet" = list(color=rgb(0.8500,0.3250,0.0980)),
    "b2_Hot_Dry" = list(color=rgb(0.8500,0.3250,0.0980),dash = 'dash')
  ),
  "plot_description" = list(
    "relative" = paste("Changes in Far-Future (2066-2095) in mean annual values",
                       "for each forest disturbance case under the",
                       "Warm/Wet and Hot/Dry climates,",
                       "relative to the Basline (1976-2005) period.",
                       "Changes in fluxes are computed as a relative percentage",
                       "and storages are computed as an absolute difference."),
    "absolute" = paste("Changes in Far-Future (2066-2095) mean annual values",
                       "for each forest disturbance case under the",
                       "Warm/Wet and Hot/Dry climates,",
                       "relative to the Basline (1976-2005) period.",
                       "Changes are computed as as an absolute difference.")
  )
)

plot_specs_wat_monthly_line<-list(
  "marker_specs"=list(
    "hist_0perc" = list(color=rgb(0,0,0)),
    "a2_0perc" = list(color=rgb( 0,0.4470,0.7410)),
    "a2_10perc" =list(color=rgb(0.8500,0.3250,0.0980)),
    "a2_30perc" = list(color=rgb(0.9290,0.6940,0.1250)),
    "a2_60perc" = list(color=rgb(0.4940,0.1840,0.5560)),
    "a2_90perc" = list(color=rgb(0.4660,0.6740,0.1880))
    
  ),
  "line_specs"=list(
    "hist_0perc" = list(color=rgb(0,0,0)),
    "a2_0perc" = list(color=rgb( 0,0.4470,0.7410)),
    "a2_10perc" = list(color=rgb(0.8500,0.3250,0.0980),dash = 'dash'),
    "a2_30perc" = list(color=rgb(0.9290,0.6940,0.1250),dash = 'dash'),
    "a2_60perc" = list(color=rgb(0.4940,0.1840,0.5560),dash = 'dash'),
    "a2_90perc" = list(color=rgb(0.4660,0.6740,0.1880),dash = 'dash')
    
  ),
  "scenario_legendgroup_names"=list(
    "hist_0perc" = 'Baseline',
    "a2_0perc" = 'Far-Future Climate + LULC (0% Disturbance)',
    "a2_10perc" = 'Far-Future Climate + LULC (10% Disturbance)',
    "a2_30perc" = 'Far-Future Climate + LULC (30% Disturbance)',
    "a2_60perc" = 'Far-Future Climate + LULC (60% Disturbance)',
    "a2_90perc" = 'Far-Future Climate + LULC (90% Disturbance)'
  ),
  "plot_description" = paste("Mean monthly values in the Baseline (1976-2005)",
                             "and Far-Future (2066-2095) periods for each",
                             "forest disturbance case (0, 10, 30, 60, or 90%)",
                             "under Warm/Wet (left) and Hot/Dry (right) climates."
                             # "<br>Comparison of the \'0% Disturbance\' case to the Baseline",
                             # "indicates the climate impacts.<br>",
                             # "Comparisons of the \'0% Disturbance\' case to any other disturbance case (10-90%)",
                             # "indicate the forest disturbance impacts."
                             )
)

## --------------------------Dictionary of Spatial-Analyses input arguments---------------------------------## ----

spatial_input_argument_dictionary <- list(
  impact_scenarios = list(
    "Climate change" = list(
      stored_name = "climate_impact",
      input_file_prefix = "fluxes.foresce_a2_y2099_thinning_to_shrub.0perc_forest_to_grass.",
      lulc_stored = "a2_0perc",
      input_file_suffix = list(
        Warm_Wet ="CanESM2_rcp45.anom_mann.2066_2095.nc",
        Hot_Dry ="IPSL-CM5A-MR_rcp85.anom_mann.2066_2095.nc"
      ),
      plot_description = list(
        "Annual (Oct-Sep)" = "Spatial distributions of mean annual (Oct. through Sep.) changes (\u0394) in the Far-Future (2066-2095) period relative to Baseline (1976-2005) under Warm/Wet and Hot/Dry climates without forest disturbances.",
        "Cool-Season (Oct-Mar)" = "Spatial distributions of mean cool-season (Oct. through Mar.) changes (\u0394) in the Far-Future (2066-2095) period relative to Baseline (1976) under Warm/Wet and Hot/Dry climates without forest disturbances.",
        "Warm-Season (Apr-Sep)" = "Spatial distributions of mean warm-season (Apr. through Sep.) changes (\u0394) in the Far-Future (2066-2095) period relative to Baseline (1976) under Warm/Wet and Hot/Dry climates without forest disturbances."
      )
    ),
    "10% Forest disturbance" = list(
      stored_name = "forest_impact",
      input_file_prefix = "fluxes.foresce_a2_y2099_thinning_to_shrub.10perc_forest_to_grass.dist_elev_1800m_or_above.",
      lulc_stored = "a2_10perc",
      input_file_suffix = list(
        Warm_Wet ="CanESM2_rcp45.mann.2066_2095.no_dist_diff.nc",
        Hot_Dry ="IPSL-CM5A-MR_rcp85.mann.2066_2095.no_dist_diff.nc"
      ),
      plot_description = list(
        "Annual (Oct-Sep)" = "Spatial distributions of mean annual (Oct. through Sep.) changes (\u0394) under the 10% forest disturbance case relative to no disturbance in the Far-Future (2066-2095) period under Warm/Wet and Hot/Dry climates without forest disturbances.",
        "Cool-Season (Oct-Mar)" = "Spatial distributions of mean cool-season (Oct. through Mar.) changes (\u0394) under the 10% forest disturbance case relative to no disturbance in the Far-Future (2066-2095) period under Warm/Wet and Hot/Dry climates without forest disturbances.",
        "Warm-Season (Apr-Sep)" = "Spatial distributions of mean warm-season (Apr. through Sep.) changes (\u0394) under the 10% forest disturbance case relative to no disturbance in the Far-Future (2066-2095) period under Warm/Wet and Hot/Dry climates without forest disturbances."
      )
    ),
    "30% Forest disturbance" = list(
      stored_name = "forest_impact",
      input_file_prefix = "fluxes.foresce_a2_y2099_thinning_to_shrub.30perc_forest_to_grass.dist_elev_1800m_or_above.",
      lulc_stored = "a2_30perc",
      input_file_suffix = list(
        Warm_Wet ="CanESM2_rcp45.mann.2066_2095.no_dist_diff.nc",
        Hot_Dry ="IPSL-CM5A-MR_rcp85.mann.2066_2095.no_dist_diff.nc"
      ),
      plot_description = list(
        "Annual (Oct-Sep)" = "Spatial distributions of mean annual (Oct. through Sep.) changes (\u0394) under the 30% Forest disturbance case relative to no disturbance in the Far-Future (2066-2095) period under Warm/Wet and Hot/Dry climates without forest disturbances.",
        "Cool-Season (Oct-Mar)" = "Spatial distributions of mean cool-season (Oct. through Mar.) changes (\u0394) under the 30% Forest disturbance case relative to no disturbance in the Far-Future (2066-2095) period under Warm/Wet and Hot/Dry climates without forest disturbances.",
        "Warm-Season (Apr-Sep)" = "Spatial distributions of mean warm-season (Apr. through Sep.) changes (\u0394) under the 30% Forest disturbance case relative to no disturbance in the Far-Future (2066-2095) period under Warm/Wet and Hot/Dry climates without forest disturbances."
      )
    ),
    "60% Forest disturbance" = list(
      stored_name = "forest_impact",
      input_file_prefix = "fluxes.foresce_a2_y2099_thinning_to_shrub.60perc_forest_to_grass.dist_elev_1800m_or_above.",
      lulc_stored = "a2_60perc",
      input_file_suffix = list(
        Warm_Wet ="CanESM2_rcp45.mann.2066_2095.no_dist_diff.nc",
        Hot_Dry ="IPSL-CM5A-MR_rcp85.mann.2066_2095.no_dist_diff.nc"
      ),
      plot_description = list(
        "Annual (Oct-Sep)" = "Spatial distributions of mean annual (Oct. through Sep.) changes (\u0394) under the 60% forest disturbance case relative to no disturbance in the Far-Future (2066-2095) period under Warm/Wet and Hot/Dry climates without forest disturbances.",
        "Cool-Season (Oct-Mar)" = "Spatial distributions of mean cool-season (Oct. through Mar.) changes (\u0394) under the 60% forest disturbance case relative to no disturbance in the Far-Future (2066-2095) period under Warm/Wet and Hot/Dry climates without forest disturbances.",
        "Warm-Season (Apr-Sep)" = "Spatial distributions of mean warm-season (Apr. through Sep.) changes (\u0394) under the 60% forest disturbance case relative to no disturbance in the Far-Future (2066-2095) period under Warm/Wet and Hot/Dry climates without forest disturbances."
      )
    ),
    "90% Forest disturbance" = list(
      stored_name = "forest_impact",
      input_file_prefix = "fluxes.foresce_a2_y2099_thinning_to_shrub.90perc_forest_to_grass.dist_elev_1800m_or_above.",
      lulc_stored = "a2_90perc",
      input_file_suffix = list(
        Warm_Wet ="CanESM2_rcp45.mann.2066_2095.no_dist_diff.nc",
        Hot_Dry ="IPSL-CM5A-MR_rcp85.mann.2066_2095.no_dist_diff.nc"
      ),
      plot_description = list(
        "Annual (Oct-Sep)" = "Spatial distributions of mean annual (Oct. through Sep.) changes (\u0394) under the 90% forest disturbance case relative to no disturbance in the Far-Future (2066-2095) period under Warm/Wet and Hot/Dry climates without forest disturbances.",
        "Cool-Season (Oct-Mar)" = "Spatial distributions of mean cool-season (Oct. through Mar.) changes (\u0394) under the 90% forest disturbance case relative to no disturbance in the Far-Future (2066-2095) period under Warm/Wet and Hot/Dry climates without forest disturbances.",
        "Warm-Season (Apr-Sep)" = "Spatial distributions of mean warm-season (Apr. through Sep.) changes (\u0394) under the 90% forest disturbance case relative to no disturbance in the Far-Future (2066-2095) period under Warm/Wet and Hot/Dry climates without forest disturbances."
      )
    )
  ),
  temporal_scales = list(
    "Annual (Oct-Sep)" = list(
      stored_name= "annual",
      scale_legend_units = "yr"),
    "Cool-Season (Oct-Mar)" = list(
      stored_name= "cool_season",
      scale_legend_units = "seas"),
    "Warm-Season (Apr-Sep)" = list(
      stored_name= "warm_season",
      scale_legend_units = "seas")),
  input_file_directory = "./data/netcdf/"
  
)

## --------------------------Dictionaries of guided analyses for each analysis type---------------------------------## ----
guided_analyses_wat_ann <- list(
  "wat_ann_analysis_1" = list(
    "wat_ann_basin_selected_1" = "Upper Basin",
    "wat_ann_basin_selected_2" = "Lower Basin",
    "wat_ann_var_selected_1" = "Total precipitation",
    "wat_ann_var_selected_2" = "Air temperature",
    "wat_ann_plot_type_selected" = 1
),
  "wat_ann_analysis_2" = list(
    "wat_ann_basin_selected_1" = "Basin-wide",
    "wat_ann_basin_selected_2" = "Upper Basin",
    "wat_ann_var_selected_1" = "Snow water equivalent",
    "wat_ann_var_selected_2" = "Snowfall",
    "wat_ann_plot_type_selected" = 1
  ),
  "wat_ann_analysis_3" = list(
    "wat_ann_basin_selected_1" = "Upper Basin",
    "wat_ann_basin_selected_2" = "Lower Basin",
    "wat_ann_var_selected_1" = "Total evapotranspiration",
    "wat_ann_var_selected_2" = "Total precipitation",
    "wat_ann_plot_type_selected" = 1
  ),
  "wat_ann_analysis_4" = list(
    "wat_ann_basin_selected_1" = "Basin-wide",
    "wat_ann_basin_selected_2" = "Upper Basin",
    "wat_ann_var_selected_1" = "Streamflow ([cubic km])",
    "wat_ann_var_selected_2" = "Total precipitation",
    "wat_ann_plot_type_selected" = 1
  ),
  "wat_ann_analysis_5" = list(
    "wat_ann_basin_selected_1" = "Green",
    "wat_ann_basin_selected_2" = "Upper Basin",
    "wat_ann_var_selected_1" = "Streamflow ([cubic km])",
    "wat_ann_var_selected_2" = "Efficiency ([runoff + baseflow]/precipitation)",
    "wat_ann_plot_type_selected" = 2
  ),
  "wat_ann_analysis_conclusions" = list(
    "wat_ann_basin_selected_1" = "Basin-wide",
    "wat_ann_basin_selected_2" = "Upper Basin",
    "wat_ann_var_selected_1" = "Snow water equivalent",
    "wat_ann_var_selected_2" = "Streamflow ([cubic km])",
    "wat_ann_plot_type_selected" = 1
  )
)

guided_analyses_wat_mon <- list(
  "wat_mon_analysis_1" = list(
    "wat_mon_basin_selected" = "Basin-wide",
    "wat_mon_var_selected_1" = "Snow water equivalent",
    "wat_mon_var_selected_2" = "Snowmelt",
    "wat_mon_var_selected_3" = "Sublimation"
  ),
  "wat_mon_analysis_2" = list(
    "wat_mon_basin_selected" = "Basin-wide",
    "wat_mon_var_selected_1" = "Streamflow ([cubic km])",
    "wat_mon_var_selected_2" = "Snowmelt",
    "wat_mon_var_selected_3" = "Total evapotranspiration"
  ),
  "wat_mon_analysis_conclusions" = list(
    "wat_mon_basin_selected" = "Basin-wide",
    "wat_mon_var_selected_1" = "Streamflow ([cubic km])",
    "wat_mon_var_selected_2" = "Snowmelt",
    "wat_mon_var_selected_3" = "Total evapotranspiration"
  )
)

guided_analyses_spatial <- list(
  "spatial_analysis_1" = list(
    "spatial_var_selected_1" = "Snow water equivalent",
    "spatial_var_selected_2" = "Snowmelt",
    "spatial_temporal_scale_selected" = "Annual (Oct-Sep)",
    "spatial_impact_type_selected" = "Climate change"
  ),
  "spatial_analysis_2" = list(
    "spatial_var_selected_1" = "Total evapotranspiration",
    "spatial_var_selected_2" = "Total precipitation",
    "spatial_temporal_scale_selected" = "Annual (Oct-Sep)",
    "spatial_impact_type_selected" = "Climate change"
  ),
  "spatial_analysis_3" = list(
    "spatial_var_selected_1" = "Flow supply (runoff + baseflow)",
    "spatial_var_selected_2" = "Soil moisture",
    "spatial_temporal_scale_selected" = "Annual (Oct-Sep)",
    "spatial_impact_type_selected" = "Climate change"
  ),
  "spatial_analysis_4" = list(
    "spatial_var_selected_1" = "Efficiency ([runoff + baseflow]/precipitation)",
    "spatial_var_selected_2" = "Total evapotranspiration",
    "spatial_temporal_scale_selected" = "Annual (Oct-Sep)",
    "spatial_impact_type_selected" = "Climate change"
  ),
  "spatial_analysis_conclusions" = list(
    "spatial_var_selected_1" = "Snow water equivalent",
    "spatial_var_selected_2" = "Total evapotranspiration",
    "spatial_temporal_scale_selected" = "Annual (Oct-Sep)",
    "spatial_impact_type_selected" = "30% Forest disturbance"
  ),
  "spatial_analysis_implications" = list(
    "spatial_var_selected_1" = "Efficiency ([runoff + baseflow]/precipitation)",
    "spatial_var_selected_2" = "Flow supply (runoff + baseflow)",
    "spatial_temporal_scale_selected" = "Annual (Oct-Sep)",
    "spatial_impact_type_selected" = "30% Forest disturbance"
  )
)


