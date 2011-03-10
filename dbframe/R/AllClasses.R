setClass("dbframe", representation(db = "character",
                                   sql = "character",
                                   extensions = "logical"))

setMethod("==", c("dbframe", "dbframe"), function(d1, d2)
          d1@db == d2@db & d1@sql == d2@sql & d1@extensions == d2@extensions)
setMethod("!=", c("dbframe", "dbframe"), function(d1, d2)
          d1@db != d2@db & d1@sql != d2@sql & d1@extensions != d2@extensions)
