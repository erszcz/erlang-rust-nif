#ifndef ER_H
#define ER_H

#include <erl_nif.h>

extern ERL_NIF_TERM
native_add(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]);

extern ERL_NIF_TERM
native_write_file(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[]);

#endif // ER_H
