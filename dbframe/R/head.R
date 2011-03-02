head.dbframe <- function(x, n = 6L, ...) {
  if (n >= 0) {
    select(x, limit = n,...)
  } else {
    nrec <- select(x, "count(*)")[[1]]
    select(x, limit = nrec + n,...)
  }
}
