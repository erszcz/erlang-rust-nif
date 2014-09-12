#ifndef ER_H
#define ER_H

#include <erl_nif.h>
#include <stdio.h>
#include <stdlib.h>

ERL_NIF_TERM native_add(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]);
ERL_NIF_TERM native_write_file(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]);

ERL_NIF_TERM OK;

#endif // ER_H
