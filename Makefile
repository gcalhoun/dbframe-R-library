package := dbframe
version := 0.2-1
zipfile := $(package)_$(version).tar.gz

R        := R
latexmk  := latexmk
noweave  := noweave
notangle := notangle
tord     := ./$(package)/shell/tord

LATEXMKFLAGS := -pdf -silent

sourcedir := $(package)/webs
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
	$(R) CMD build $(package)
$(package).Rcheck/$(package)-manual.pdf: check
burn: 
	rm $(package)/man/* $(package)/R/* $(package)/inst/tests/*
install: check
	sudo $(R) CMD INSTALL --debug $(package)
	touch $@
files: $(files)
online: $(zipfile) $(package).Rcheck/$(package)-manual.pdf
	scp $^ econ22.econ.iastate.edu:public_html/software
	touch $@

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
	$(R) CMD texi2dvi -c -q -p $<

check: $(files) $(package)/NAMESPACE
	$(R) CMD check $(package)
	touch $@