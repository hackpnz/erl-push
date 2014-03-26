-module(ifpush_sender).
-export([start/0]).

start() ->
    inets:start(),
    loop().
    
loop() ->
    receive
        {From, {gcm, Token, Message}} ->
            send_gcm(Token, Message),
            From ! {ok, gcm, Token},
            loop();
        {From, {apns, Token, Message}} ->
            send_apns(Token, Message),
            From ! {ok, apns, Token},
            loop();
        stop ->
            exit(normal)
    end.

-spec send_gcm(string(), string()) -> atom().
send_gcm(Token, Message) ->
    {ok, _} = httpc:request(get, {"http://ya.ru", []}, [], [{sync, false}]),
    io:format(Message ++ " sent to GCM " ++ binary_to_list(Token) ++ "~n").

-spec send_apns(string(), string()) -> atom().
send_apns(Token, Message) ->
    {ok, _} = httpc:request(get, {"http://ya.ru", []}, [], [{sync, false}]),
    io:format(Message ++ " sent to APNS " ++ binary_to_list(Token) ++ "~n").