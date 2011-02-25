setGeneric("clear", function(..., delete = TRUE, deparse.level = 1)
           standardGeneric("clear"), signature = "...")

setMethod("clear", signature = "dbframe", function(..., delete = TRUE,
                     deparse.level = 1) {
  x <- list(...)
  if (!all(sapply(x, is.dbframe))) stop("All arguments must be dbframes")
  sapply(x, function(y) {
    dbc <- Connect(y)
    ## remove the table from the corresponding database if it's there
    res <- if (sql(y) %in% dbListTables(dbc)) {
      dbRemoveTable(dbc, sql(y),...)
    } else {
      FALSE
    }
    dbDisconnect(dbc)
    ## I'd like to add code to remove the variable from the
    ## environment where 'clear' was called
    
    ## if (delete) remove(y, environment = sys.parent(2))
    res
  })
})
