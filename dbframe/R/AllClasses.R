setClass("dbframe", representation(db = "character",
                                   sql = "character",
                                   extensions = "logical"))

setMethod("==", c("dbframe", "dbframe"), function(e1, e2)
          e1@db == e2@db & e1@sql == e2@sql & e1@extensions == e2@extensions)
setMethod("!=", c("dbframe", "dbframe"), function(e1, e2)
          e1@db != e2@db & e1@sql != e2@sql & e1@extensions != e2@extensions)
