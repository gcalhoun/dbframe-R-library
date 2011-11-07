\name{dbframe-class}
\Rdversion{1.1}
\docType{class}
\alias{dbframe-class}
\alias{==,dbframe,dbframe-method}
\alias{!=,dbframe,dbframe-method}
\alias{db,dbframe-method}
\alias{extensions,dbframe-method}
\alias{sql,dbframe-method}

\title{Class \code{"dbframe"}}
\description{A nice class to access SQLite data bases.}
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("dbframe", ...)}.
%%  ~~ describe objects here ~~ 
}
\section{Slots}{
  \describe{
    \item{\code{db}:}{Object of class \code{"character"} ~~ }
    \item{\code{sql}:}{Object of class \code{"character"} ~~ }
    \item{\code{extensions}:}{Object of class \code{"logical"} ~~ }
  }
}
\section{Methods}{
  \describe{
    \item{==}{\code{signature(e1 = "dbframe", e2 = "dbframe")}: ... }
    \item{!=}{\code{signature(e1 = "dbframe", e2 = "dbframe")}: ... }
    \item{db}{\code{signature(x = "dbframe")}: ... }
    \item{extensions}{\code{signature(x = "dbframe")}: ... }
    \item{sql}{\code{signature(x = "dbframe")}: ... }
	 }
}
\references{
%%  ~~put references to the literature/web site here~~
}
\author{
Gray Calhoun \email{gcalhoun@iastate.edu}
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%%  ~~objects to See Also as \code{\link{~~fun~~}}, ~~~
%%  ~~or \code{\linkS4class{CLASSNAME}} for links to other classes ~~~
}
\examples{
showClass("dbframe")
}
\section{Implementation}
This is where the source code would go.

\keyword{classes}
