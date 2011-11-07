\name{dbframe}
\alias{dbframe}
\title{Create a new \code{dbframe} object}
\description{Creates a new \code{dbframe} object.  If the \code{dbframe}
  consists of a table that already exists, this function just creates a
  link to that table.  If the table does not exist, it will be created
  in the database.
}
\usage{
dbframe(table, dbname, data = NULL, extensions = NULL)
}
\arguments{
  \item{table}{A string, the name of the table in the database}
  \item{dbname}{The name of the SQLite database file}
  \item{data}{A data frame to insert into the table.  If this is
    \code{NULL}, no data will be inserted}
  \item{extensions}{logical, indicating whether the SQLite extensions
    should be enabled. }
}
\details{Establishes a connection to an SQLite database.}
\examples{
## testdata <- dbframe("table1", ":memory:", data.frame(y = 1:10, x = rnorm(1)))
## head(testdata)
}

