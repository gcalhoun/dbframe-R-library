\name{dbframe-package}
\alias{dbframe-package}
\docType{package}
\title{dbframe: A new SQL interface}

\description{A collection of functions that I'm developing to work more
  easily with databases.}

\usage{library(dbframe)}

\details{
  \subsection{Queries}{
    This package is useful only insofar as
    it provides convenient, R-like wrappers for database queries.  Some
    of them aren't implemented yet, but the ones that I use frequently
    are.
    \describe{
      \item{select}{A select query.}
      \item{insert<-}{An insert query.}
      \item{Update}{Not yet}
    }

    There are a few \dQuote{shortcut} functions that give \R like
    interfaces to canned queries.
    \describe{
      \item{head}{Return the first few rows of a table.}
      \item{tail}{Return the last few rows of a table.}
    }
  }
  
  \subsection{Database manipulation}{ This package also gives a direct
    interface to things like indexing, etc.
    \describe{
      \item{index, index<-}{View or add an index.}
    }
  }

  \subsection{Other functions}{And there are some other functions that
    do useful things too.}
}

\seealso{\link{DBI}, \link{RSQLite}}
\examples{## Add later}
\author{Gray Calhoun \email{gcalhoun@iastate.edu}}
\keyword{package}
\keyword{database}
