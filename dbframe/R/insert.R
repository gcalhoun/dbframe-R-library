
setGeneric("insert<-", function(x,..., value) standardGeneric("insert<-"))

setMethod("insert<-", signature = "dbframe",
          function(x,...,value) doInsert(x,...,value))

doInsert <- function(x, value) {
  dbc <- dbConnect(x)
  cols <- if (dbExistsTable(dbc, sql(x))) {
    tablenames <- names(select(x, limit = 0))
    tablenames[tablenames %in% names(value)]
  } else {
    names(value)
  }
  dbWriteTable(dbc, sql(x), value[, cols, drop=FALSE],
               row.names = FALSE, overwrite = FALSE, append = TRUE)
  dbDisconnect(dbc)
  x
}
