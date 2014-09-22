#!/usr/bin/env bash

export LD_LIBRARY_PATH=/Library/Developer/CommandLineTools/usr/lib:${LD_LIBRARY_PATH}
make \
    ERLANG_SRC_DIR=/Users/erszcz/.kerl/builds/17.1/otp_src_17.1 \
    ERLANG_PLATFORM=x86_64-apple-darwin13.2.0 \
    PLATFORM_SO=dylib
    BINDGEN="/Users/erszcz/work/rust-bindgen/target/bindgen -builtins" $@

# These are needed for building the rust lib, but how do I make Cargo use them?
#-flat_namespace -undefined suppress  -L/Users/erszcz/apps/erlang/17.1/lib/erl_interface-3.7.17/lib -lerl_interface -lei

# This will compile the Rust-only shared object usable by Erlang.
# I got this from Cargo's output and amended with extra LDFLAGS.
# I still don't know how to pass the extra flags to Cargo.
cc '-m64' '-L' '/usr/local/lib/rustlib/x86_64-apple-darwin/lib' \
    '-o' '/Users/erszcz/work/bitbucket.erszcz/erlang-rust-nifs/rust_src/target/liber-3e50c89bf0cc181f.dylib' \
    '/Users/erszcz/work/bitbucket.erszcz/erlang-rust-nifs/rust_src/target/er-3e50c89bf0cc181f.o' \
    '-Wl,-force_load,/usr/local/lib/rustlib/x86_64-apple-darwin/lib/libmorestack.a' \
    '/Users/erszcz/work/bitbucket.erszcz/erlang-rust-nifs/rust_src/target/er-3e50c89bf0cc181f.metadata.o' \
    '-nodefaultlibs' '-Wl,-dead_strip' '-L' '/usr/local/lib/rustlib/x86_64-apple-darwin/lib' \
    '-lstd-4e7c5e5c' '-L' '/usr/local/lib/rustlib/x86_64-apple-darwin/lib' '-lsync-4e7c5e5c' \
    '-L' '/usr/local/lib/rustlib/x86_64-apple-darwin/lib' '-lrustrt-4e7c5e5c' \
    '-L' '/Users/erszcz/work/bitbucket.erszcz/erlang-rust-nifs/rust_src/target' \
    '-L' '/Users/erszcz/work/bitbucket.erszcz/erlang-rust-nifs/rust_src/target/deps' \
    '-L' '/Users/erszcz/work/bitbucket.erszcz/erlang-rust-nifs/rust_src/.rust' \
    '-L' '/Users/erszcz/work/bitbucket.erszcz/erlang-rust-nifs/rust_src' \
    '-lSystem' '-lpthread' '-lc' '-lm' '-dynamiclib' '-Wl,-dylib' '-lcompiler-rt' \
    '-L/Users/erszcz/apps/erlang/17.1/lib/erl_interface-3.7.17/lib' \
    -lerl_interface -lei -flat_namespace -undefined suppress
