## A convenience function for when FUN returns a data.frame: this just
## stacks all of the data.frames
dfapply <- function(x, FUN, ...) do.call(rbind, lapply(x, FUN,...))
