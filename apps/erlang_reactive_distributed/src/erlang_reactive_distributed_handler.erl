-module(erlang_reactive_distributed_handler).

-compile({parse_transform, leptus_pt}).

%% leptus callbacks
-export([init/3]).
-export([get/3]).
-export([post/3]).
-export([terminate/4]).

init(_Route, _Req, State) ->
    {ok, State}.

get("/person/", _Req, State) ->
  gen_event:notify({global, event_bus}, {find_user, <<":all">>}),
  {<<"Ok">>, State};
get("/person/:name", Req, State) ->
  Name = leptus_req:param(Req, name),
  gen_event:notify({global, event_bus}, {find_user, Name}),
  {<<"Ok">>, State}.

post("/person/:name", Req, State) ->
  Status = ok,
  Name = leptus_req:param(Req, name),
  gen_event:notify({global, event_bus}, {create_user, Name}),
  {Status, <<"OK">>, State}.

terminate(_Reason, _Route, _Req, _State) ->
    ok.
