\name{dbframe}
\alias{dbframe}
\title{Create a \code{dbframe} object}
\description{Creates a new \code{dbframe} object.}

\usage{
dbframe(table, dbname, data = NULL, extensions = TRUE, ...)
}
\arguments{
  \item{table}{Name of the SQLite table.}
  \item{dbname}{Name of the SQLite database.}
  \item{data}{An optional data frame to insert into the SQLite table.}
  \item{extensions}{Logical; should the RSQLite extensions be enabled?}
  \item{\dots}{Optional arguments (currently unused).}
}
\details{Fill in details later}
\value{Returns a \code{dbframe} object.}
\author{Gray Calhoun \email{gcalhoun@iastate.edu}}
\seealso{\code{\link{dbframe-class}}}

\section{Implementation}{
\preformatted{<*>=
dbframe <- function(table, dbname, data = NULL, extensions = TRUE,...) \{
  x <- new("dbframe", db = dbname, sql = table, extensions = extensions)
  if (!is.null(data)) insert(x) <- as.data.frame(data)
  return(x)
\}
}
}

\section{Unit tests}{
  Add some test code if you can think of it.
}

\examples{
## add some examples 
}

\keyword{database}
\keyword{interface}

