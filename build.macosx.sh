#!/usr/bin/env bash

export LD_LIBRARY_PATH=/Library/Developer/CommandLineTools/usr/lib:${LD_LIBRARY_PATH}
make \
    ERLANG_SRC_DIR=/Users/erszcz/.kerl/builds/17.1/otp_src_17.1 \
    ERLANG_PLATFORM=x86_64-apple-darwin13.2.0 \
    BINDGEN="/Users/erszcz/work/rust-bindgen/target/bindgen -builtins"
