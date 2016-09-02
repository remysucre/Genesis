.PHONY: clean main view redo ungen

main : main.pdf

view : main
	zathura main.pdf

main.pdf : $(TEXFILES)
	latexmk -bibtex -pdf main.tex

redo :
	$(MAKE) main || ($(MAKE) ungen && $(MAKE) grammar )

ungen :
	latexmk -pdf -C -quiet main.tex

clean : ungen
