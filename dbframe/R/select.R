select <- function(x, select = "*", where = NULL, group.by = NULL, having = NULL,...) {
  if (is.null(group.by)) {
    group.by <- ""
  } else {
    select <- paste(group.by, select, sep = ",")
    group.by <- paste("group by", group.by)
  }
  if (is.null(having)) {
    having <- ""
  } else {
    having <- paste("having", having)
  }
  if (is.null(where)) {
    where <- ""
  } else {
    where <- paste("where", where)
  }
  dbGetQuery(db(x), paste("select", select, "from", sql(x),
                          where, group.by, having))
}
