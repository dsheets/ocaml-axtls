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

module Bindings = Axtls_openssl_bindings.Make

module type S = Tls_types.Openssl.BASIC
  with type ssl_ctx     = Axtls.ssl_ctx_p
  and  type ssl         = Axtls.ssl_p
  and  type ssl_session = Axtls.ssl_session_p
module type C = Tls_types.Openssl.BASIC_C
  with type 'a fn = 'a
  and  type ssl_ctx     = Axtls.ssl_ctx_p
  and  type ssl         = Axtls.ssl_p
  and  type ssl_session = Axtls.ssl_session_p

module Wrap(C : C) : S = struct
  open Tls_types.Openssl.Basic
  include C

  let ssl_library_init () =
    if ssl_library_init () = 1 then ()
    (* As specified at
       <http://www.openssl.org/docs/ssl/SSL_library_init.html>,
       this should never occur.
    *)
    else raise (Failure "SSL_library_init")

  let ssl_ctx_use_certificate_file ssl_ctx file typ =
    (* TODO: FIXME *)
    if ssl_ctx_use_certificate_file ssl_ctx file typ <> 1
    then raise (Failure "ssl_ctx_use_certificate_file check err stack")

  let ssl_ctx_use_privatekey_file ssl_ctx file typ =
    (* TODO: FIXME *)
    if ssl_ctx_use_privatekey_file ssl_ctx file typ <> 1
    then raise (Failure "ssl_ctx_use_privatekey_file check err stack")

  let ssl_ctx_use_certificate_asn1 ssl_ctx buf len =
    (* TODO: FIXME *)
    if ssl_ctx_use_certificate_asn1 ssl_ctx len buf <> 1
    then raise (Failure "ssl_ctx_use_certificate_asn1 check err stack")

  let ssl_ctx_set_session_id_context ssl_ctx sid_ctx sid_ctx_len =
    (* TODO: FIXME *)
    if ssl_ctx_set_session_id_context ssl_ctx sid_ctx sid_ctx_len <> 1
    then raise (Failure "ssl_ctx_set_session_id_context over max length")

  let ssl_ctx_set_default_verify_paths ssl_ctx =
    (* TODO: FIXME *)
    if ssl_ctx_set_default_verify_paths ssl_ctx <> 1
    then raise (Failure "ssl_ctx_set_default_verify_paths error")

  let ssl_ctx_use_certificate_chain_file ssl_ctx file =
    (* TODO: FIXME *)
    if ssl_ctx_use_certificate_chain_file ssl_ctx file <> 1
    then raise (Failure "ssl_ctx_use_certificate_chain_file check err stack")

  let ssl_ctx_load_verify_locations ssl_ctx ?cafile ?capath () =
    (* TODO: FIXME *)
    if ssl_ctx_load_verify_locations ssl_ctx cafile capath <> 1
    then raise (Failure "ssl_ctx_load_verify_locations check err stack")

  let ssl_ctx_check_private_key ssl_ctx =
    (* TODO: FIXME *)
    if ssl_ctx_check_private_key ssl_ctx <> 1
    then raise (Failure "ssl_ctx_check_private_key check err stack")

  let ssl_set_fd ssl fd =
    (* TODO: FIXME *)
    if ssl_set_fd ssl fd <> 1
    then raise (Failure "ssl_set_fd check err stack")

  let ssl_accept ssl =
    (* TODO: FIXME *)
    let ret = ssl_accept ssl in
    if ret = 0 then match ssl_get_error ssl ret with
    | None -> raise (Failure "ssl_accept ret 0 but no error available")
    | Some e -> raise (SSLError e)
    else if ret < 0 then match ssl_get_error ssl ret with
    | None -> raise (Failure "ssl_accept ret <0 but no error available")
    | Some e -> raise (SSLFatalError e)
    else ()

  let ssl_connect ssl =
    (* TODO: FIXME *)
    let ret = ssl_connect ssl in
    if ret = 0 then match ssl_get_error ssl ret with
    | None -> raise (Failure "ssl_connect ret 0 but no error available")
    | Some e -> raise (SSLError e)
    else if ret < 0 then match ssl_get_error ssl ret with
    | None -> raise (Failure "ssl_connect ret <0 but no error available")
    | Some e -> raise (SSLFatalError e)
    else ()

  let ssl_set_bio ssl ~rbio ~wbio = ssl_set_bio ssl rbio wbio

  let ssl_clear ssl =
    (* TODO: FIXME *)
    if ssl_clear ssl <> 1
    then raise (Failure "ssl_clear check err stack")

  let ssl_set_session ssl ssl_session =
    (* TODO: FIXME *)
    if ssl_set_session ssl ssl_session <> 1
    then raise (Failure "ssl_set_session check err stack")

end

(* TODO:
module Dynlink : S = struct
  module C = Bindings(Foreign)
  module I = Wrap(C)
  include I
end
*)
module Stubs : S = struct
  module C = Bindings(Axtls_openssl_stubs)
  module I = Wrap(C)
  include I
end
