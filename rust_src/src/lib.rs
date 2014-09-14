extern crate libc;
use libc::c_int;
use std::mem;
mod c;

#[no_mangle]
pub extern fn native_add(env: *mut c::ErlNifEnv,
                         argc: c_int,
                         args: *mut c::ERL_NIF_TERM) -> c::ERL_NIF_TERM
{
    if argc != 2
        { unsafe { return c::enif_make_badarg(env); } }
    let mut a: c_int = 0;
    let mut b: c_int = 0;
    unsafe {
        if c::enif_get_int(env, *args.offset(0), &mut a) == 0
            { return c::enif_make_badarg(env); }
        if c::enif_get_int(env, *args.offset(1), &mut b) == 0
            { return c::enif_make_badarg(env); }
        c::enif_make_int(env, a + b)
    }
}
