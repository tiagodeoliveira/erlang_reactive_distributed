-module(erlang_reactive_distributed_handler).

-behaviour(cowboy_http_handler).

-export([init/3]).
-export([handle/2]).
-export([terminate/3]).

-record(state, {}).

init(_, Req, _Opts) ->
	{ok, Req, #state{}}.

handle(Req, State=#state{}) ->
	case cowboy_req:method(Req) of
		{<<"POST">>, Req1} ->
      handle_post(Req1, State);
    {<<"GET">>, Req1} ->
      handle_get(Req1, State)
	end.

terminate(_Reason, _Req, _State) ->
	ok.

handle_get(Req, State) ->
	{ok, Req2} = cowboy_req:reply(200,[{<<"content-type">>, <<"text/plain">>}], <<"GET">>, Req),
	{ok, Req2, State}.

handle_post(Req, State) ->
	% lager:info("GET: ", []),
	{ok, Req2} = cowboy_req:reply(200,[{<<"content-type">>, <<"text/plain">>}], <<"POST">>, Req),
	{ok, Req2, State}.
