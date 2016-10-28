-module(erlang_reactive_distributed_event).
-behaviour(gen_event).

-export([init/1, handle_event/2, handle_call/2, handle_info/2, code_change/3, terminate/2]).

init(RiakPid) ->
  {ok, RiakPid}.

handle_event(Event, RiakPid) ->
  Object = riakc_obj:new(<<"index">>, <<"metadata">>, <<"data">>),
  riakc_pb_socket:put(RiakPid, Object),
  {ok, RiakPid}.

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
