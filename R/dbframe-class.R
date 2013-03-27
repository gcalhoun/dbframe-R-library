##  This text is pasted to the front of each R file in the package
##  automatically.
##
##  Before editing this file, be aware that this package is generated
##  by noweb.  All of the source code is contained in files with an
##  ".rw" extension.  If you are reading this message in a .R file,
##  you are not working with the original source code and any changes
##  you make to this file may be overwritten.
## 
##  Copyright (C) 2011  Gray Calhoun
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##
##  You should have received a copy of the GNU General Public License
##  along with this program.  If not, see <http://www.gnu.org/licenses/>.
    setClass("dbframe", representation(table = "character",
                                       readonly = "logical",
                                       dbConnect.arguments = "list"))

    setClass("dbframe_sqlite", contains = "dbframe",
             representation(rowid = "integer", dbname = "character"))

        setMethod("dbConnect", signature = "dbframe", 
                  definition = function(drv,...)
                  do.call("dbConnect", drv@dbConnect.arguments))
        setMethod("dbConnect", signature = "dbframe_sqlite", 
          definition = function(drv,...) return(do.call("dbConnect",
            c(drv = "SQLite", dbname = dbname(drv), list(...),
              dbConnect.arguments = drv@dbConnect.arguments))))
 
        as.data.frame.dbframe <- function(x,...) select(x,...)
        dim.dbframe <- function(x) {
          nrows <- select(x, "count(*)")[[1]]
          ncols <- length(select(x, limit = 0))
          c(nrows, ncols)
        }
  
    setGeneric("tablename", function(x) standardGeneric("tablename"))
        setMethod("tablename", signature = c("dbframe"), function(x) x@table)
    setGeneric("dbname", function(x) standardGeneric("dbname"))
        setMethod("dbname", signature = c("dbframe"), function(x) x@dbname)
    setGeneric("readonly", function(x) standardGeneric("readonly"))
        setMethod("readonly", signature = c("dbframe"), function(x) x@readonly)
    setGeneric("is.linked", function(x,...) standardGeneric("is.linked"))
        setMethod("is.linked", signature = c("dbframe"), function(x,...) {
          dbc <- dbConnect(x,...)
          answer <- tablename(x) %in% dbListTables(dbc)
          dbDisconnect(dbc)
          return(answer)
        })
    setGeneric("rowid", function(x,...) standardGeneric("rowid"))
        setMethod("rowid", signature = c("dbframe_sqlite"), 
                  function(x,...) x@rowid)
    setGeneric("rowid<-", function(x,...,value) standardGeneric("rowid<-"))
        setMethod("rowid<-", signature = c("dbframe_sqlite"), function(x,...,value) {
          x@rowid <- as.integer(value)
          return(x)})
