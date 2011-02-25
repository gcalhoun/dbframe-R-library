dbframe <- function(table, dbname, data = NULL,
                    overwrite = FALSE, extensions = TRUE,...) {
  x <- new("dbframe", db = dbname, sql = table, extensions = extensions)
  
  if (!is.null(data)) {
    if (overwrite) clear(x, delete = FALSE)
    insert(x) <- as.data.frame(data)
  }
  x
}
