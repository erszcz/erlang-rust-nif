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

static mut funcs: [c::ErlNifFunc, ..1] = [
    c::ErlNifFunc{ name: 0 as *const c_char,
                   arity: 2,
                   fptr: Some(native_add) }
];

static mut nif_entry: c::ErlNifEntry = c::ErlNifEntry{
    major           : 2,
    minor           : 6,
    name            : 0 as *const c_char,
    num_of_funcs    : 0,
    funcs           : 0 as *mut c::ErlNifFunc,
    load            : None,
    reload          : None,
    upgrade         : None,
    unload          : None,
    vm_variant      : 0 as *const c_char
};

#[no_mangle]
pub extern "C" fn nif_init() -> *mut c::ErlNifEntry
{
    unsafe {
        funcs[0].name = "native_add".to_c_str().unwrap();
        nif_entry.name = "er".to_c_str().unwrap();
        nif_entry.num_of_funcs = funcs.len() as i32;
        nif_entry.funcs = funcs.as_mut_ptr();
        nif_entry.vm_variant = "beam.vanilla".to_c_str().unwrap();
        &mut nif_entry
    }
}
