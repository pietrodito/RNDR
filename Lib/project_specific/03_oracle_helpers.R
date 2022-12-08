list_tables <- function() {
  fetch(dbSendQuery(oracle_connection, "
                                 select table_name
                                 from user_tables
                                 order by table_name asc"))
}

drop_table <- function(table) {
 table <- quo_name(enquo(table))
 tryCatch(
  dbSendQuery(oracle_connection, str_c("drop table ", table)),
  error = function(e)  cat(e$message)
 )
}

drop_all_orauser_tables <- function() {
  map(list_tables() %>% pull(TABLE_NAME), drop_table)
}
