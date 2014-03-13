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

module type C = Tls_types.Openssl.BASIC_C
  with type ssl_ctx     = Axtls.ssl_ctx_p
  and  type ssl         = Axtls.ssl_p
  and  type ssl_session = Axtls.ssl_session_p

module Make(F : Cstubs.FOREIGN) = struct
  module Openssl_bindings = Tls_types.Openssl.Bindings(struct
    include F

    type x509_store_ctx = unit ptr

    let x509_store_ctx = ptr void
  end)
  include Openssl_bindings.Basic
  type 'a fn = 'a F.fn
  open F

  let bool = view
    ~read:(function 0 -> false | _ -> true)
    ~write:(fun b -> if b then 1 else 0)
    int

  let fd = view
    ~read:Fd_send_recv.fd_of_int
    ~write:Fd_send_recv.int_of_fd
    int

  type bio = unit ptr
  let bio : bio typ = ptr void

  type stack_of_x509_names = unit ptr
  let stack_of_x509_names : stack_of_x509_names typ = ptr void

  type pem_password_cb_t = char ptr -> int -> bool -> unit ptr -> int
  type pem_password_cb = pem_password_cb_t fn
  let pem_password_cb : pem_password_cb_t Ctypes.fn =
    ptr char @-> int @-> bool @-> ptr void @-> returning int
  let pem_password_cb_p : pem_password_cb typ = funptr pem_password_cb

  type ssl_method_t = unit -> unit ptr
  type ssl_method = ssl_method_t fn
  let ssl_method : ssl_method_t Ctypes.fn = void @-> returning (ptr void)
  let ssl_method_p : ssl_method typ = funptr ssl_method

  type ssl_ctx = Axtls.ssl_ctx_p
  let ssl_ctx = Axtls.ssl_ctx_p

  type ssl = Axtls.ssl_p
  let ssl = Axtls.ssl_p

  type ssl_session = Axtls.ssl_session_p
  let ssl_session = Axtls.ssl_session_p

  let x509_certificate_opt : Tls_types.X509.certificate option typ =
    ptr_opt void

  let sslv23_server_method = foreign "SSLv23_server_method" ssl_method
  let sslv3_server_method  = foreign "SSLv3_server_method"  ssl_method
  let tlsv1_server_method  = foreign "TLSv1_server_method"  ssl_method
  let sslv23_client_method = foreign "SSLv23_client_method" ssl_method
  let sslv3_client_method  = foreign "SSLv3_client_method"  ssl_method
  let tlsv1_client_method  = foreign "TLSv1_client_method"  ssl_method

  let ssl_library_init =
    foreign "SSL_library_init" (void @-> returning int)

  let ssl_load_error_strings =
    foreign "SSL_load_error_strings" (void @-> returning void)

  let ssl_ctx_new =
    foreign "SSL_CTX_new" (ssl_method_p @-> returning ssl_ctx)

  let ssl_ctx_free =
    foreign "SSL_CTX_free" (ssl_ctx @-> returning void)

  let ssl_ctx_use_certificate_file =
    foreign "SSL_CTX_use_certificate_file"
      (ssl_ctx @-> string @-> ssl_filetype @-> returning int)

  let ssl_ctx_use_privatekey_file =
    foreign "SSL_CTX_use_PrivateKey_file"
      (ssl_ctx @-> string @-> ssl_filetype @-> returning int)

  let ssl_ctx_use_certificate_asn1 =
    foreign "SSL_CTX_use_certificate_ASN1"
      (ssl_ctx @-> int @-> ptr uint8_t @-> returning int)

  let ssl_ctx_set_session_id_context =
    foreign "SSL_CTX_set_session_id_context"
      (ssl_ctx @-> string @-> int @-> returning int)

  let ssl_ctx_set_default_verify_paths =
    foreign "SSL_CTX_set_default_verify_paths" (ssl_ctx @-> returning int)

  let ssl_ctx_use_certificate_chain_file =
    foreign "SSL_CTX_use_certificate_chain_file"
      (ssl_ctx @-> string @-> returning int)

  let ssl_ctx_set_verify =
    foreign "SSL_CTX_set_verify"
      (ssl_ctx @-> ssl_verify_mode @-> verify_callback_p @-> returning void)

  let ssl_ctx_set_verify_depth =
    foreign "SSL_CTX_set_verify_depth" (ssl_ctx @-> int @-> returning void)

  let ssl_ctx_load_verify_locations =
    foreign "SSL_CTX_load_verify_locations"
      (ssl_ctx @-> string_opt @-> string_opt @-> returning int)

  let ssl_load_client_ca_file =
    foreign "SSL_load_client_CA_file" (string @-> returning stack_of_x509_names)

  let ssl_ctx_set_client_ca_list =
    foreign "SSL_CTX_set_client_CA_list"
      (ssl_ctx @-> stack_of_x509_names @-> returning void)

  let ssl_ctx_set_default_passwd_cb =
    foreign "SSL_CTX_set_default_passwd_cb"
      (ssl_ctx @-> pem_password_cb_p @-> returning void)

  let ssl_ctx_set_default_passwd_cd_userdata =
    foreign "SSL_CTX_set_default_passwd_cb_userdata"
      (ssl_ctx @-> ptr void @-> returning void)

  let ssl_ctx_check_private_key =
    foreign "SSL_CTX_check_private_key" (ssl_ctx @-> returning int)

  let ssl_ctx_set_cipher_list =
    foreign "SSL_CTX_set_cipher_list" (ssl_ctx @-> string @-> returning bool)

  let ssl_ctx_set_options =
    foreign "SSL_CTX_set_options" (ssl_ctx @-> int32_t @-> returning int32_t)

  let ssl_new =
    foreign "SSL_new" (ssl_ctx @-> returning ssl)

  let ssl_set_fd =
    foreign "SSL_set_fd" (ssl @-> fd @-> returning int)

  let ssl_accept =
    foreign "SSL_accept" (ssl @-> returning int)

  let ssl_connect =
    foreign "SSL_connect" (ssl @-> returning int)

  let ssl_free =
    foreign "SSL_free" (ssl @-> returning void)

  let ssl_read =
    foreign "SSL_read" (ssl @-> ptr void @-> int @-> returning int)

  let ssl_write =
    foreign "SSL_write" (ssl @-> ptr void @-> int @-> returning int)

  let ssl_shutdown =
    foreign "SSL_shutdown" (ssl @-> returning bool)

  let ssl_peek =
    foreign "SSL_peek" (ssl @-> ptr void @-> int @-> returning int)

  let ssl_set_bio =
    foreign "SSL_set_bio" (ssl @-> bio @-> bio @-> returning void)

  let ssl_get_verify_result =
    foreign "SSL_get_verify_result" (ssl @-> returning ssl_verify_error_opt)

  let ssl_state =
    foreign "SSL_state" (ssl @-> returning ssl_state)

  let ssl_get_peer_certificate =
    foreign "SSL_get_peer_certificate" (ssl @-> returning x509_certificate_opt)

  let ssl_clear =
    foreign "SSL_clear" (ssl @-> returning int)

  let ssl_get_error =
    foreign "SSL_get_error" (ssl @-> int @-> returning ssl_error)

  let ssl_get1_session =
    foreign "SSL_get1_session" (ssl @-> returning ssl_session)

  let ssl_set_session =
    foreign "SSL_set_session" (ssl @-> ssl_session @-> returning int)

  let ssl_session_free =
    foreign "SSL_SESSION_free" (ssl_session @-> returning void)
end
