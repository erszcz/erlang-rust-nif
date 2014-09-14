ERLNIF_INCLUDES := \
	-I /home/erszcz/.kerl/builds/17.0/otp_src_17.0/erts/emulator/beam \
	-I /home/erszcz/.kerl/builds/17.0/otp_src_17.0/erts/include/x86_64-unknown-linux-gnu

## Just for now. Lame but works...
priv/er.so: c_src/er.o rust_src/target/liberrust.so
	-mkdir priv
	${CC} -fPIC -shared -L rust_src/target/ $< -o $@ -l errust
	
c_src/er.o: c_src/er.c
	${CC} ${ERLNIF_INCLUDES} -fPIC -c -o $@ $<

rust_src/target/liberrust.so: rust_src/src/c.rs
	cd rust_src && cargo build && cp target/liber-*.so target/liberrust.so

ERL_NIF_H := /home/erszcz/.kerl/builds/17.0/otp_src_17.0/erts/emulator/beam/erl_nif.h

BINDGEN := bindgen

rust_src/src/c.rs:
	${BINDGEN} ${ERLNIF_INCLUDES} ${ERL_NIF_H} -o $@
