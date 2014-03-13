(*
 * Copyright (c) 2014 David Sheets <sheets@alum.mit.edu>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

let c_headers = "
#include \"cstubs/cstubs_internals.h\"
"

let prefix = "axtls_openssl_stub_"

let main path =
  let ml_out = open_out (path^"/axtls_openssl_stubs.ml") in
  let c_out  = open_out (path^"/axtls_openssl_stubs.c") in
  let ml_fmt = Format.formatter_of_out_channel ml_out in
  let c_fmt  = Format.formatter_of_out_channel c_out in
  Format.fprintf c_fmt "%s@\n" c_headers;
  Cstubs.write_c  c_fmt  ~prefix (module Axtls_openssl_bindings.Make);
  Cstubs.write_ml ml_fmt ~prefix (module Axtls_openssl_bindings.Make);
  Format.pp_print_flush ml_fmt ();
  Format.pp_print_flush c_fmt ();
  close_out ml_out;
  close_out c_out

;;

main Sys.argv.(1)
