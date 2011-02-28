"index<-" <- function(x, unique = FALSE, value) {
  indices <- index(x)
  dbc <- Connect(x)
  allindices <- dbGetQuery(dbc, sprintf("
select name from sqlite_master where type='index';"))$name
  if (!is.null(indices) && any(unlist(lapply(indices, function(a) {
    all(a[1:length(value)] == value)})))) {
    warning("Index already exists, so it wasn't created again.")
    return(FALSE)
  } 

  ## create unique index name
  j <- 0
  repeat {
    indexname <- paste(sql(x), "_i", j, sep = "")
    if (!{indexname %in% allindices}) break
    j <- j+1
  }

  ## add the index to the database
  sqlstart <- if (unique) "create unique index" else "create index"
  dbSendQuery(dbc, paste(sqlstart, indexname, "on", sql(x),"(",
                         paste(value, collapse = ","), ");"))
  x
}

index <- function(x) {
  dbc <- Connect(x)
  indexdata <- dbGetQuery(dbc, sprintf("
select name, sql from sqlite_master
where type='index' and tbl_name='%s';", sql(x)))
  dbDisconnect(dbc)
  if (nrow(indexdata) == 0) return(NULL)
  cols <- lapply(strsplit(indexdata$sql, "\\(|,|\\)"),
                 function(s) sub("[[:blank:]]", "", s[-1]))
  names(cols) <- indexdata$name
  cols
}
