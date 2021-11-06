# Makefile to run pdflatex, lualatex or xelatex on a thesis
# Can also run feynmf/feynmp/tikz/pyfeyn/pyfeynhand on files in a directory

THESIS = phd_thesis
# EXTRACMD = --shell-escape
FEYNDIR = feynmf
FEYNFILES = $(wildcard $(FEYNDIR)/*.tex)
TIKZDIR = tikz
TIKZFILES = $(wildcard $(TIKZDIR)/*.tex)
PYFEYNDIR = pyfeyn
PYFEYNFILES = $(wildcard $(PYFEYNDIR)/*.py)
PYFEYNHANDDIR = pyfeynhand
PYFEYNHANDFILES = $(wildcard $(PYFEYNHANDDIR)/*.py)
ifdef file
FEYNFILES = $(FEYNDIR)/$(file).tex
TIKZFILES = $(TIKZDIR)/$(file).tex
PYFEYNFILES = $(PYFEYNDIR)/$(file).py
PYFEYNHANDFILES = $(PYFEYNHANDDIR)/$(file).py
endif
LATEXCMD = pdflatex
BIBTEX = biber
AWKDIR=..

.PHONY: cover \
	feynmf feynmp tikz pyfeyn pyfeynhand \
	cleanthesis cleancover \
	cleanfeynmf cleanfeynmp cleantikz cleanpyfeyn cleanpictpdf \
	cleanblx cleanbbl \
	cleanglo cleanlatexmk\
	help test

thesis: run_latexmk

thesislua: run_lualatexmk

thesisxe: run_xelatexmk

# Use latexmk to compile thesis
run_latexmk: $(THESIS).tex *.tex bib/*.bib
	latexmk -pdf $(THESIS)
	# LATEXMK = latexmk -e '$$pdflatex=q/pdflatex %O -shell-escape %S/' -pdf $(THESIS)

run_lualatexmk: $(THESIS).tex *.tex bib/*.bib
	latexmk -lualatex $(THESIS)
	# latexmk -e '$$lualatex=q/lualatex %O -shell-escape %S/' -lualatex $(THESIS)

run_xelatexmk: $(THESIS).tex *.tex bib/*.bib
	latexmk -xelatex $(THESIS)
	# latexmk -e '$$xelatex=q/xelatex %O -shell-escape %S/' -xelatex $(THESIS)

# - in front of bibtex means compilation continues even if there is an error
thesis11: $(THESIS).tex *.tex bib/*.bib
	$(LATEXCMD)   $(EXTRACMD) $(THESIS)
	$(BIBTEX)  $(THESIS)
	# makeglossaries $(THESIS)
	$(LATEXCMD)   $(EXTRACMD) $(THESIS)
	$(LATEXCMD)   $(EXTRACMD) $(THESIS)

cover:
	$(LATEXCMD)   $(EXTRACMD) cover_only
	$(LATEXCMD)   $(EXTRACMD) cover_only

feynmf:
	make -f ../Makefile FEYNDIR=$(FEYNDIR) FEYNFILES="$(FEYNFILES)" \
	 AWKDIR=$(AWKDIR) feynmf

feynmp:
	make -f ../Makefile FEYNDIR=$(FEYNDIR) FEYNFILES="$(FEYNFILES)" \
	 AWKDIR=$(AWKDIR) feynmp

tikz:
	make -f ../Makefile TIKZDIR=$(TIKZDIR) TIKZFILES="$(TIKZFILES)" tikz

pyfeyn:
	make -f ../Makefile PYFEYNDIR=$(PYFEYNDIR) PYFEYNFILES="$(PYFEYNFILES)" pyfeyn

pyfeynhand:
	make -f ../Makefile PYFEYNHANDDIR=$(PYFEYNHANDDIR) PYFEYNHANDFILES="$(PYFEYNHANDFILES)" pyfeynhand

thesis_feynmf:
	feynmf $(THESIS)

cleanall: clean cleanbbl cleanpictpdf

clean: cleanthesis cleancover \
	cleanfeynmf cleanfeynmp cleantikz cleanpyfeyn cleanpyfeynhand \
	cleanblx cleanglo cleanlatexmk

cleanthesis:
	-rm $(THESIS).log $(THESIS).aux $(THESIS).toc
	-rm $(THESIS).lof $(THESIS).lot $(THESIS).out
	-rm $(THESIS).blg $(THESIS).bbl $(THESIS).pdf $(THESIS).xdv
	-rm $(THESIS).fdb_latexmk .$(THESIS).lb $(THESIS).synctex.gz
	-rm *.aux

cleancover:
	-rm cover_only.log cover_only.aux cover_only.out
	-rm cover_only.pdf

cleanfeynmf:
	-rm *.mf *.tfm *.t1 *.600gf *.600pk *.log
	-rm feynmf_all.* feynmf_files.inp

cleanfeynmp:
	-rm *.1 *.log *.mp *.t1
	-rm feynmf_all.* feynmf_files.inp

cleantikz:
	-rm $(TIKZDIR)/*.aux $(TIKZDIR)/*.log

cleanpyfeynhand:
	-rm $(PYFEYNHANDDIR)/*.tex $(PYFEYNHANDDIR)/*aux $(PYFEYNHANDDIR)/*.log

cleanpictpdf:
	-rm $(FEYNDIR)/*.pdf
	-rm $(TIKZDIR)/*.pdf
	-rm $(PYFEYNDIR)/*.pdf
	-rm $(PYFEYNHANDDIR)/*.pdf

cleanblx:
	-rm *-blx.bib
	-rm *.bcf
	-rm *.run.xml

cleanbbl:
	-rm *.bbl

cleanglo:
	-rm *.acn *.acr *.alg
	-rm *.glg *.glo *.gls
	-rm *.ist

cleanlatexmk:
	-rm *.fdb_latexmk *.fls

help:
	@echo "Possible commands:"
	@echo "new [THESIS=dirname]: Set up a new thesis"
	@echo "thesis: Compile complete thesis (latexmk)"
	@echo "run_latexmk: Compile complete thesis using latexmk"
	@echo "thesis11: Compile complete thesis (not using latexmk)"
	@echo "feynmf: Run feynmf for all .tex files in $(FEYNDIR)"
	@echo "feynmp: Run feynmp for all .tex files in $(FEYNDIR)"
	@echo "tikz:   Run tikz for all .tex files in $(TIKZDIR)"
	@echo "pyfeyn: Run Python for all .py files in $(PYFEYNDIR)"
	@echo "pyfeynhand: Run Python for all .py files in $(PYFEYNHANDDIR)"
	@echo "clean:         Clean up most auxiliary files (leaves bbl and picture PDF files)"
	@echo "cleanall:      Clean up all auxiliary files"
	@echo "cleanthesis:   Clean up thesis LaTeX output files"
	@echo "cleanbbl:      Clean up thesis bbl files"
	@echo "cleanblx:      Clean up thesis biber files"
	@echo "cleanfeynmf:   Clean up feynmf output files"
	@echo "cleantikz:     Clean up tikz temparary files"
	@echo "cleanpyfeynhand: Clean up pyfeynhand temporary files"
	@echo "cleanpictpdf:  Clean up picture output in $(FEYNDIR), $(TIKZDIR), $(PYFEYNDIR) and $(PYFEYNHANDDIR)"
	@echo "cleanglo:      Clean up glossary output files"
	@echo "cleanlatexmk:  Clean up latexmk files"

test:
	@echo "Thesis $(THESIS)"
	@echo "Feynmf Feynman graphs dir: $(FEYNDIRNAME)"
	@echo "Feynmf Feynman graphs files: $(FEYNFILES)"
	@echo "TikZ   Feynman graphs dir: $(TIKZDIRNAME)"
	@echo "TikZ   Feynman graphs files: $(TIKZFILES)"
	@echo "PyFeyn Feynman graphs dir: $(PYFEYNDIRNAME)"
	@echo "PyFeyn Feynman graphs files: $(PYFEYNFILES)"
	@echo "PyFeynHand Feynman graphs dir: $(PYFEYNHANDDIRNAME)"
	@echo "PyFeynHand Feynman graphs files: $(PYFEYNHANDFILES)"
