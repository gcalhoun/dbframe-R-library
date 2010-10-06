'add<-' <- function(x, value) {
  tablenames <- names(query(x, "select * from %s limit 0"))
  dbWriteTable(db(x), sql(x), 
               value[, tablenames[tablenames
                                 %in% names(value)], drop=FALSE],
               row.names = FALSE, overwrite = FALSE, append = TRUE)
}
