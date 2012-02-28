package := dbframe

R        := R
latexmk  := latexmk
noweave  := noweave
notangle := notangle
tord     := ~/Desktop/illiterate.git/tord

LATEXMKFLAGS := -pdf -silent

sourcedir   := source
pkgfilesdir := pkgfiles

pkgfiles    := $(addprefix $(package)/,DESCRIPTION NAMESPACE NEWS README.org)

Rsource := $(wildcard $(sourcedir)/*.rw)
Rsource2:= $(wildcard $(sourcedir)/*.Rd)
Rcopy   := $(Rsource:$(sourcedir)/%.rw=$(package)/rw/%.rw)
Rcode   := $(filter-out $(package)/R/dbframe-package.R, \
           $(Rsource:$(sourcedir)/%.rw=$(package)/R/%.R))
Rdocs   := $(Rsource:$(sourcedir)/%.rw=$(package)/man/%.Rd)
Rdocs2  := $(Rsource2:$(sourcedir)/%=$(package)/man/%)
Rtests  := $(Rsource:$(sourcedir)/%.rw=$(package)/inst/tests/test-%.R)

files := $(Rcode) $(Rdocs) $(Rdocs2) $(Rtests) $(pkgfiles) $(Rcopy)

.PHONY: all check burn files clean

all: check

clean: 
	rm misc/*~ $(pkgfilesdir)/*~ $(sourcedir)/*~ tests/*~ *~

burn: burn
	rm $(package) $(package).Rcheck

files: $(files)

$(Rtests): $(package)/inst/tests/test-%.R:$(sourcedir)/%.rw
	mkdir -p $(package)/inst/tests
	$(notangle) -R$(@F) $< | cpif $@

$(Rcode): $(package)/R/%.R: $(sourcedir)/%.rw misc/license-boilerplate.txt
	mkdir -p $(package)/R
	$(notangle) $< | cat misc/license-boilerplate.txt - | cpif $@

$(Rcopy): $(package)/rw/%: $(sourcedir)/%
	mkdir -p $(package)/rw
	cp $< $@

$(Rdocs): $(package)/man/%.Rd: $(sourcedir)/%.rw
	mkdir -p $(package)/man
	$(noweave) -delay -backend $(tord) $< > $@

$(Rdocs2): $(package)/man/%: $(sourcedir)/%
	mkdir -p $(package)/man
	cp $< $@

$(package)/tests/dbframe-package.R: tests/dbframe-package.R
	mkdir -p $(@D)
	cp $< $(@D)

$(package)/NEWS: NEWS
	mkdir -p $(@D)
	cp $< $(package)
$(package)/DESCRIPTION: $(pkgfilesdir)/DESCRIPTION
	mkdir -p $(@D)
	cp $< $(package)
$(package)/README.org: README.org
	mkdir -p $(@D)
	cp $< $(package)
$(package)/NAMESPACE: $(pkgfilesdir)/NAMESPACE
	mkdir -p $(@D)
	cp $< $(package)

check: $(files) $(pkgfiles) $(package)/tests/dbframe-package.R
	$(R) CMD check $(package)