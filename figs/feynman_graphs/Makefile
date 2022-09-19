SHELL=/bin/bash

.PHONY: all clean

all: di_higgs_triangle.pdf di_higgs_box.pdf

higgs: higgs_hhh.pdf higgs_hhhh.pdf higgs_hww.pdf higgs_hzz.pdf higgs_hhww.pdf higgs_hhzz.pdf

prodmodes: higgs_prod_ggf.pdf higgs_prod_vbf.pdf higgs_prod_vh.pdf higgs_prod_tth.pdf

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
