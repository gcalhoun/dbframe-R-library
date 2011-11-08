\name{dftable}% ===> this file was generated automatically by noweave --- better not edit it
\alias{dftable}
\title{Construct a nice table from a data frame}
\description{Constructs an attractive LaTeX table (that uses booktabs)
  from an arbitrary data frame.}
\usage{
dftable(dframe, align, digits, tabular.environment = "tabularx",
        sanitize.text.function = function(x) x, drop = NULL,
        include.rownames = FALSE,...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{dframe}{The data frame}
  \item{align}{Alignment}
  \item{digits}{Number of digits for each column.}
  \item{tabular.environment}{Defaults to using tabularx in LaTeX.}
  \item{sanitize.text.function}{Disables escaping out backslashes, etc.}
  \item{\dots}{Additional arguments to pass to \code{xtable}.}
}
\details{This function uses \code{xtable} to generate the LaTeX, then
  modifies the table.}
\value{LaTeX code for a table.}

\author{Gray Calhoun \email{gcalhoun@@iastate.edu}}
\seealso{\code{\link{xtable}}}
\examples{###
}

\section{Implementation}{
In my research, I usually collect simulation results in the table of
some database.  Summarizing the results then amounts to running a
query to aggregate that data, and then plot or tabulate that query's
ersults.  The \code{publictable} function does this and formats the table
to look nice in Latex, using Latex's ``booktabs'' package and the
\code{xtable} library.  These methods are primarily
documented in the help files.

\preformatted{setMethod("publictable", signature = c("dbframe"),
          <<STAND IN FOR A CHUNK HERE>>
          function(object,...) \{
            arguments <- list(...)
            arguments$dframe <- do.call("select",
	                                c(x = object, arguments))
            do.call("dftable", arguments)
          \})}
}
% setMethod("publictable", signature = c("data.frame"),
%           function(object,...) dftable(object,...))

% setMethod("publictable", signature = c("dbframe"),
%           function(object,...) {
%             arguments <- list(...)
%             arguments$dframe <- do.call("select", c(x = object, arguments))
%             do.call("dftable", arguments)
%           })
% }

        
Typesetting the table is done by \code{dftable}.  The first argument,
\code{dframe} is a data frame; it is converted to Latex code by
\code{xtable} and then the Latex code is tweaked to look better.
}