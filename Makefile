# Please override these to match your environment!
ERLANG_SRC_DIR ?= ${HOME}/.kerl/builds/17.1/otp_src_17.1
ERLANG_EI_LIB_DIR ?= ${HOME}/apps/erlang/17.1/lib/erl_interface-3.7.17/lib
RUST_DIR ?= ${HOME}/apps/rust/1.0.0

# Past this line the stuff should not require any fiddling with.
RUST_LIBS := ${RUST_DIR}/
LDFLAGS = -L${ERLANG_EI_LIB_DIR} -lerl_interface -lei

ifeq ($(shell uname), Darwin)
	## e.g. x86_64-apple-darwin
	RUST_PLATFORM ?= $(shell uname -m)-apple-darwin
	## e.g. x86_64-apple-darwin13.4.0
	ERLANG_PLATFORM ?= ${RUST_PLATFORM}$(shell uname -r)
	#PLATFORM_SO := dylib
	# For whaterver reason Erlang looks for .so files even on MacOSX
	PLATFORM_SO := so
else
	## e.g. x86_64-unknown-linux-gnu
	RUST_PLATFORM ?= $(shell uname -m)-unknown-linux-gnu
	ERLANG_PLATFORM ?= ${RUST_PLATFORM}
	PLATFORM_SO := so
endif

MACOSX_LDFLAGS = \
				 ${RUST_DIR}/lib/rustlib/${RUST_PLATFORM}/lib/liballoc-4e7c5e5c.rlib \
				 ${RUST_DIR}/lib/rustlib/${RUST_PLATFORM}/lib/libcollections-4e7c5e5c.rlib \
				 ${RUST_DIR}/lib/rustlib/${RUST_PLATFORM}/lib/libcore-4e7c5e5c.rlib \
				 ${RUST_DIR}/lib/rustlib/${RUST_PLATFORM}/lib/libcore-4e7c5e5c.rlib \
				 ${RUST_DIR}/lib/rustlib/${RUST_PLATFORM}/lib/liblibc-4e7c5e5c.rlib \
				 ${RUST_DIR}/lib/rustlib/${RUST_PLATFORM}/lib/librand-4e7c5e5c.rlib \
				 ${RUST_DIR}/lib/rustlib/${RUST_PLATFORM}/lib/libstd-4e7c5e5c.rlib \
				 ${RUST_DIR}/lib/rustlib/${RUST_PLATFORM}/lib/libstd-4e7c5e5c.rlib \
				 ${RUST_DIR}/lib/rustlib/${RUST_PLATFORM}/lib/libunicode-4e7c5e5c.rlib \
				 -flat_namespace -undefined suppress \
				 -L"${RUST_DIR}/lib/rustlib/${RUST_PLATFORM}/lib" \
				 "-Wl,-force_load,${RUST_DIR}/lib/rustlib/${RUST_PLATFORM}/lib/libmorestack.a" \
				 "-Wl,-dead_strip" -dynamiclib -lSystem -lcompiler-rt

ERLNIF_INCLUDES := \
	-I ${ERLANG_SRC_DIR}/erts/emulator/beam \
	-I ${ERLANG_SRC_DIR}/erts/include/${ERLANG_PLATFORM}

native: priv/er.${PLATFORM_SO}

priv/er.${PLATFORM_SO}: rust_src/target/debug/liberrust.${PLATFORM_SO}
	@-mkdir priv >/dev/null 2>&1
	cp $< $@

rust_src/target/debug/liberrust.${PLATFORM_SO}: rust_src/src/c.rs
## This is hacky... basically, building fails due to missing linker flags on MacOSX and doesn't on Linux,
## that's why we behave differently on each platform.
ifeq ($(shell uname), Linux)
	cd rust_src && cargo build >/dev/null 2>&1
	cd rust_src/target/debug && [ ! -f "liber-*.${PLATFORM_SO}" ] && ln -s liber-*.${PLATFORM_SO} liberrust.${PLATFORM_SO}
else
	-cd rust_src && cargo build >/dev/null 2>&1
	cd rust_src/target/debug && cc -m64 -o liberrust.${PLATFORM_SO} er.o deps/liblibc-*.rlib ${LDFLAGS} ${MACOSX_LDFLAGS}
endif

ERL_NIF_H := ${ERLANG_SRC_DIR}/erts/emulator/beam/erl_nif.h

BINDGEN ?= ${HOME}/work/rust-bindgen/target/debug/bindgen -builtins

rust_src/src/c.rs: ${ERL_NIF_H}
	${BINDGEN} ${ERLNIF_INCLUDES} $< -o $@
