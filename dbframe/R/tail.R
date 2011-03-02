tail.dbframe <- function(x, n = 6L, ...) {
  nrec <- select(x, "count(*)")[[1]]
  if (n >= 0) {
    select(x, limit = sprintf("%d,%d", nrec - n, n),...)
  } else {
    select(x, limit = sprintf("%d,%d", -n, nrec + n),...)
  }
}
