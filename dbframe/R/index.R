'index<-' <- function(x, value) {
  indices <- index(x)
  allindices <- dbGetQuery(db(x), sprintf("
select name from sqlite_master where type='index';"))$name
  if (!is.null(indices) && any(unlist(lapply(indices, function(a) {
    all(a[1:length(value)] == value)})))) {
    warning("Index already exists, so it wasn't created again.")
    return(FALSE)
  } 

  ## create unique index name
  j <- 0
  repeat {
    indexname <- paste(sql(x), "-i", j, sep = "")
    if (!{indexname %in% allindices}) break
    j <- j+1
  }

  ## add the index to the database
  dbSendQuery(db(x), paste("create unique index", indexname, "on",
                           sql(x),"(", paste(value, collapse = ","),
                           ");"))
}

index <- function(x) {
  indexdata <- dbGetQuery(db(x), sprintf("
select name, sql from sqlite_master
where type='index' and tbl_name='%s';", sql(x)))
  if (nrow(indexdata) == 0) return(NULL)
  cols <- lapply(strsplit(indexdata$sql, "\\(|,|\\)"),
                 function(s) s[-1])
  names(cols) <- indexdata$name
  cols
}
