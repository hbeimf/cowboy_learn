-module(ws_handler).
-behaviour(cowboy_websocket_handler).

-export([init/3]).
-export([websocket_init/3]).
-export([websocket_handle/3]).
-export([websocket_info/3]).
-export([websocket_terminate/3]).

-spec init(_, _, _) -> ok|{upgrade, protocol, cowboy_websocket}.
init({tcp, http}, _Req, _Opts) ->
	{upgrade, protocol, cowboy_websocket}.

-spec websocket_init(_, _, _) -> ok.
websocket_init(_TransportName, Req, _Opts) ->
	erlang:start_timer(1000, self(), <<"Hello!">>),
	{ok, Req, undefined_state}.

-spec websocket_handle(_, _, _) -> ok.
websocket_handle({text, Msg}, Req, State) ->
	{reply, {text, << "That's what she said! ", Msg/binary >>}, Req, State};
websocket_handle(_Data, Req, State) ->
	{ok, Req, State}.

-spec websocket_info(_, _, _) -> ok.
websocket_info({timeout, _Ref, Msg}, Req, State) ->
	erlang:start_timer(1000, self(), <<"How' you doin'?">>),
	{reply, {text, Msg}, Req, State};
websocket_info(_Info, Req, State) ->
	{ok, Req, State}.

-spec websocket_terminate(_, _, _) -> ok.
websocket_terminate(_Reason, _Req, _State) ->
	ok.
