(*
 * pa_optcomp.mli
 * --------------
 * Copyright : (c) 2011, Jeremie Dimino <jeremie@dimino.org>
 * Licence   : BSD3
 *
 * This file is a part of optcomp.
 *)

(** Optionnal compilation with cpp-like directives *)

(** Representation of values supported by optcomp. *)
type value =
  | Bool of bool
  | Int of int
  | Char of char
  | String of string
  | Tuple of value list

val define : string -> value -> unit
  (** [define id value] binds [id] to [value]. *)

val filter : Camlp4.PreCast.Gram.Token.Filter.token_filter
  (** The optcomp stream filter. *)
