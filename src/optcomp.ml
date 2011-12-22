(*
 * optcomp.ml
 * ----------
 * Copyright : (c) 2009, Jeremie Dimino <jeremie@dimino.org>
 * Licence   : BSD3
 *
 * This file is a part of optcomp.
 *)

(* Standalone version *)

open Camlp4.PreCast
open Camlp4.Sig

let filter_keywords stream =
  Stream.from (fun _ -> match Stream.next stream with
                 | (SYMBOL ("#"|"="|"("|")"|"{"|"}"|"["|"]" as sym), loc) -> Some(KEYWORD sym, loc)
                 | x -> Some x)

external filter : 'a Gram.not_filtered -> 'a = "%identity"

module File_map = Map.Make(String)

(* Iterate over the filtered stream. *)
let rec print current_fname current_line current_col files token_stream =
  match try Some (Stream.next token_stream) with Stream.Failure -> None with
    | None ->
        ()
    | Some (EOI, _) ->
        flush stdout
    | Some (QUOTATION _, loc) ->
        Loc.raise loc (Failure "optcomp in standalone mode does not support quotations")
    | Some (tok, loc) ->
        let fname = Loc.file_name loc
        and off = Loc.start_off loc
        and line = Loc.start_line loc
        and col = Loc.start_off loc - Loc.start_bol loc
        and len = Loc.stop_off loc - Loc.start_off loc in
        (* Get the input. *)
        let ic, files =
          try
            (File_map.find fname files, files)
          with Not_found ->
            let ic = open_in fname in
            (ic, File_map.add fname ic files)
        in
        (* Go to the right position in the input. *)
        if pos_in ic <> off then seek_in ic off;
        (* Read the part to copy. *)
        let str = String.create len in
        really_input ic str 0 len;
        if current_fname = fname && current_line = line && current_col = col then
          (* If we at the right position, just print the string. *)
          print_string str
        else begin
          (* Otherwise print a location directive. *)
          if current_col > 0 then print_char '\n';
          Printf.printf "#%d %S\n" line fname;
          (* Ensure that the string start at the right column. *)
          for i = 1 to col do
            print_char ' '
          done;
          print_string str
        end;
        print fname (Loc.stop_line loc) (Loc.stop_off loc - Loc.stop_bol loc) files token_stream

let main () =
  if Array.length Sys.argv <> 2 then begin
    Printf.eprintf "usage: %s <file>\n%!" (Filename.basename Sys.argv.(0));
    exit 2
  end;
  try
    let fname = Sys.argv.(1) in
    let ic = open_in fname in
    (* Create the filtered token stream. *)
    let token_stream =
      Pa_optcomp.filter
        (filter_keywords
           (filter
              (Gram.lex (Loc.mk fname)
                 (Stream.of_channel ic))))
    in
    print "" (-1) (-1) File_map.empty token_stream
  with exn ->
    Format.eprintf "@[<v0>%a@]@." Camlp4.ErrorHandler.print exn;
    exit 1
