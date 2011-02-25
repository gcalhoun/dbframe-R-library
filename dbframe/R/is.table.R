is.table.dbtable <- function(x) {
  dbc <- Connect(x)
  res <- sql(x) %in% dbListTables(dbc)
  dbDisconnect(x)
  res
}
