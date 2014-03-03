DOC=ErlangHandbook
DOC_RU=ErlangHandbook-RU
REV=`git log -n1 | grep 'Date:' | sed 's/Date:   //g'`

.PHONY: all
all: english russian

.PHONY: english
english: $(DOC).pdf

.PHONY: russian
russian: $(DOC_RU).pdf

.PHONY: release
release: clean all
	git add output/$(DOC).pdf output/$(DOC_RU).pdf
	git commit -m "release: $(REV)"
	git push

.PHONY: clean
clean:
	rm -f *.pdf *.dvi *.aux *.log *.nav *.out *.snm *.toc *.vrb *.bbl *.blg \
			*.lof *.lot *.ilg *.ind *.nlo *.nls *.tdo *.gz *.depend

.PHONY: view
view:
	evince $(DOC).pdf &

XELATEX=xelatex -synctex=1 -interaction=nonstopmode --shell-escape
$(DOC_RU).pdf: chapters-RU/*.tex $(DOC_RU).tex
	$(XELATEX) $(DOC_RU).tex && \
	$(XELATEX) $(DOC_RU).tex && \
	mv -f $(DOC_RU).pdf output/

PDFLATEX=pdflatex -synctex=1 -interaction=nonstopmode --shell-escape
$(DOC).pdf: chapters/*.tex $(DOC).tex
	$(PDFLATEX) $(DOC).tex && \
	$(PDFLATEX) $(DOC).tex && \
	mv -f $(DOC).pdf output/
