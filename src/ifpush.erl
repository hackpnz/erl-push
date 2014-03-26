-module(ifpush).

-export([run/0]).

-define(BATCH_SIZE, 10).
-define(HOST, "localhost").
-define(PORT, 6379).
-define(DB, 0).
-define(PASS, "").
-define(START_CURSOR, 0).

run() ->
    redis:connect([{ip, ?HOST}, {port, ?PORT}, {db, ?DB}, {pass, ?PASS}]),
    SendPool = spawn(ifpush_worker_pool, loop, []),
    process_tokens(SendPool, ?START_CURSOR).

process_tokens(SendPool, <<"0">>) ->
    SendPool ! stop,
    ok;
process_tokens(SendPool, Cursor) ->
    [{ok, _}|[Data]] = redis:q(["ZSCAN", "if:push:sset:test", Cursor, "COUNT", ?BATCH_SIZE]),

    ProcVal = fun(Val) -> 
        {ok, V} = Val,
        SendPool ! {send, {gcm, V, "msg"}}
    end,
    lists:foreach(ProcVal, mylists:odd(Data)),
    
    NextCursor = <<"0">>,
    process_tokens(SendPool, NextCursor).
