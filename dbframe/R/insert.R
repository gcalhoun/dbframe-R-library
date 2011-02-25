'insert<-' <- function(x, value) {
  cols <- if (is.table(x)) {
    tablenames <- names(select(x, limit = 0))
    tablenames[tablenames %in% names(value)]
  } else {
    names(value)
  }
  dbc <- Connect(x)
  dbWriteTable(dbc, sql(x), value[, cols, drop=FALSE],
               row.names = FALSE, overwrite = FALSE, append = TRUE)
  dbDisconnect(dbc)
  x
}
