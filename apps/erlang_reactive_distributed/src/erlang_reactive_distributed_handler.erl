-module(erlang_reactive_distributed_handler).

-export([
  init/3,
  allowed_methods/2,
  content_types_accepted/2,
  resource_exists/2,
  terminate/3
]).

-export([
  handle_post/2,
  handle_get/1
]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COWBOY CALLBACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
init(_Transport, Req, _Opts) ->
  case cowboy_req:method(Req) of
    {<<"POST">>, _} ->
      {upgrade, protocol, cowboy_rest};
    {<<"GET">>, Req1} ->
      handle_get(Req1)
  end.

allowed_methods(Req, State) -> {[<<"POST">>], Req, State}.

content_types_accepted(Req, State) -> {[{<<"application/json">>, handle_post}], Req, State}.

resource_exists(Req, State) -> {false, Req, State}.

terminate(_Reason, _Req, _State) -> ok.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INTERNAL CALLBACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handle_post(Req, State) ->
  {ok, _Body, Req1} = cowboy_req:body(Req),
  {true, Req1, State}.

handle_get(Req) ->
  {ok, Req1} = cowboy_req:chunked_reply(200, [{"content-type", <<"text/event-stream">>}], Req),
  {loop, Req1, {}}.
