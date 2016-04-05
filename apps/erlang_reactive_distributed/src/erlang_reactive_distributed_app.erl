%%%-------------------------------------------------------------------
%% @doc erlang_reactive_distributed public API
%% @end
%%%-------------------------------------------------------------------

-module(erlang_reactive_distributed_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->

  Port = case os:getenv("PORT") of
      false -> {ok, ApplicationPort} = application:get_env(http_port), ApplicationPort;
      Value  -> Value
  end,

  {ok, ListenerCount} = application:get_env(http_listener_count),

  Dispatch = cowboy_router:compile([{'_', [
    {"/", erlang_reactive_distributed_handler, []}
  ]}]),

  lager:info("Starting application on port: ~p", [Port]),
  cowboy:start_http(http, ListenerCount, [{port, Port}],
      [{env, [{dispatch, Dispatch}]}]
  ),

  erlang_reactive_distributed_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
