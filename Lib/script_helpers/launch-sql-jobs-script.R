##   --- --- --- --- --- --- --- --- --- --- 
## DO NOT EDIT THIS FILE                     
## MODIFY THE VERSION IN Path_dependent_files
if(sys.nframe() == 0) file.edit("Path_dependent_files/./Lib/script_helpers/launch-sql-jobs-script.R")
##   --- --- --- --- --- --- --- --- --- --- 

source("/sasdata/prd/users/42a001092210899/sasuser/RStudio_projects/_SNDS_TOOLS/Lib/common/01_minimal_packages.R")
setup_connection()
setwd("..")
run_sql_file("<path-to-file>")

list_results <- list_results