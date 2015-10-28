-module(onetimepad).
-author("pejvan").

-import(string, [to_integer/1]).
-import(file, [write_file/3]).
-import(io, [write/1]).

-export([genKey/1, test/0]).

-spec binaryToHex(BinaryData::binary()) -> HexRepresenatioin::string().
binaryToHex(BinaryData) when is_binary(BinaryData)->
  lists:concat([io_lib:format("~2.16.0B",[X]) || <<X:8>> <= BinaryData ]).


-spec genKey(KeyLength::integer())  -> GeneratedKey::string().
genKey(KeyLength) when is_integer(KeyLength) ->
  GeneratedInts = [round(random:uniform()) || _ <- lists:seq(1, KeyLength)],
  GeneratedKey =  << <<X:1>> || X <- GeneratedInts >>,
  %io:format("GeneratedKey as bitstring:~n"),
  %io:write(GeneratedKey),
  io:format("GeneratedKey as Hex string:~n0x~s~n", [binaryToHex(GeneratedKey)]),
  %io:format("GeneratedKey as human readable format:~n~p~n", [ GeneratedInts ]),
  %io:format("size of Generated key in bytes: ~w and in bits: ~w ~n", [byte_size(GeneratedKey), bit_size(GeneratedKey)] )
  io:format("~n"),
  GeneratedKey.

-spec persistData(key, Key::binary()) -> ok | {error, Reason::string()}
           ;     (cypher, EncryptedMessage::string()) -> ok | {error, Reason::string()}.

persistData(key, Key) when is_binary(Key) and is_atom(key) ->
  file:write_file("key.txt", Key).

-spec encryptMessage(MessageAsHex::string(), KeyAsHex::string()) -> EncryptedMessageAsHex::string().
encryptMessage(MessageAsHex, KeyAsHex)  -> %no guards on strings, see http://erlang.org/pipermail/erlang-questions/2003-August/009717.html
  if
    length(MessageAsHex) =:= length(KeyAsHex) ->
      io:format("Message:~s~nKey:~s~n", [MessageAsHex, KeyAsHex]),
      EncryptedMessage = encrypt( MessageAsHex, KeyAsHex, []),
      io:format("Message:~s~nKey:~s~nEncryptedMessage:~s~n", [MessageAsHex, KeyAsHex, EncryptedMessage]);
    true ->
      {error, "Message and Key length not matching"}
  end.

encrypt([A|T], [B|U], Acc) ->
  case T of
    [] ->
      io:format("~s~n", ["T is []"]),
      lists:reverse(Acc);
    _  ->
      io:format("~s~n", ["encrypt(A, [B|U], T, Acc)"]),
      encrypt(A, [B|U], T, Acc)
  end.

encrypt(A, [B|U], T, Acc) ->
  case U of
    [] ->
      io:format("~s~n", ["U is []"]),
      lists:reverse(Acc);
    _  ->
      io:write(A),
      io:write(T),
      io:write(B),
      io:write(U),
      io:write(A bxor B),
      io:format("~n"),
      io:format("~s~n", ["encrypt(T, U, [$A bxor $B | Acc])"]),
      encrypt(T, U, [$A bxor $B | Acc])
  end.

test() ->
  %encrypt("ABC", "XYZ", []),
  GeneratedKey = genKey(12*8),
  persistData(key, list_to_binary([binaryToHex(GeneratedKey)] ++ ["\n"])),
  %encryptMessage("Hello World!", binaryToHex(GeneratedKey)).
  Res = encryptMessage("Hello World!", "012345678901"),
  Res2 = encryptMessage(Res, "01234567890").
