#
#
#

LP 		= lipsum
OCB 		= ocamlbuild

SRC 		= frmt.ml scanner.mll

all: 		$(SRC)
		$(OCB) frmt.native

clean: 		
		$(OCB) -clean
		rm -f $(SRC)
		rm -f frmt.md

frmt.ml: 	format.lp
		$(LP) tangle -f cpp $@ $< > $@
		
scanner.mll: 	format.lp
		$(LP) tangle -f cpp $@ $< > $@

format.md: 	format.lp
		$(LP) weave $< > $@
