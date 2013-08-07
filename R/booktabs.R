## Copyright (C) 2011-2013 Gray Calhoun
##
## This program is free software: you can redistribute it and/or
## modify it under the terms of the GNU General Public License as
## published by the Free Software Foundation, either version 3 of the
## License, or (at your option) any later version.
##
## This program is distributed in the hope that it will be useful, but
## WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see
## <http://www.gnu.org/licenses/>.

booktabs <- function(dframe, align = "l", digits = 1, numberformat = FALSE,
                     purgeduplicates = TRUE, tabular.environment = "tabularx",
                     scientific = FALSE, include.rownames = FALSE,
                     sanitize.text.function = function(x) x, drop = NULL,...) {

  devnull <- switch(Sys.info()["sysname"],
                    Windows = "NUL", Linux = "/dev/null", Darwin = "/dev/null",
                    {
                      warning("Your OS is not explicitly supported; we'll assume /dev/null exists.")
                      "/dev/null"
                    })

  dframe <- as.data.frame(dframe)
  if (!is.null(drop)) {
    columnnames <- names(dframe)
    if (!all(drop %in% columnnames)) {
      warning("'drop' contains some columns not in 'dframe'")
    }
    dframe <- dframe[, setdiff(names(dframe), drop), drop = FALSE]
  }
  ncol <- ncol(dframe) + include.rownames
  if (length(align) == 1) align <- rep(align, ncol)
  if (length(digits) == 1) digits <- rep(digits, ncol)
  if (length(numberformat) == 1) numberformat <- rep(numberformat, ncol)
  if (length(purgeduplicates) == 1)
    purgeduplicates <- rep(purgeduplicates, ncol)
  if (!include.rownames) {
    align <- c("l", align)
    digits <- c(0, digits)
  }

  dframe[,numberformat] <- lapply(which(numberformat), function (i) {
    emptyRows <- is.na(dframe[,i])
    rowTex <- rep("", length(emptyRows))
    rowTex[!emptyRows] <-
      gsub("-", "\\\\!\\\\!-", sprintf("$%s$", gsub(" ", "\\\\enskip", 
             format(round(as.numeric(dframe[!emptyRows,i]), 
                          digits[i + !include.rownames]),
                    scientific = scientific))))
    rowTex
  })

  repeats <- function(x) c(FALSE, x[-1] == x[seq_len(length(x) - 1)])
  purgeindex <- which(purgeduplicates)
  for (i in rev(seq_along(purgeindex))) {
    dframe[repeats(dframe[[i]]) &
           duplicated(dframe[, purgeindex[seq_len(i)], drop = FALSE]),
           purgeindex[i]] <- NA
  }
  tablatex <- print(xtable(dframe, align = align, digits = digits,...),
                    file = devnull, floating = FALSE,
                    add.to.row = list(pos=list(-1, 0, nrow(dframe)),
                      command = c("\\toprule ", "\\midrule ", "\\bottomrule ")),
                    tabular.environment = tabular.environment,
                    sanitize.text.function = sanitize.text.function,
                    include.rownames = include.rownames, hline.after = NULL)
  if (tabular.environment == "tabularx") {
    tablatex <- gsub(sprintf("\\\\begin\\{%s\\}", tabular.environment),
                     sprintf("\\\\begin\\{%s\\}\\{\\\\textwidth\\}",
                             tabular.environment),
                     tablatex)
  }
  return(tablatex)
}
