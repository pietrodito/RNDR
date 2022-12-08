upload_from_csv <- function(csv_file, table_name, csv2 = FALSE) {
 
 tmp_sql_file <- str_c("./.temp/tempfile.", floor(runif(1)*1000000), ".sql")
 df <- declare_vars <- NULL
 
 read_file_and_columns_size <- function() {
  if(csv2) {
    suppressMessages(df <<- read_csv2(csv_file)) 
  } else {
    suppressMessages(df <<- read_csv(csv_file)) 
  }
  max_length <- map(df, ~ max(str_length(.), na.rm = TRUE))
  declare_vars <<- str_c(names(df), " varchar (", max_length, ")",
                         collapse = ",\n")
 }
 
 replace_NA_by_NULL <- function() {
   df <<- replace(df, is.na(df), 'NULL')
 }
 
 create_table <- function() {
  drop_table(table_name)
  create_table_string <- str_c("create table ", table_name,
                               " (\n", declare_vars, ")\n/\n")
  write_file(create_table_string, tmp_sql_file)
 }
  
 insert_lines <- function() {
  walk(seq_len(nrow(df)), function(row) {
   row <- str_replace_all(df[row,], "'", " ")
   line_to_insert <- str_c(row, collapse = "','")
   insert_into_string <- str_c("insert into ", table_name, " values  ('",
                               line_to_insert, "')\n/\n")
   insert_into_string <- str_replace(insert_into_string,
                                     "\\'NULL\\'",
                                      "NULL")
   write_file(insert_into_string, tmp_sql_file, append = TRUE)})
   write_file("drop table useless\n/\n", tmp_sql_file, append = TRUE)
 }
 
 read_file_and_columns_size()
 replace_NA_by_NULL()
 create_table()
 insert_lines()
 run_sql_file(tmp_sql_file)
 file.remove(tmp_sql_file)
}

upload_from_csv2 <- function(csv_file, table_name) {
  upload_from_csv(csv_file, table_name, csv2 = TRUE)
}

  
  