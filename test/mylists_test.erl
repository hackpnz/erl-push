-module(mylists_test).

-include_lib("eunit/include/eunit.hrl").

empty_test() ->
    ?assertMatch([], mylists:even([])),
    ?assertMatch([], mylists:odd([])).

even_test() ->
    L = [1,2,3,4,5],
    ?assertMatch([2,4], mylists:even(L)).

odd_test() ->
    L = [1,2,3,4,5],
    ?assertMatch([1,3,5], mylists:odd(L)).