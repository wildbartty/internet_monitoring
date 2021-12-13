%% @doc
%%
%% 1> c('examples/simple_collector').
%% {ok,simple_collector}
%% 2> prometheus_registry:register_collector(qwe, simple_collector).
%% ok
%% 3> io:format("~s", [prometheus_text_format:format(qwe)]).
%% # TYPE pool_size untyped
%% # HELP pool_size MongoDB Connections pool size
%% pool_size 365
%%
%% ok
%% @end

-module(testing_prom).

-behaviour(prometheus_collector).

-export([deregister_cleanup/1,
         collect_mf/2,
        collect_metrics/2]).

-import(prometheus_model_helpers, [create_mf/4]).

%% ===================================================================
%% API
%% ===================================================================

%% called to collect Metric Families
collect_mf(_Registry, Callback) ->
    
    Callback(create_gauge(ping,
                       "Ping to 1.1.1.1", {cloudflare, "1.1.1.1"})),
    Callback(create_gauge(ping,
                       "Ping to 1.1.1.1", {router, "10.0.0.138"})),
    Callback(create_gauge(ping,
                       "Ping to 8.8.8.8", {router, "8.8.8.8"})),
    ok.

collect_metrics(ping, {Kind, Target}) ->
    Cmd_string = io_lib:format("ping ~s -c 1 | grep -E -o 'time=[0-9]+' | grep -E -o '[0-9]+'", [Target]),
    Cmd = os:cmd(Cmd_string),
    io:format("~s", [Cmd]),
    if Cmd =:= [] ->
            Ret = -1;
       true -> {Ret, _} = string:to_integer(Cmd)
    end,
    prometheus_model_helpers:gauge_metrics(
      [ {[{kind, Kind}], Ret} ] ).
%% called when collector deregistered
deregister_cleanup(_Registry) -> ok.

%% ===================================================================
%% Private functions
%% ===================================================================
create_gauge(Name, Help, Data) ->
    prometheus_model_helpers:create_mf(Name, Help, gauge, ?MODULE, Data).

