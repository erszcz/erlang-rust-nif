extern crate libc;
use libc::c_char;
use libc::c_int;
use std::mem;
mod c;

#[no_mangle]
pub extern "C" fn native_add(env: *mut c::ErlNifEnv,
                             argc: c_int,
                             args: *const c::ERL_NIF_TERM) -> c::ERL_NIF_TERM
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

static funcs: [c::ErlNifFunc, ..1] = [
    c::ErlNifFunc{name: b"native_add\0".as_ptr() as *const c_char,
                  arity: 2, fptr: Some(native_add)}
];

// this won't work due to
// error: constant contains unimplemented expression type [E0019]
static name: *const c_char = b"er\0".as_ptr() as *const c_char;
static vm_variant: *const c_char = b"beam.vanilla\0".as_ptr() as *const c_char;

// arrrr1 on irc said:
//
// erszcz: according to the ld docs, if you name a function _init,
// it will be run when the library is loaded.
// so you could wouldn't even have to manually call the linker.
// not sure if the stdlib already defines such a function

// so the available options are _init which would initialize the statics
// properly OR just writing the relevant export signature
// (i.e. ErlNifEntry) in plain C

static nif_entry: c::ErlNifEntry = c::ErlNifEntry{
    major: 2,
    minor: 6,
    name: name,
    num_of_funcs: 1,
    funcs: funcs.as_mut_ptr(),
    load: None,
    reload: None,
    upgrade: None,
    unload: None,
    vm_variant: vm_variant
};

#[no_mangle]
pub extern "C" fn nif_init() -> *mut c::ErlNifEntry { &mut nif_entry }
