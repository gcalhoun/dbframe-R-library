## dbview is a read-only connection to a database table (or query)
setClass("dbview", representation(db = "SQLiteConnection",
                                  sql = "character"))
## dbframe allows data to be written to the database table
setClass("dbframe", contains = "dbview")
db <- function(x,...) x@db
sql <- function(x,...) x@sql

dbview <- function(dbc, sql,...) {
  new("dbview", db = dbc, sql = sql)  
}

dbframe <- function(dbc, table, data = NULL,...) {
  x <- new("dbframe", db = dbc, sql = table)
  if (!is.null(data)) {
    data <- as.data.frame(data)
    if (tolower(table) %in% tolower(dbListTables(db(x)))) {
      ## If the table exists, add the columns of the data.frame that
      ## already exist in the database.  I'm not sure that this is the
      ## best way to handle this case.
      tablenames <- names(query(x, "select * from %s limit 0"))
      dbWriteTable(db(x), sql(x),
                   data[, tablenames[tablenames
                                     %in% names(data)], drop=FALSE],
                   row.names = FALSE,...)
    } else {
      ## otherwise, create the table from scratch
      dbWriteTable(db(x), sql(x), data, row.names = FALSE,...)
    }
  }
  x
}

print.dbview <- function(x,...) {
  print("dbview object; first 5 rows:")
  print(query(x, "select * from %s limit 5"))
}
print.dbframe <- function(x,...) {
  print("dbframe object; first 5 rows:")
  print(query(x, "select * from %s limit 5"))
}

as.data.frame.dbview <- function(x,...) {
  as.data.frame(query(x),...)
}

summary.dbframe <- function(object,...) {
  print(paste("dframe object with",
              query(object, "select count(*) from %s")),
        "entries. Summary of database connection:")
  print(summary(db(object)))
}

summary.dbview <- function(object,...) {
  print(paste("dframe object with",
              query(object, "select count(*) from %s")),
        "entries. Summary of database connection:")
  print(summary(db(object)))
}
