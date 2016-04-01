signature REDIS =
sig
    exception RedisError of string
    type command
    val connect_db : string * int -> (INetSock.inet, (Socket.active Socket.stream)) Socket.sock
    val Ping : command
    val pipeline : (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> command list -> string
end

signature REDISUTILS = 
sig
    exception RedisError of string
    val send_command : string -> (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> string
    val transfer_through_socket : string -> (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> string
    val remove_prefix_and_end_crlf : string -> string
    val parse_redis_int : string -> int option
    val parse_simple_string : string -> string
    val parse_redis_bulk_string : string -> string option
    val convert_to_resp_array : string list -> string
end
