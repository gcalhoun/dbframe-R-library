package := dbframe
version := 0.2
zipfile := $(package)_$(version).tar.gz

Rscript  := Rscript
latexmk  := /usr/local/texlive/2011/bin/x86_64-linux/latexmk
noweave  := noweave
notangle := notangle

RFLAGS       := --vanilla --slave
LATEXMKFLAGS := -pdf -silent

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

$(Rfiles) $(package)/NAMESPACE: $(package)/implementation.rnw
	mkdir -p $(dir $@)
	$(notangle) -R$(@F) $< | cpif $@

%.pdf: %.tex
	cd $(dir $<) && $(latexmk) $(LATEXMKFLAGS) $(<F)
$(package)/inst/doc/implementation.tex: $(package)/implementation.rnw
	mkdir -p $(dir $@)
	$(noweave) -latex -x -delay $< | cpif $@

# I like this next rule.  The 'check' file depends on every file that's
# under version control or unknown in the $(package) subdirectory.
check: pdf $(Rfiles) $(package)/NAMESPACE $(addprefix $(package)/,$(shell bzr ls $(package)/ -R --unknown -V --kind=file))
	R CMD check $(package)
	touch $@
