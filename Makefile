# Makefile
# --------
# Copyright : (c) 2008, Jeremie Dimino <jeremie@dimino.org>
# Licence   : BSD3
#
# This file is a part of optcomp.

OF = ocamlfind

.PHONY: all test syntax install prefix

all: pa_optcomp.cmo

pa_optcomp.cmo: pa_optcomp.ml
	ocamlc -I +camlp4 -pp camlp4of -c pa_optcomp.ml

install:
	$(OF) install optcomp META pa_optcomp.cmo sample.ml

uninstall:
	$(OF) remove optcomp

clean:
	rm -f *.cm*
