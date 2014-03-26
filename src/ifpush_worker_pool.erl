-module(ifpush_worker_pool).
-export([loop/0, hire_workers/2]).

-define(POOL_SIZE, 100).

loop() ->
    loop([], 1).

-spec loop(list(), integer()) -> none().
loop(Workers, WorkerIndex) when length(Workers) =:= 0 ->
    loop(hire_workers(Workers, ?POOL_SIZE), WorkerIndex);
loop(Workers, WorkerIndex) when WorkerIndex > length(Workers) ->
    loop(Workers, 1);
loop(Workers, WorkerIndex) ->
    receive
        {send, Params} ->
            Worker = lists:nth(WorkerIndex, Workers),
            Worker ! {self(), Params},
            loop(Workers, WorkerIndex+1);
        {'DOWN', _Ref, process, Pid, _Why} ->
            loop(hire_workers(Workers--Pid, ?POOL_SIZE), WorkerIndex);
        stop ->
           lists:foreach(fun(Pid) -> Pid ! stop end, Workers),
           io:format("Stopping workers pool~n"),
           exit(normal)
    end.


-spec hire_workers(list(), integer()) -> list().
hire_workers(Workers, Size) when length(Workers) < Size ->
    NewWorker = spawn(ifpush_sender, start, []),
    erlang:monitor(process, NewWorker),
    hire_workers([NewWorker|Workers], Size);
hire_workers(Workers, Size) when length(Workers) >= Size ->
    Workers.
