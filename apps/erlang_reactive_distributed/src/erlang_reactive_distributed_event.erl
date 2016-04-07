-module(erlang_reactive_distributed_event).
-behaviour(gen_event).

-export([init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3, terminate/2]).

init(_Args) ->
  {ok, Connection} = mc_worker_api:connect([{database, <<"test">>}]),
  {ok, Connection}.

handle_event(Event, Connection) ->
  lager:info("New Event [~p] ~n", [Event]),
  Collection = events,
  mc_worker_api:insert(Connection, Collection, Event),
  lager:info("Amount ~p~n", [mc_worker_api:count(Connection, Collection , {})]),
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
