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

all: 		$(SRC)
		$(OCB) demo.native

clean: 		
		$(OCB) -clean
		rm -f $(SRC)
		rm -f format.md

linebreak.ml: 	format.lp
		$(LP) tangle -f cpp $@ $< > $@

linebreak.mli: 	format.lp
		$(LP) tangle -f cpp $@ $< > $@

scanner.mll: 	format.lp
		$(LP) tangle -f cpp $@ $< > $@

demo.ml:	format.lp
		$(LP) tangle -f cpp $@ $< > $@
	    
format.md: 	format.lp
		$(LP) weave $< > $@
