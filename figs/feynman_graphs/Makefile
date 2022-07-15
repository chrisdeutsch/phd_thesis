SHELL=/bin/bash

.PHONY: all clean

all: di_higgs_triangle.pdf di_higgs_box.pdf

cleanall: clean
	rm -f *.pdf

clean:
	rm -f *.aux
	rm -f *.log
	rm -f *.1
	rm -f *.mp
	rm -f *.t1

%.pdf: %.tex
	pdflatex $<
	mpost $*_fmf.mp
	pdflatex $<
	pdfcrop --margin 3 $*.pdf $*.pdf
