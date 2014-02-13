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

open Ctypes
open Foreign

open Axtls

type ssl_func = unit -> unit ptr
let ssl_func : ssl_func typ = funptr (void @-> returning (ptr void))

let ssl_library_init =
  let c = foreign "SSL_library_init" (void @-> returning int) in
  fun () -> c ()

let ssl_load_error_strings =
  let c = foreign "SSL_load_error_strings" (void @-> returning void) in
  fun () -> c ()

let ssl_ctx_new =
  let c = foreign "SSL_CTX_new" (ssl_func @-> returning ssl_ctx_p) in
  fun meth -> c meth

let ssl_ctx_free =
  let c = foreign "SSL_CTX_free" (ssl_ctx_p @-> returning void) in
  fun ssl_ctx -> c ssl_ctx

let ssl_ctx_use_certificate_file =
  let c = foreign "SSL_CTX_use_certificate_file"
    (ssl_ctx_p @-> string @-> int @-> returning int)
  in
  fun ssl_ctx file typ -> c ssl_ctx file typ

let ssl_ctx_use_privatekey_file =
  let c = foreign "SSL_CTX_use_PrivateKey_file"
    (ssl_ctx_p @-> string @-> int @-> returning int)
  in
  fun ssl_ctx file typ -> c ssl_ctx file typ

let ssl_ctx_use_certificate_asn1 =
  let c = foreign "SSL_CTX_use_certificate_ASN1"
    (ssl_ctx_p @-> int @-> ptr uint8_t @-> returning int)
  in
  fun ssl_ctx len d -> c ssl_ctx len d

let ssl_ctx_set_session_id_context =
  let c = foreign "SSL_CTX_set_session_id_context"
    (ssl_ctx_p @-> string @-> int @-> returning int)
  in
  fun ssl_ctx sid_ctx sid_ctx_len -> c ssl_ctx sid_ctx sid_ctx_len

let ssl_ctx_set_default_verify_paths =
  let c = foreign "SSL_CTX_set_default_verify_paths"
    (ssl_ctx_p @-> returning int)
  in
  fun ssl_ctx -> c ssl_ctx

let ssl_ctx_use_certificate_chain_file =
  let c = foreign "SSL_CTX_use_certificate_chain_file"
    (ssl_ctx_p @-> string @-> returning int)
  in
  fun ssl_ctx file -> c ssl_ctx file

let ssl_ctx_ctrl =
  let c = foreign "SSL_CTX_ctrl"
    (ssl_ctx_p @-> int @-> long @-> ptr void @-> returning long)
  in
  fun ssl_ctx cmd larg parg -> c ssl_ctx cmd larg parg

let verify_callback = funptr (int @-> ptr void @-> returning int)
let ssl_ctx_set_verify =
  let c = foreign "SSL_CTX_set_verify"
    (ssl_ctx_p @-> int @-> verify_callback @-> returning void)
  in
  fun ssl_ctx mode verify_callback -> c ssl_ctx mode verify_callback

let ssl_ctx_set_verify_depth =
  let c = foreign "SSL_CTX_set_verify_depth"
    (ssl_ctx_p @-> int @-> returning void)
  in
  fun ssl_ctx depth -> c ssl_ctx depth

let ssl_ctx_load_verify_locations =
  let c = foreign "SSL_CTX_load_verify_locations"
    (ssl_ctx_p @-> string @-> string @-> returning int)
  in
  fun ssl_ctx ca_file ca_path -> c ssl_ctx ca_file ca_path

let ssl_load_client_ca_file =
  let c = foreign "SSL_load_client_CA_file" (string @-> returning (ptr void)) in
  fun file -> c file

let ssl_ctx_set_client_ca_list =
  let c = foreign "SSL_CTX_set_client_CA_list"
    (ssl_ctx_p @-> ptr void @-> returning void)
  in
  fun ssl_ctx file -> c ssl_ctx file

let ssl_ctx_set_default_passwd_cb =
  let c = foreign "SSL_CTX_set_default_passwd_cb"
    (ssl_ctx_p @-> ptr void @-> returning void)
  in
  fun ssl_ctx cb -> c ssl_ctx cb

let ssl_ctx_set_default_passwd_cd_userdata =
  let c = foreign "SSL_CTX_set_default_passwd_cb_userdata"
    (ssl_ctx_p @-> ptr void @-> returning void)
  in
  fun ssl_ctx u -> c ssl_ctx u

let ssl_ctx_check_private_key =
  let c = foreign "SSL_CTX_check_private_key" (ssl_ctx_p @-> returning int) in
  fun ssl_ctx -> c ssl_ctx

let ssl_ctx_set_cipher_list =
  let c = foreign "SSL_CTX_set_cipher_list"
    (ssl_ctx_p @-> string @-> returning int)
  in
  fun ssl_ctx str -> c ssl_ctx str

let ssl_ctx_set_options =
  let c = foreign "SSL_CTX_set_options"
    (ssl_ctx_p @-> int @-> returning void)
  in
  fun ssl_ctx option -> c ssl_ctx option

let ssl_new =
  let c = foreign "SSL_new" (ssl_ctx_p @-> returning ssl_p) in
  fun ssl_ctx -> c ssl_ctx

let ssl_set_fd =
  let c = foreign "SSL_set_fd" (ssl_p @-> int @-> returning int) in
  fun ssl fd -> c ssl (Fd_send_recv.int_of_fd fd)

let ssl_accept =
  let c = foreign "SSL_accept" (ssl_p @-> returning int) in
  fun ssl -> c ssl

let ssl_connect =
  let c = foreign "SSL_connect" (ssl_p @-> returning int) in
  fun ssl -> c ssl

let ssl_free =
  let c = foreign "SSL_free" (ssl_p @-> returning void) in
  fun ssl -> c ssl

let ssl_read =
  let c = foreign "SSL_read" (ssl_p @-> ptr void @-> int @-> returning int) in
  fun ssl buf num -> c ssl buf num

let ssl_write =
  let c = foreign "SSL_write" (ssl_p @-> ptr void @-> int @-> returning int) in
  fun ssl buf num -> c ssl buf num

let ssl_shutdown =
  let c = foreign "SSL_shutdown" (ssl_p @-> returning int) in
  fun ssl -> c ssl

let ssl_peek =
  let c = foreign "SSL_peek" (ssl_p @-> ptr void @-> int @-> returning int) in
  fun ssl buf num -> c ssl buf num

let ssl_set_bio =
  let c = foreign "SSL_set_bio"
    (ssl_p @-> ptr void @-> ptr void @-> returning void)
  in
  fun ssl rbio wbio -> c ssl rbio wbio

let ssl_get_verify_result =
  let c = foreign "SSL_get_verify_result" (ssl_p @-> returning long) in
  fun ssl -> c ssl

let ssl_state =
  let c = foreign "SSL_state" (ssl_p @-> returning int) in
  fun ssl -> c ssl

let ssl_get_peer_certificate =
  let c = foreign "SSL_get_peer_certificate" (ssl_p @-> returning (ptr void)) in
  fun ssl -> c ssl

let ssl_clear =
  let c = foreign "SSL_clear" (ssl_p @-> returning int) in
  fun ssl -> c ssl

let ssl_get_error =
  let c = foreign "SSL_get_error" (ssl_p @-> int @-> returning int) in
  fun ssl ret -> c ssl ret

let ssl_get1_session =
  let c = foreign "SSL_get1_session" (ssl_p @-> returning ssl_session_p) in
  fun ssl -> c ssl

let ssl_set_session =
  let c = foreign "SSL_set_session"
    (ssl_p @-> ssl_session_p @-> returning int)
  in
  fun ssl session -> c ssl session

let ssl_session_free =
  let c = foreign "SSL_session_free" (ssl_session_p @-> returning void) in
  fun session -> c session

let sslv23_method =
  let c = foreign "SSLv23_method" (void @-> returning void) in
  fun () -> c ()
