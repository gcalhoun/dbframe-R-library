package := dbframe
version := 0.2
zipfile := $(package)_$(version).tar.gz

RFLAGS   := --vanilla --slave
Rscript  := Rscript
latexmk  := /usr/local/texlive/2009/bin/x86_64-linux/latexmk
LATEXMKFLAGS := -pdf -silent -latex=xelatex -pdflatex=xelatex
nuweb    := nuweb

Rfiles := $(patsubst $(package)/man/%.Rd, $(package)/R/%.R, $(wildcard $(package)/man/*.Rd))

.PHONY: all build pdf

all: check build install pdf
pdf: $(package)/inst/doc/implementation.pdf
build: $(zipfile)
$(zipfile): check 
	R CMD build $(package)

install: $(zipfile)
	R CMD INSTALL $(package)
	touch $@

$(Rfiles) $(package)/inst/doc/implementation.tex $(package)/NAMESPACE: $(package)/implementation.w
	mkdir -p $(dir $@)
	$(nuweb) -l $<
%.pdf: %.tex
	cd $(dir $<) && $(latexmk) $(LATEXMKFLAGS) $(<F)

# I like this next rule.  The 'check' file depends on every file that's
# under version control or unknown in the $(package) subdirectory.
check: pdf $(Rfiles) $(package)/NAMESPACE $(addprefix $(package)/,$(shell bzr ls $(package)/ -R --unknown -V --kind=file))
	R CMD check $(package)
	touch $@
