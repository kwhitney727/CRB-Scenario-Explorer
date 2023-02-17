## --------------------------------------------------------------------------------------##
##
## Script name: app.R
##
## Purpose of the script: Main app file, pointing to server and ui source files.
##
## @author: Kristen Whitney
##
## Created on Fri Sept 19 2022
##
##
## --------------------------------------------------------------------------------------##
##    Notes:
##    The main script of the CRB-Scenario-Explorer website package The app.R script
##    is used to set up and launch the VIC-Explorer website user interface and 
##    server. More information on this to come.

##    Colorado River Basin Scenario Explorer (CRB-Scenario-Explorer)
##    Created by Kristen M. Whitney, School of Earth and Space Exploration, 
##    Arizona State University.

##    This program is free software: You can redistribute it and/or modify
##    it under the terms of the GNU General Public License as published by
##    the Free Software Foundation, either version 3 of the License, or
##    (at your option) any later version.

##    This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
##    GNU General Public License for more details.

##    You should have received a copy of the GNU General Public License
##    along with this program.If not, see <http://www.gnu.org/licenses/>.
##
## --------------------------------------------------------------------------------------##
## ----------------------------------Load packages---------------------------------------##

# Load packages and source ----
library(shiny,quietly=TRUE,warn.conflicts = FALSE)
## ----------------------------------Run the app-----------------------------------------##
shinyApp(ui.R, server.R)
