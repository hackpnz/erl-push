-module(ifpush_worker_pool_test).

-include_lib("eunit/include/eunit.hrl").

-define(POOL_SIZE, 3).

pool_test() ->
    Pool = ifpush_worker_pool:hire_workers([], ?POOL_SIZE),
    ?assertMatch(?POOL_SIZE, length(Pool)),
    [_|Pool1] = Pool,
    ?assertMatch(?POOL_SIZE - 1, length(Pool1)),
    Pool2 = ifpush_worker_pool:hire_workers(Pool1, ?POOL_SIZE),
    ?assertMatch(3, length(Pool2)).