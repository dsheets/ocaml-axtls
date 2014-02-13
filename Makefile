.PHONY: build install uninstall reinstall clean

FINDLIB_NAME=axtls
BUILD=_build/lib
SRC=lib
FLAGS=-package ctypes.foreign -package fd-send-recv
EXTRA_META=requires = \"ctypes.foreign\"

CFLAGS=-fPIC -Wall -Wextra -Werror -std=c99

build:
	mkdir -p $(BUILD)
	ocamlfind ocamlc -o $(BUILD)/axtls.cmi -I $(BUILD) -I $(SRC) \
		$(FLAGS) -c $(SRC)/axtls.mli
	ocamlfind ocamlc -o $(BUILD)/axtls_openssl.cmi -I $(BUILD) -I $(SRC) \
		$(FLAGS) -c $(SRC)/axtls_openssl.mli
	ocamlfind ocamlmklib -o $(BUILD)/axtls -I $(BUILD) \
		$(FLAGS) $(SRC)/axtls.ml $(SRC)/axtls_openssl.ml

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
		$(BUILD)/axtls.cmxa

uninstall:
	ocamlfind remove $(FINDLIB_NAME)

reinstall: uninstall install

clean:
	rm -rf _build
	bash -c "rm -f META lib/{axtls,axtls_openssl}.cm?"
