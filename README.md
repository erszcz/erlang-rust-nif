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

## On Linux

```
$ ./rebar compile
$ erl -pa ebin
> er:f(123, 2).
125
```

## On MacOS X

```
$ ./build.macosx.sh
```

It will spew some warnings and an `ld` failure, but the script takes care
of relinking the intermediate object properly and placing it in `priv/`
for Erlang to use.

## ?!

This is an example project for
[a short presentation about using Rust NIFs from within Erlang][rust-teaser].

[bindgen]: https://github.com/crabtw/rust-bindgen
[rust-teaser]: https://github.com/lavrin/erlang-and-rust-teaser
[ruster_unsafe]: https://github.com/goertzenator/ruster_unsafe
[ruster_demo]: https://github.com/goertzenator/ruster_unsafe_demo
