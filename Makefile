# Makefile
# --------
# Copyright : (c) 2008, Jeremie Dimino <jeremie@dimino.org>
# Licence   : BSD3
#
# This file is a part of optcomp.

ifeq ($(TERM),dumb)
OC = ocamlbuild -classic-display
else
OC = ocamlbuild
endif
OF = ocamlfind

PREFIX = /usr/local
NAME = optcomp

.PHONY: all
all:
	$(OC) META pa_optcomp.cmo optcomp_o.byte optcomp_r.byte

.PHONY: dist
dist:
	DARCS_REPO=$(PWD) darcs dist --dist-name $(NAME)-$(VERSION)

.PHONY: install
install:
	$(OF) install $(NAME) _build/META _build/pa_optcomp.cmo \
	      sample.ml sample_incl.ml
	install -m 0755 optcomp_o.byte $(PREFIX)/bin/optcomp_o
	install -m 0755 optcomp_r.byte $(PREFIX)/bin/optcomp_r

.PHONY: uninstall
uninstall:
	$(OF) remove $(NAME)
	rm -f $(PREFIX)/bin/optcomp_o $(PREFIX)/bin/optcomp_r

.PHONY: clean
clean:
	$(OC) -clean
