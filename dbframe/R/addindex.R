addindex <- function(x, cols) {
  dbSendQuery(db(x), paste("create unique index i", sql(x), " on ", sql(x),
                           "(", paste(cols, collapse = ","), ");", sep = ""))
}
