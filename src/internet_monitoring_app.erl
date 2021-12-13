%%%-------------------------------------------------------------------
%% @doc internet_monitoring public API
%% @end
%%%-------------------------------------------------------------------

-module(internet_monitoring_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    prometheus_registry:register_collector(bort_monitoring, testing_prom),
    Dispatch = cowboy_router:compile([
                                      {'_', [{"/", http_handler, []}]}
                                      ]),
    {ok, _} = cowboy:start_clear(bort_listener, [{port, 2200}], #{env => #{ dispatch =>
                                                                            Dispatch}}),
    
    internet_monitoring_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
