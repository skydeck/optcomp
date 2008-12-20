# Makefile
# --------
# Copyright : (c) 2008, Jeremie Dimino <jeremie@dimino.org>
# Licence   : BSD3
#
# This file is a part of optcomp.

OF = ocamlfind

NAME = optcomp
VERSION = $(shell head -n 1 VERSION)

.PHONY: all test syntax install prefix

all: META pa_optcomp.cmo

pa_optcomp.cmo: pa_optcomp.ml
	ocamlc -I +camlp4 -pp camlp4of -c pa_optcomp.ml

META: VERSION META.in
	sed -e 's/@VERSION@/$(VERSION)/' META.in > META

dist:
	DARCS_REPO=$(PWD) darcs dist --dist-name $(NAME)-$(VERSION)

install:
	$(OF) install $(NAME) META pa_optcomp.cmo sample.ml

uninstall:
	$(OF) remove $(NAME)

clean:
	rm -f *.cm* META $(NAME)-*.tar.gz
