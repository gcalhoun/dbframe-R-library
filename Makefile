package := dbframe
version := 0.2.0
zipfile := $(package)_$(version).tar.gz

Rscript  := Rscript
R        := R
latexmk  := /usr/local/texlive/2011/bin/x86_64-linux/latexmk
noweave  := noweave
notangle := notangle
tord := ~/Desktop/illiterate.bzr/tord

RFLAGS       := --vanilla --slave
LATEXMKFLAGS := -pdf -silent

Rsource := $(wildcard $(package)/Rdweb/*.Rdw) 
Rsource2:= $(wildcard $(package)/Rdweb/*.Rd)
Rcode   := $(filter-out $(package)/R/dbframe-package.R, \
           $(Rsource:$(package)/Rdweb/%.Rdw=$(package)/R/%.R))
Rdocs   := $(Rsource:$(package)/Rdweb/%.Rdw=$(package)/man/%.Rd)
Rdocs2  := $(Rsource2:$(package)/Rdweb/%=$(package)/man/%)

.PHONY: all build burn pdf

all: check build install pdf
build: $(zipfile)
$(zipfile): check 
	$(R) CMD build $(package)
burn: 
	rm $(package)/man/* $(package)/R/*
pdf: $(package)-manual.pdf
install: $(zipfile)
	sudo $(R) CMD INSTALL --no-docs --debug $(package)
	touch $@

$(Rcode): $(package)/R/%.R: $(package)/Rdweb/%.Rdw
	$(notangle) $< > $@

$(Rdocs): $(package)/man/%.Rd: $(package)/Rdweb/%.Rdw
	$(noweave) -delay -backend $(tord) $< > $@

$(Rdocs2): $(package)/man/%: $(package)/Rdweb/%
	cp $< $@

$(package)/DESCRIPTION: DESCRIPTION
	echo 'Version: $(version)' | cat $< - > $@

$(package)-manual.tex: $(Rdocs) $(Rdocs2)
	$(Rscript) -e 'tools:::.Rd2dvi("$(package)", "$@", "$(package) Documentation", files_or_dir = "$(package)/man", internals=TRUE)'
	sed -i 's/alltt/verbatim/' $@
%.pdf: %.tex
	$(R) CMD texi2dvi -c -q -p $<

check: $(Rcode) $(Rdocs) $(Rdocs2) $(package)/DESCRIPTION
	$(R) CMD check --no-manual --use-gct --use-valgrind $(package)
	touch $@
