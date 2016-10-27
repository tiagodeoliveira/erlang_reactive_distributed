-module(erlang_reactive_distributed_event).
-behaviour(gen_event).

-export([init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3, terminate/2]).

init(_Args) ->
  {ok, RiakAddress} = application:get_env(riak_address),
  {ok, Pid} = riakc_pb_socket:start_link(RiakAddress, 8087),
  riakc_pb_socket:ping(Pid),
  {ok, Pid}.

handle_event(Event, Connection) ->
  lager:info("New Event [~p] ~n", [Event]),

  Event = riakc_obj:new(Event),
  riakc_pb_socket:put(Connection, Event).

  {ok, Connection}.

handle_call(Call, State) ->
  lager:info("Handling call [~p] ~n", [Call]),
  {ok, ok, State}.

handle_info(Info, State) ->
  lager:info("Handling info [~p] ~n", [Info]),
  {ok, State}.

code_change(OldVsn, State, _Extra) ->
  lager:info("Code changed [~p] ~n", [OldVsn]),
  {ok, State}.

terminate(_Args, _State) ->
    ok.
