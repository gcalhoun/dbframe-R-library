setGeneric("db", function(x) standardGeneric("db"))
setGeneric("sql", function(x) standardGeneric("sql"))

setMethod("db", signature = c("dbframe"), function(x) x@db)
setMethod("sql", signature = c("dbframe"), function(x) x@sql)
