clear <- function(x,...) {
  dbRemoveTable(db(x), sql(x),...)
  ## need to figure out how to delete x from the parent frame.
}
