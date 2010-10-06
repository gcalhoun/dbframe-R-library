query <- function(x, text = "select * from (%s)")
  dbGetQuery(db(x), sprintf(text, sql(x)))
