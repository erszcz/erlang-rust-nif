ERLANG_SRC_DIR ?= ${HOME}/.kerl/builds/17.1/otp_src_17.1

ifeq ($(shell uname), Linux)
	## e.g. x86_64-unknown-linux-gnu
	ERLANG_PLATFORM ?= $(shell uname -m)-unknown-linux-gnu
	PLATFORM_SO := so
else
	## e.g. x86_64-apple-darwin13.4.0/
	ERLANG_PLATFORM ?= $(shell uname -m)-apple-darwin$(shell uname -r)
	PLATFORM_SO := dylib
endif

ERLNIF_INCLUDES := \
	-I ${ERLANG_SRC_DIR}/erts/emulator/beam \
	-I ${ERLANG_SRC_DIR}/erts/include/${ERLANG_PLATFORM}

native: priv/er.${PLATFORM_SO}

priv/er.${PLATFORM_SO}: rust_src/target/liberrust.${PLATFORM_SO}
	-mkdir priv
	cp $< $@

rust_src/target/liberrust.${PLATFORM_SO}: rust_src/src/c.rs
	cd rust_src && cargo build && cd target && ln -s liber-*.${PLATFORM_SO} liberrust.${PLATFORM_SO}

ERL_NIF_H := ${ERLANG_SRC_DIR}/erts/emulator/beam/erl_nif.h

BINDGEN ?= ${HOME}/work/rust-bindgen/target/bindgen -builtins

rust_src/src/c.rs: ${ERL_NIF_H}
	${BINDGEN} ${ERLNIF_INCLUDES} $< -o $@
