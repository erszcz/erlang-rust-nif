#include "er.h"

ErlNifFunc funcs[] =
{
    {"native_add", 2, native_add}
};

ERL_NIF_INIT(er, funcs, NULL, NULL, NULL, NULL);
