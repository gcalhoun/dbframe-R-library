setGeneric("select", function(db, cols, ...) standardGeneric("select"))

selectSQL <- function(tablesql, cols = "*", where = NULL, group.by = NULL,
                      having = NULL, order.by = NULL, limit = NULL, ...) {
  if ((length(cols) == 1) && (nchar(cols) == 0)) cols <- NULL
  cols <- if (is.null(group.by)) {
    paste(cols, collapse = ", ")
  } else {
    ## add elements of the 'group.by' vector that aren't already in
    ## cols to the select statement.  The sapply part looks for
    ## group.by elements that are at the beginning of a select
    ## statement, so that it recognizes things like:
    ## cols = "m.s as THEs", group.by = "m.s"
    paste(c(cols, group.by[!sapply(group.by, function(g) g %in% substr(cols, 1, nchar(g)))]),
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

  paste("select", cols, "from", tablesql, where, group.by, having, order.by, limit)
}

setMethod("select", signature = c("dbframe", "missing"), function(db, cols,...)
          dbGetQuery(db(db), selectSQL(sql(db),...)))

setMethod("select", signature = c("dbframe", "character"), function(db, cols,...)
          dbGetQuery(db(db), selectSQL(sql(db), cols, ...)))

setMethod("select", signature = c("list", "character"), function(db, cols, join,...)
          stop("Joins are not yet implemented."))

setMethod("select", signature = c("dbframe", "list"), function(db, cols,...) {
  if (length(cols) == 1) return(select(db, cols[[1]],...))
  
  allargs <- list(...)
  if ("comp" %in% names(allargs)) {
    comp <- allargs[["comp"]]
    allargs[["comp"]] <- NULL
  } else {
    comp <- "union all"
  }
  if (length(comp) == 1) {
    comp <- rep(comp, length(cols) - 1)
  } else if (length(comp) != length(cols) - 1) {
    stop("'comp' must have one element or one fewer element than 'cols'")
  }
    
  if ("order.by" %in% names(allargs)) {
    ordertext <- paste(" order by ", paste(allargs[["order.by"]], collapse = ", "))
    allargs[["order.by"]] <- NULL
  } else {
    ordertext <- ""
  }

  ## if 'limit' has more than one entry, we'll apply it to each of
  ## the individual queries, otherwise we apply it at the end.
  eachlimit <- vector("list", length(cols))
  limtext <- ""
  if ("limit" %in% names(allargs)) {
    if (length(allargs[["limit"]]) > 1) {
      if (length(allargs[["limit"]]) != length(cols)) stop("'limit' must have the same length as 'cols' or length 1")
      eachlimit <- as.list(allargs[["limit"]])
    } else {
      limtext <- paste(" limit ", allargs[["limit"]])
    }
    allargs[["limit"]] <- NULL
  }
  
  if (!all(sapply(cols, is.character)))
    stop("All elements of 'cols' must be characters")

  sqls <- sapply(seq_along(cols), function(j) {
    allargs$tablesql <- sql(db)
    allargs$cols <- cols[[j]]
    allargs$limit <- eachlimit[[j]]
    do.call(selectSQL, allargs)
  })
  dbGetQuery(db(db), paste(paste(sqls, c(comp, ""), collapse = " "), ordertext, limtext))
})
