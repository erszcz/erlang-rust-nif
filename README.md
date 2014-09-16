# Erlang NIF in Rust

This is an example of how to implement a NIF in Rust.
It works for me, might work for you, but don't be mad if it eats your homework.

It's feasible to write real-world code following this example,
as the entire `erl_nif.h` interface is available thanks to [`bindgen`][1].

```
$ ./rebar compile
$ erl -pa ebin
> er:f(123, 2).
125
```

[1]: https://github.com/crabtw/rust-bindgen
