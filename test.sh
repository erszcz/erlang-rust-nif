#!/bin/bash

EXPECTED=579
ACTUAL=$(erl -noinput -noshell -pa ebin/ priv/ -s er test -s init stop)

[ x"$EXPECTED" = x"$ACTUAL" ] \
    && echo "Test OK - the Rust NIF works" \
    || echo "Test failed - try building the dynamically loaded library manually"
