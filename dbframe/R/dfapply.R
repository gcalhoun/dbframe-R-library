## A convenience function for when FUN returns a data.frame: this just
## stacks all of the data.frames
dfapply <- function(x, FUN, row.names = FALSE,...) 
  do.call(rbind, lapply(x, function(x,...) {
    d <- as.data.frame(FUN(x,...))
    if (!row.names) row.names(d) <- NULL
    d
  },...))


## a "paired" version of dfapply; if FUN returns a list of
## data.frames, we want to stack all of the first elements into a
## single data.frame, all of the second elements, etc.
pdfapply <- function(x, FUN, row.names = FALSE, ...) {
  dlist <- lapply(x, FUN, ...)
  namesd <- names(dlist[[1]])
  dlist <- lapply(seq_along(dlist[[1]]), function(j) lapply(dlist, function(d) d[[j]]))
  dlist <- lapply(dlist, function(d) {
    dnew <- do.call(rbind, d)
    if (!row.names)
      row.names(dnew) <- NULL
    dnew
  })
  names(dlist) <- namesd
  dlist
}
