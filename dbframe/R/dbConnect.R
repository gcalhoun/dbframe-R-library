setMethod("dbConnect", signature = "dbframe", definition = function(drv,...) {
  dbc <- dbConnect("SQLite", dbname = db(drv))
  if (drv@extensions) init_extensions(dbc)
  dbc
})
