%%%-------------------------------------------------------------------
%% @doc erlang_reactive_distributed top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(erlang_reactive_distributed_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_listeners/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_listeners() ->
  {ok, Port} = application:get_env(http_port),
  {ok, ListenerCount} = application:get_env(http_listener_count),

  Dispatch =
    cowboy_router:compile(
      [ {'_',
          [
            {<<"/news">>, erlang_reactive_distributed_handler, []}
          ]
        }
      ]),

  RanchOptions =
    [ {port, Port}
    ],
  CowboyOptions =
    [ {env,       [{dispatch, Dispatch}]}
    , {compress,  true}
    , {timeout,   12000}
    ],

  cowboy:start_http(erlang_reactive_distributed_http, ListenerCount, RanchOptions, CowboyOptions).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
    {ok, { {one_for_one, 5, 10}, [{erlang_reactive_distributed_http,
        {erlang_reactive_distributed_sup, start_listeners, []},
        permanent, 1000, worker, [erlang_reactive_distributed_sup]}
    ]}}.

%%====================================================================
%% Internal functions
%%====================================================================
