%%%-------------------------------------------------------------------
%% @doc internet_monitoring public API
%% @end
%%%-------------------------------------------------------------------

-module(internet_monitoring_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    internet_monitoring_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
