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

module type FOREIGN = Axtls_openssl_bindings.FOREIGN
module type S = Axtls_openssl_bindings.S
module Bindings = Axtls_openssl_bindings.Make

module Dynlink = Bindings(struct
  let foreign name typ = Foreign.foreign name typ
  let funptr ~value ~typ fn = Foreign.funptr fn
end)

module Stubs = Bindings(struct
  let foreign name _typ = Axtls_openssl_stubs_generated.find name
  let funptr ~value ~typ fn = Foreign.funptr fn (* TODO: never used? ok? *)
end)
