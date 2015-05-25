# Erlang NIF in Rust

This is an example of how to implement a NIF in Rust.
It works for me, might work for you, but don't be mad if it eats your homework.

While it would be feasible to write real-world code following this example,
as the entire `erl_nif.h` interface is available thanks to [`bindgen`][bindgen],
it would still require a lot of yak shaving.
You'll be much better off using Daniel Goertzen's [`ruster_unsafe`][ruster_unsafe].
It's a Rust crate that takes the idea of this example a lot further
and delivers ready to use bindings.
Don't miss [`ruster_unsafe demo`][ruster_demo].

## Running the code

Adjust the following options in `Makefile` to match your environment:

```
ERLANG_SRC_DIR ?= ${HOME}/.kerl/builds/17.1/otp_src_17.1
ERLANG_EI_LIB_DIR ?= ${HOME}/apps/erlang/17.1/lib/erl_interface-3.7.17/lib
RUST_DIR ?= ${HOME}/apps/rust/1.0.0
```

Then run:

```
make test
```

If you got

```
Test OK - the Rust NIF works
```

as the last output line then everything worked fine - you have the example
dynamically loaded library in `priv/`.
Otherwise, you might've received

```
Test failed - try building the dynamically loaded library manually
```

in which case the real fun begins - please inspect the `Makefile` and file
an issue on what went wrong (did I mention that PRs are also welcome?).

## ?!

This is an example project for
[a short presentation about using Rust NIFs from within Erlang][rust-teaser].

[bindgen]: https://github.com/crabtw/rust-bindgen
[rust-teaser]: https://github.com/lavrin/erlang-and-rust-teaser
[ruster_unsafe]: https://github.com/goertzenator/ruster_unsafe
[ruster_demo]: https://github.com/goertzenator/ruster_unsafe_demo
