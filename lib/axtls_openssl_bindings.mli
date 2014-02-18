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

module type FOREIGN = sig
  val foreign : string -> ('a -> 'b) Ctypes.fn -> ('a -> 'b)
  val funptr : value:string -> typ:string ->
    ('a -> 'b) Ctypes.fn -> ('a -> 'b) Ctypes.typ

  val appl_module : string
end

module type S = Tls_types.OPENSSL_BASIC
  with type ssl_ctx     = Axtls.ssl_ctx_p
  and  type ssl         = Axtls.ssl_p
  and  type ssl_session = Axtls.ssl_session_p

module Make : functor (F : FOREIGN) -> S
