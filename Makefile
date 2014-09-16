ERLANG_SRC_DIR ?= /home/erszcz/.kerl/builds/17.0/otp_src_17.0
ERLANG_PLATFORM ?= x86_64-unknown-linux-gnu
PLATFORM_SO := so

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

BINDGEN ?= bindgen

rust_src/src/c.rs: ${ERL_NIF_H}
	${BINDGEN} ${ERLNIF_INCLUDES} $< -o $@
