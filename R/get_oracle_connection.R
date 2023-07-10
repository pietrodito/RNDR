get_oracle_connection <- function() {
  library(ROracle)

  drv <- dbDriver("Oracle")
  the$oracle <- dbConnect(drv, dbname = "IPIAMPR2.WORLD")

  synchronize_time_zone()

  populate_table_names()

  invisible(the$oracle)
}

synchronize_time_zone <- function() {
  Sys.setenv(TZ = "Europe/Paris")
  Sys.setenv(ORA_SDTZ = "Europe/Paris")
}

populate_table_names <- function() {

  unlockBinding("IR_BEN_R", as.environment("package:RNDR"))
  assign("IR_BEN_R",
         dplyr::tbl(the$oracle, "IR_BEN_R"),
         as.environment("package:RNDR"))
}
