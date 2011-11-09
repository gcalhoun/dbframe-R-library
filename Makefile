package := dbframe
version := 0.2
zipfile := $(package)_$(version).tar.gz

Rscript  := Rscript
latexmk  := /usr/local/texlive/2011/bin/x86_64-linux/latexmk
noweave  := noweave
notangle := notangle
tord := ~/Desktop/dbframe.bzr/tord

RFLAGS       := --vanilla --slave
LATEXMKFLAGS := -pdf -silent

Rsource := $(wildcard $(package)/Rdweb/*.Rdw) 
Rcode   := $(filter-out $(package)/R/dbframe-package.R, \
           $(Rsource:$(package)/Rdweb/%.Rdw=$(package)/R/%.R))
Rdocs   := $(Rsource:$(package)/Rdweb/%.Rdw=$(package)/man/%.Rd)

.PHONY: all build burn

all: check build install
build: $(zipfile)
$(zipfile): check 
	R CMD build $(package)
burn: 
	rm $(package)/man/* $(package)/R/*

install: $(zipfile)
	sudo R CMD INSTALL $(package)
	touch $@

$(Rcode): $(package)/R/%.R: $(package)/Rdweb/%.Rdw
	$(notangle) $< > $@

$(Rdocs): $(package)/man/%.Rd: $(package)/Rdweb/%.Rdw
	$(noweave) -delay -backend $(tord) $< > $@

check: $(Rcode) $(Rdocs)
	echo $(Rcode) $(Rdocs) $(Rsource)
	R CMD check $(package)
	touch $@
