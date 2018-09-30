-module(test).

-export([start/0]).

-spec start() -> ok.
start() ->
	% 先启动 ranch 依赖的app
	application:start(crypto),
	application:start(asn1),
	application:start(public_key),
	application:start(ssl),

	% start cowboy app 依赖
	application:start(ranch),
	application:start(cowlib),

	% 启动 cowboy ,  cowboy_app, cowboy_sup, cowboy_clock, 
	% 启动了一个gen_server 进程 ， 维护时间相关的业务 ， 每次请求回复的时间 逻辑 就在这里，
	% 其实就是启动一个计时器，每秒更新一次， 有兴趣可以打开看看
	application:start(cowboy),

	%% 路由配置， 中间件啥 的都在这里配置，
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", test_handler, []}
		]}
	]),

	%% 这里才是真正启动 http 的入口， 是cowboy app代码跟踪的入口
	{ok, _} = cowboy:start_http(http, 5, [{port, 9991}], [
		{env, [{dispatch, Dispatch}]}
	]),
	
	io:format("run...  http://localhost:9991/?echo=hello~n"),
	ok.
