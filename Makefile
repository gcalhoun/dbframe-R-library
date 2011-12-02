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
Rsource := $(wildcard $(sourcedir)/*.rnw) 
Rsource2:= $(wildcard $(sourcedir)/*.Rd)
Rcode   := $(filter-out $(package)/R/dbframe-package.R, \
           $(Rsource:$(sourcedir)/%.rnw=$(package)/R/%.R))
Rdocs   := $(Rsource:$(sourcedir)/%.rnw=$(package)/man/%.Rd)
Rdocs2  := $(Rsource2:$(sourcedir)/%=$(package)/man/%)
Rtests  := $(Rsource:$(sourcedir)/%.rnw=$(package)/inst/tests/test-%.R)

files := $(Rcode) $(Rdocs) $(Rdocs2) $(Rtests) $(package)/DESCRIPTION

.PHONY: all burn files

all: check
$(package).Rcheck/$(package)-manual.pdf: check

burn: 
	rm $(package)/man/* $(package)/R/* $(package)/inst/tests/*

files: $(files)

$(Rtests): $(package)/inst/tests/test-%.R:$(sourcedir)/%.rnw
	mkdir -p $(package)/inst/tests
	$(notangle) -R$(@F) $< | cpif $@

$(Rcode): $(package)/R/%.R: $(sourcedir)/%.rnw
	mkdir -p $(package)/R
	$(notangle) $< | cpif $@

$(Rdocs): $(package)/man/%.Rd: $(sourcedir)/%.rnw
	mkdir -p $(package)/man
	$(noweave) -delay -backend $(tord) $< > $@

$(Rdocs2): $(package)/man/%: $(sourcedir)/%
	mkdir -p $(package)/man
	cp $< $@

$(package)/DESCRIPTION: DESCRIPTION
	echo 'Version: $(version)' | cat $< - > $@

check: $(files) $(package)/NAMESPACE
	$(R) CMD check $(package)
	touch $@