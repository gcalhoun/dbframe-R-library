package := dbframe
version := 0.2.1
zipfile := $(package)_$(version).tar.gz

RD       := /home/gcalhoun/Desktop/R-devel/build/bin/R
RR       := /home/gcalhoun/Desktop/R-devel/R-2-14-branch/bin/R
latexmk  := /usr/local/texlive/2011/bin/x86_64-linux/latexmk
noweave  := noweave
notangle := notangle
tord := ~/Desktop/illiterate.bzr/tord

LATEXMKFLAGS := -pdf -silent

Rsource := $(wildcard $(package)/Rdweb/*.Rdw) 
Rsource2:= $(wildcard $(package)/Rdweb/*.Rd)
Rcode   := $(filter-out $(package)/R/dbframe-package.R, \
           $(Rsource:$(package)/Rdweb/%.Rdw=$(package)/R/%.R))
Rdocs   := $(Rsource:$(package)/Rdweb/%.Rdw=$(package)/man/%.Rd)
Rdocs2  := $(Rsource2:$(package)/Rdweb/%=$(package)/man/%)
Rtests  := $(wildcard $(package)/tests/*.R) $(wildcard $(package)/inst/tests/*.R)

.PHONY: all build burn pdf zip

all: check zip install
zip: $(zipfile)
$(zipfile): check 
	$(RR) CMD build $(package)
burn: 
	rm $(package)/man/* $(package)/R/*
install: check
	sudo $(RR) CMD INSTALL --debug $(package)
	sudo $(RD) CMD INSTALL --debug $(package)
	touch $@

$(Rcode): $(package)/R/%.R: $(package)/Rdweb/%.Rdw
	mkdir -p $(package)/R
	$(notangle) $< > $@

$(Rdocs): $(package)/man/%.Rd: $(package)/Rdweb/%.Rdw
	mkdir -p $(package)/man
	$(noweave) -delay -backend $(tord) $< > $@

$(Rdocs2): $(package)/man/%: $(package)/Rdweb/%
	mkdir -p $(package)/man
	cp $< $@

$(package)/DESCRIPTION: DESCRIPTION
	echo 'Version: $(version)' | cat $< - > $@

%.pdf: %.tex
	$(RR) CMD texi2dvi -c -q -p $<

check: $(Rcode) $(Rdocs) $(Rdocs2) $(Rtests) $(package)/DESCRIPTION ## $(package)/NAMESPACE
	$(RR) CMD check $(package)
	touch $@
