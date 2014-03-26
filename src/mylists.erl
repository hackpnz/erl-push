-module(mylists).

-export([odd/1]).
-export([even/1]).

iterate([], R, _) ->
    lists:reverse(R);
iterate([_|T], R, 1) ->
    iterate(T, R, 0);
iterate([H|T], R, 0) ->
    iterate(T, [H]++R, 1).

-spec odd(list()) -> list().
odd(L) ->
    iterate(L, [], 0).

-spec even(list()) -> list().
even(L) ->
    iterate(L, [], 1).