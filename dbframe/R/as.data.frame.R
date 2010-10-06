as.data.frame.dbframe <- function(x, row.names = NULL, optional = FALSE, ...)
  as.data.frame(query(x), row.names, optional, ...)
