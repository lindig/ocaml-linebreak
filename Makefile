#
# Makefile
#
# The source code in format.lp is a literate program. Use 
# https://github.com/lindig/lipsum.git to extract the 
# code for compilation.
#

LP 		= lipsum
OCB 		= ocamlbuild

SRC 		= demo.ml linebreak.ml linebreak.mli scanner.mll

all: 		$(SRC) README.md
		$(OCB) demo.native

clean: 		
		$(OCB) -clean
		rm -f $(SRC)
		rm -f format.md

%.ml:		format.lp
		$(LP) tangle -f cpp $@ $< > $@

%.mli:		format.lp
		$(LP) tangle -f cpp $@ $< > $@

%.mll:		format.lp
		$(LP) tangle -f cpp $@ $< > $@
	    
README.md: 	format.lp
		$(LP) weave $< > $@
