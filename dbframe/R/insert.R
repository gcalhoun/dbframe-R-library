'insert<-' <- function(x, value) {
  if (sql(x) %in% dbListTables(db(x))) {
    tablenames <- names(query(x, "select * from %s limit 0"))
    cols <- tablenames[tablenames %in% names(value)]
  } else {
    cols <- names(value)
  }
  dbWriteTable(db(x), sql(x), value[, cols, drop=FALSE],
               row.names = FALSE, overwrite = FALSE, append = TRUE)
  x
}
