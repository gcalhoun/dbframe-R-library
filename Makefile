.PHONY: all

all: dbframe_0.01.tar.gz
	R CMD INSTALL dbframe

# I like this next rule.  The .tar file depends on every file that's
# under version control.
dbframe_0.01.tar.gz: $(shell bzr ls -R -V --kind=file)
	R CMD check dbframe
	R CMD build dbframe