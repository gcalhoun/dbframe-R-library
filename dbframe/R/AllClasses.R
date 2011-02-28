setClass("dbframe", representation(db = "character",
                                   sql = "character",
                                   extensions = "logical"))

summary.dbframe <- function(object,...) {
  print(paste("dframe object with",
              query(object, "select count(*) from %s")),
        "entries. Summary of database connection:")
  print(summary(db(object)))
}

is.dbframe <- function(x) class(x) == "dbframe"

setMethod("dbDisconnect", signature = "dbframe",
          function(conn,...) dbDisconnect(db(conn),...))
