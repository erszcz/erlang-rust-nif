-module(er).

-export([f/2,
         test/0]).

%% Native library support
-export([load/0]).
-on_load(load/0).

%%
%% API
%%

test() ->
    io:format("~B~n", [f(123, 456)]).

f(A, B) ->
    native_add(A, B).

native_add(_, _) ->
    throw({?MODULE, nif_not_loaded}).

%%
%% Native library support
%%

-spec load() -> any().
load() ->
    PrivDir = case code:priv_dir(?MODULE) of
                  {error, _} ->
                      EbinDir = filename:dirname(code:which(?MODULE)),
                      AppPath = filename:dirname(EbinDir),
                      filename:join(AppPath, "priv");
                  Path ->
                      Path
              end,
    erlang:load_nif(filename:join(PrivDir, "er"), none).
