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
      Value  -> {ApplicationPort, _} = string:to_integer(Value), ApplicationPort
  end,

  gen_event:start_link({global, event_bus}),
  gen_event:add_handler({global, event_bus}, erlang_reactive_distributed_event, []),
  leptus:start_listener(http, [{'_', [{erlang_reactive_distributed_handler, undef}]}], [{port, Port}]),
  {ok, Connection} = mc_worker:start_link({}),
  lager:info("Connected ~p~n", [Connection]),
  erlang_reactive_distributed_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
