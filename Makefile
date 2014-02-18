.PHONY: build install uninstall reinstall clean

FINDLIB_NAME=axtls
BUILD=_build/lib
SRC=lib
GEN=gen/lib
FLAGS=-package ctypes.stubs -package ctypes.foreign -package fd-send-recv -package tls-types
EXTRA_META=requires = \"ctypes.foreign fd-send-recv tls-types\"

CFLAGS=-fPIC -Wall -Wextra -Werror -std=c99

build: $(GEN)/axtls_openssl_stubs_generated.ml
	ocamlbuild -use-ocamlfind -I $(SRC) -I $(GEN) $(FLAGS) \
		-lflags -dllib,-laxtls axtls.cma
	ocamlbuild -use-ocamlfind -I $(SRC) -I $(GEN) $(FLAGS) \
		-lflags -cclib,-laxtls axtls.cmxa
	$(CC) -shared -o $(BUILD)/dllaxtls.so -laxtls

$(GEN)/axtls_openssl_stubs_generated.ml: $(SRC)/axtls_openssl_bindings.ml
# TODO: linker flag is only to satisfy types
	ocamlbuild -use-ocamlfind -I $(SRC) $(FLAGS) \
		-lflags -cclib,-laxtls \
		axtls_openssl_stubs_generator.native
	rm axtls_openssl_stubs_generator.native
	mkdir -p $(GEN)
	$(BUILD)/axtls_openssl_stubs_generator.native $(GEN)

META: META.in
	cp META.in META
	echo $(EXTRA_META) >> META

install: META
	ocamlfind install $(FINDLIB_NAME) META \
		$(SRC)/axtls.mli \
		$(BUILD)/axtls.cmi \
		$(SRC)/axtls_openssl.mli \
		$(BUILD)/axtls_openssl.cmi \
		$(BUILD)/axtls.cma \
		$(BUILD)/axtls.cmxa \
		$(BUILD)/dllaxtls.so

uninstall:
	ocamlfind remove $(FINDLIB_NAME)

reinstall: uninstall install

clean:
	ocamlbuild -clean
	rm -rf $(GEN)
	rm -f META
