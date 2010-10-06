with.dbframe <- function(data, expr, ...) {
  d <- as.data.frame(data)
  with(d, expr, ...)
}
