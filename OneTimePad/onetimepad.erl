-module(onetimepad).
-author("pejvan").

-import(string, [to_integer/1]).
-import(file, [write_file/3]).
-import(io, [write/1]).

-export([genKey/1, test/0]).

-spec genKey(KeyLength::integer())  -> GeneratedKey::string().
genKey(KeyLength) when is_integer(KeyLength) ->
  GeneratedInts = [round(random:uniform()) || _ <- lists:seq(1, KeyLength)],
  %GeneratedKey = iolist_to_binary(GeneratedInts),
  GeneratedKey =  << <<X:1>> || X <- GeneratedInts >>,
  io:format("GeneratedKey as bitstring:~n"),
  io:write(GeneratedKey),
  io:format("~n"),
  io:format("GeneratedKey as human readable format: ~p~n", [ GeneratedInts ]),
  io:format("size of Generated key in bytes: ~w and in bits: ~w ~n", [byte_size(GeneratedKey), bit_size(GeneratedKey)] ).


test() ->
  genKey(12).


