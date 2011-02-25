setGeneric("db", function(x) standardGeneric("db"))
setMethod("db", signature = c("dbframe"), function(x) x@db)
