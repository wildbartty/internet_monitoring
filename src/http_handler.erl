%%% @author  <wildbartty@cornerstone>
%%% @copyright (C) 2021, 
%%% @doc
%%%
%%% @end
%%% Created : 13 Dec 2021 by  <wildbartty@cornerstone>

-module(http_handler).

-export([init/2]).

init(Req0, State) ->
    Req = cowboy_req:reply(200,
                           #{},
                           prometheus_text_format:format(bort_monitoring),
                           Req0),
    {ok, Req, State}.
    
