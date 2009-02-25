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

NAME = optcomp
ALL = pa_optcomp.cmo optcomp_o.byte optcomp_r.byte

.PHONY: all
all:
	$(OC) META $(ALL)

.PHONY: dist
dist:
	DARCS_REPO=$(PWD) darcs dist --dist-name $(NAME)-`head -n 1 VERSION`

.PHONY: install
install:
	$(OF) install $(NAME) _build/META $(ALL:%=_build/%) \
	      sample.ml sample_incl.ml

.PHONY: uninstall
uninstall:
	$(OF) remove $(NAME)

.PHONY: clean
clean:
	$(OC) -clean
