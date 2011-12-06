package := dbframe
version := 0.2.3
zipfile := $(package)_$(version).tar.gz

R        := R
latexmk  := latexmk
noweave  := noweave
notangle := notangle
tord     := ./$(package)/shell/tord

LATEXMKFLAGS := -pdf -silent

sourcedir := $(package)/rw
Rsource := $(wildcard $(sourcedir)/*.rw) 
Rsource2:= $(wildcard $(sourcedir)/*.Rd)
Rcode   := $(filter-out $(package)/R/dbframe-package.R, \
           $(Rsource:$(sourcedir)/%.rw=$(package)/R/%.R))
Rdocs   := $(Rsource:$(sourcedir)/%.rw=$(package)/man/%.Rd)
Rdocs2  := $(Rsource2:$(sourcedir)/%=$(package)/man/%)
Rtests  := $(Rsource:$(sourcedir)/%.rw=$(package)/inst/tests/test-%.R)

files := $(Rcode) $(Rdocs) $(Rdocs2) $(Rtests) $(package)/DESCRIPTION

.PHONY: all burn files

all: check
$(package).Rcheck/$(package)-manual.pdf: check

burn: 
	rm $(package)/man/* $(package)/R/* $(package)/inst/tests/*

files: $(files)

$(Rtests): $(package)/inst/tests/test-%.R:$(sourcedir)/%.rw
	mkdir -p $(package)/inst/tests
	$(notangle) -R$(@F) $< | cpif $@

$(Rcode): $(package)/R/%.R: $(sourcedir)/%.rw
	mkdir -p $(package)/R
	$(notangle) $< | cat license-boilerplate.txt - | cpif $@

$(Rdocs): $(package)/man/%.Rd: $(sourcedir)/%.rw
	mkdir -p $(package)/man
	$(noweave) -delay -backend $(tord) $< > $@

$(Rdocs2): $(package)/man/%: $(sourcedir)/%
	mkdir -p $(package)/man
	cp $< $@

$(package)/DESCRIPTION: DESCRIPTION
	echo 'Version: $(version)' | cat $< - > $@

check: $(files) $(package)/NAMESPACE
	cp README.org $(package)/README
	$(R) CMD check $(package)
	touch $@