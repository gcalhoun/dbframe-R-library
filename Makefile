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

sourcedir := Rfiles
Rsource := $(wildcard $(sourcedir)/*.Rdw) 
Rsource2:= $(wildcard $(sourcedir)/*.Rd)
Rcode   := $(filter-out $(package)/R/dbframe-package.R, \
           $(Rsource:$(sourcedir)/%.Rdw=$(package)/R/%.R))
Rdocs   := $(Rsource:$(sourcedir)/%.Rdw=$(package)/man/%.Rd)
Rdocs2  := $(Rsource2:$(sourcedir)/%=$(package)/man/%)
Rtests  := $(Rsource:$(sourcedir)/%.Rdw=$(package)/inst/tests/test-%.R)

files := $(Rcode) $(Rdocs) $(Rdocs2) $(Rtests) $(package)/DESCRIPTION

.PHONY: all build burn pdf zip files

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
files: $(files)

$(Rtests): $(package)/inst/tests/test-%.R:$(sourcedir)/%.Rdw
	mkdir -p $(package)/inst/tests
	$(notangle) -R$(@F) $< | cpif $@

$(Rcode): $(package)/R/%.R: $(sourcedir)/%.Rdw
	mkdir -p $(package)/R
	$(notangle) $< | cpif $@

$(Rdocs): $(package)/man/%.Rd: $(sourcedir)/%.Rdw
	mkdir -p $(package)/man
	$(noweave) -delay -backend $(tord) $< > $@

$(Rdocs2): $(package)/man/%: $(sourcedir)/%
	mkdir -p $(package)/man
	cp $< $@

$(package)/DESCRIPTION: DESCRIPTION
	echo 'Version: $(version)' | cat $< - > $@

%.pdf: %.tex
	$(RR) CMD texi2dvi -c -q -p $<

check: $(files) $(package)/NAMESPACE
	$(RR) CMD check $(package)
	touch $@