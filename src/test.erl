-module(test).

-export([start/0]).

-spec start() -> ok.
start() ->
	application:start(crypto),
	application:start(asn1),
	application:start(public_key),
	application:start(ssl),

	application:start(ranch),
	application:start(cowlib),
	application:start(cowboy),

	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", test_handler, []}
		]}
	]),
	{ok, _} = cowboy:start_http(http, 5, [{port, 9991}], [
		{env, [{dispatch, Dispatch}]}
	]),
	
	io:format("run...  http://localhost:9991/?echo=hello~n"),
	ok.
