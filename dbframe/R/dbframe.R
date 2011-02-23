setClass("dbframe", representation(db = "SQLiteConnection",
                                  sql = "character"))

dbframe <- function(table, dbname = ":memory:", data = NULL, cache = TRUE, temp = FALSE,
                    overwrite = FALSE, extensions = TRUE,...) {
  ## The defaults for cache and temp are basically chosen for
  ## consistency across the different possibilities for 'data'.  Once
  ## I figure out how to do temporary frames when data is a
  ## data.frame, I should change 'temp' to be TRUE by default.
  x <- new("dbframe", db = dbConnect(dbDriver("SQLite"), dbname), sql = table)
  ## Load the SQLite math extensions
  if (extensions) init_extensions(db(x))
  
  if (!is.null(data)) {
    if (is.character(data)) {
      ## if data is a character, we assume that it contains sql
      ## commands specifying a query.
      frametype <- if (cache) {"table"} else {"view"}
      createsql <- if (temp) {"create temporary"} else {"create"}
      if (table %in% dbListTables(db(x))) {
        if (overwrite) {
          dbRemoveTable(db(x), table)
        } else {
          warning("Table already exists;")
          return(FALSE)
        }
      }
      dbClearResult(dbSendQuery(db(x),
        paste(createsql, frametype, table, "as", data)))
    } else {
      if (temp) warning("Temporary tables are not implemented for this data.")
      if (!cache) warning("Data exported from R must be cached")
      data <- as.data.frame(data)
      if (tolower(table) %in% tolower(dbListTables(db(x)))) {
        ## If the table exists, add the columns of the data.frame that
        ## already exist in the database.  I'm not sure that this is
        ## the best way to handle this case.
        tablenames <- names(query(x, "select * from %s limit 0"))
        dbWriteTable(db(x), sql(x),
                     data[, tablenames[tablenames
                                       %in% names(data)], drop=FALSE],
                     row.names = FALSE, overwrite = overwrite, ...)
      } else {
        ## otherwise, create the table from scratch
        dbWriteTable(db(x), sql(x), data, row.names = FALSE,...)
      }
    }
  }
  x
}

summary.dbframe <- function(object,...) {
  print(paste("dframe object with",
              query(object, "select count(*) from %s")),
        "entries. Summary of database connection:")
  print(summary(db(object)))
}

setMethod("dbDisconnect", signature = "dbframe", function(conn,...) dbDisconnect(db(conn),...))
