setGeneric("select", function(x,...) standardGeneric("select"))

selectSQL <- function(tablesql, select = "*", where = NULL, group.by = NULL,
                      having = NULL, order.by = NULL, limit = NULL, ...) {
  if ((length(select) == 1) && (nchar(select) == 0)) select <- NULL
  select <- if (is.null(group.by)) {
    paste(select, collapse = ", ")
  } else {
    ## add elements of the 'group.by' vector that aren't already in
    ## select to the select statement.  The sapply part looks for
    ## group.by elements that are at the beginning of a select
    ## statement, so that it recognizes things like:
    ## select = "m.s as THEs", group.by = "m.s"
    paste(c(select, group.by[!sapply(group.by, function(g) g %in% substr(select, 1, nchar(g)))]),
          collapse = ", ")
  }
  group.by <- if (is.null(group.by)) "" else {
    paste("group by", paste(group.by, collapse = ", "))
  }
  order.by <- if (is.null(order.by)) "" else {
    paste("order by", paste(order.by, collapse = ", "))
  }
  
  having   <- if (is.null(having))   "" else paste("having", having)
  where    <- if (is.null(where))    "" else paste("where", where)
  limit    <- if (is.null(limit))    "" else paste("limit", limit)

  paste("select", select, "from", tablesql, where, group.by, having, order.by, limit)
}

setMethod("select", "dbframe",   function(x, ...) dbGetQuery(db(x), selectSQL(sql(x),...)))
setMethod("select", "character", function(x, db,...) dbGetQuery(db, selectSQL(x, ...)))
