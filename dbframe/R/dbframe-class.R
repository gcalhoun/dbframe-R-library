setClass("dbframe", representation(db = "character", sql = "character",
                                   extensions = "logical"))

setMethod("==", c("dbframe", "dbframe"), function(e1, e2)
          e1@db == e2@db & e1@sql == e2@sql & e1@extensions == e2@extensions)
setMethod("!=", c("dbframe", "dbframe"), function(e1, e2)
          e1@db != e2@db & e1@sql != e2@sql & e1@extensions != e2@extensions)

setGeneric("sql", function(x) standardGeneric("sql"))
setGeneric("db", function(x) standardGeneric("db"))
setGeneric("extensions", function(x) standardGeneric("extensions"))

setMethod("sql", signature = c("dbframe"), function(x) x@sql)
setMethod("db", signature = c("dbframe"), function(x) x@db)
setMethod("extensions", signature = c("dbframe"), function(x) x@extensions)
