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
open Axtls

type ssl_func = unit -> unit ptr
val ssl_func : ssl_func typ

val ssl_library_init : unit -> int
val ssl_load_error_strings : unit -> unit
val ssl_ctx_new : ssl_func -> ssl_ctx_p
val ssl_ctx_free : ssl_ctx_p -> unit
val ssl_ctx_use_certificate_file : ssl_ctx_p -> string -> int -> int
val ssl_ctx_use_privatekey_file : ssl_ctx_p -> string -> int -> int
val ssl_ctx_use_certificate_asn1 : ssl_ctx_p -> int -> Unsigned.uint8 ptr -> int
val ssl_ctx_set_session_id_context : ssl_ctx_p -> string -> int -> int
val ssl_ctx_set_default_verify_paths : ssl_ctx_p -> int
val ssl_ctx_use_certificate_chain_file : ssl_ctx_p -> string -> int
val ssl_ctx_ctrl : ssl_ctx_p -> int -> Signed.long -> unit ptr -> Signed.long
val verify_callback : (int -> unit ptr -> int) typ
val ssl_ctx_set_verify : ssl_ctx_p -> int -> (int -> unit ptr -> int) -> unit
val ssl_ctx_set_verify_depth : ssl_ctx_p -> int -> unit
val ssl_ctx_load_verify_locations : ssl_ctx_p -> string -> string -> int
val ssl_load_client_ca_file : string -> unit ptr
val ssl_ctx_set_client_ca_list : ssl_ctx_p -> unit ptr -> unit
val ssl_ctx_set_default_passwd_cb : ssl_ctx_p -> unit ptr -> unit
val ssl_ctx_set_default_passwd_cd_userdata : ssl_ctx_p -> unit ptr -> unit
val ssl_ctx_check_private_key : ssl_ctx_p -> int
val ssl_ctx_set_cipher_list : ssl_ctx_p -> string -> int
val ssl_ctx_set_options : ssl_ctx_p -> int -> unit
val ssl_new : ssl_ctx_p -> ssl_p
val ssl_set_fd : ssl_p -> Unix.file_descr -> int
val ssl_accept : ssl_p -> int
val ssl_connect : ssl_p -> int
val ssl_free : ssl_p -> unit
val ssl_read : ssl_p -> unit ptr -> int -> int
val ssl_write : ssl_p -> unit ptr -> int -> int
val ssl_shutdown : ssl_p -> int
val ssl_peek : ssl_p -> unit ptr -> int -> int
val ssl_set_bio : ssl_p -> unit ptr -> unit ptr -> unit
val ssl_get_verify_result : ssl_p -> Signed.long
val ssl_state : ssl_p -> int
val ssl_get_peer_certificate : ssl_p -> unit ptr
val ssl_clear : ssl_p -> int
val ssl_get_error : ssl_p -> int -> int
val ssl_get1_session : ssl_p -> ssl_session_p
val ssl_set_session : ssl_p -> ssl_session_p -> int
val ssl_session_free : ssl_session_p -> unit
val sslv23_method : unit -> unit
