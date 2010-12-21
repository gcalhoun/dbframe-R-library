select <- function(x, select = "*", where = NULL, group.by = NULL,
                   having = NULL, limit = NULL, ...) {
  select   <- if (is.null(group.by)) {
    paste(select, collapse = ", ")
  } else {
    paste(c(group.by, select), collapse = ", ")
  }
  group.by <- if (is.null(group.by)) "" else {
    paste("group by", paste(group.by, collapse = ", "))
  }
  having   <- if (is.null(having))   "" else paste("having", having)
  where    <- if (is.null(where))    "" else paste("where", where)
  limit    <- if (is.null(limit))    "" else paste("limit", limit)
  dbGetQuery(db(x), paste("select", select, "from", sql(x),
                          where, group.by, having, limit))
}
