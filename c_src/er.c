#include <stdio.h>
#include <stdlib.h>

#include "er.h"

ERL_NIF_TERM
native_add(ErlNifEnv *env, int argc, const ERL_NIF_TERM argv[])
{
    int a, b;
    if (!enif_get_int(env, argv[0], &a))
        return enif_make_badarg(env);
    if (!enif_get_int(env, argv[1], &b))
        return enif_make_badarg(env);
    return enif_make_int(env, a + b);
}

int
load(ErlNifEnv* env, void **priv, ERL_NIF_TERM info)
{
    OK = enif_make_atom(env, "ok");
    return 0;
}

ErlNifFunc funcs[] =
{
    {"native_add", 2, native_add}
};

ERL_NIF_INIT(er, funcs, &load, NULL, NULL, NULL);
