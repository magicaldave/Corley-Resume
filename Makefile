# Build all resume variants and check them.
#
#   make            build dist/*.pdf and run the checks
#   make pdf        build only
#   make check      check the PDFs already in dist/
#   make review     build build/review/*.pdf with unverified claims highlighted
#   make cover      build the cover letter template
#   make links      check every URL in the sources (needs network and curl)
#   make clean
#
# Override personal details for one build:
#   make LOCATION="Tulsa, OK" EMAIL=me@example.com PHONE="555 0100"

VARIANTS := ai-automation systems-engineering customer-engineering
SLUG     ?= Dave-Corley-Resume

# CI writes VERSION and SOURCE_DATE_EPOCH here; local builds ask git.
-include ci.mk
VERSION           ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
SOURCE_DATE_EPOCH ?= $(shell git log -1 --format=%ct 2>/dev/null || date +%s)
BUILD_DATE        := $(shell date -u -d @$(SOURCE_DATE_EPOCH) +%Y-%m-%d 2>/dev/null || date -u -r $(SOURCE_DATE_EPOCH) +%Y-%m-%d)
export SOURCE_DATE_EPOCH
export FORCE_SOURCE_DATE := 1

PRETEX := \def\resumeversion{$(VERSION)}\def\resumedate{$(BUILD_DATE)}
ifdef LOCATION
PRETEX += \def\resumelocation{$(LOCATION)}
endif
ifdef EMAIL
PRETEX += \def\resumeemail{$(EMAIL)}
endif
ifdef PHONE
PRETEX += \def\resumephone{$(PHONE)}
endif

# -g: always rerun. The version, date and overrides reach TeX on the command
# line, where latexmk cannot see that they changed.
LATEXMK := latexmk -pdf -g -interaction=nonstopmode -halt-on-error -file-line-error
SOURCES := resume.cls personal.tex $(wildcard personal.local.tex content/*.tex)
PDFS    := $(foreach v,$(VARIANTS),dist/$(SLUG)-$(v).pdf)

.PHONY: all pdf check review cover links clean FORCE
all: pdf check
pdf: $(PDFS)

dist/$(SLUG)-%.pdf: %.tex $(SOURCES) FORCE
	@mkdir -p build dist
	$(LATEXMK) -outdir=build -usepretex='$(PRETEX)' $< >build/$*.build.txt 2>&1 \
	  || { tail -n 30 build/$*.build.txt; exit 1; }
	@cp build/$*.pdf $@
	@echo "built $@"

check:
	@bash scripts/check.sh $(foreach v,$(VARIANTS),$(v):dist/$(SLUG)-$(v).pdf)

review:
	@mkdir -p build/review
	@for v in $(VARIANTS); do \
	  $(LATEXMK) -outdir=build/review \
	    -usepretex='$(PRETEX)\PassOptionsToClass{review}{resume}' $$v.tex >build/review/$$v.build.txt 2>&1 \
	    || { tail -n 30 build/review/$$v.build.txt; exit 1; }; \
	  echo "built build/review/$$v.pdf"; \
	done

cover:
	@mkdir -p build
	$(LATEXMK) -outdir=build -usepretex='$(PRETEX)' cover-letter.tex >build/cover-letter.build.txt 2>&1 \
	  || { tail -n 30 build/cover-letter.build.txt; exit 1; }
	@echo "built build/cover-letter.pdf"

links:
	@bash scripts/check.sh --links

clean:
	rm -rf build dist
