setGeneric("sql", function(x) standardGeneric("sql"))

setMethod("sql", signature = c("dbframe"), function(x) x@sql)
