setGeneric("Connect", function(x,...) standardGeneric("Connect"))
setMethod("Connect", signature = "dbframe", definition = function(x,...) {
  dbc <- dbConnect("SQLite", dbname = db(x))
  if (x@extensions) init_extensions(dbc)
  dbc
})
