signature REDIS =
sig
    exception RedisError of string
    val connect_db : string * int -> (INetSock.inet, (Socket.active Socket.stream)) Socket.sock
    val get : (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> string -> string option
    val set : (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> string -> string -> string
    val ping : (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> string
    val flushall : (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> string
    val incr : (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> string -> string
    val dbsize : (INetSock.inet, (Socket.active Socket.stream)) Socket.sock-> int
    val exists : (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> string -> bool
end

signature REDISUTILS = 
sig
    exception RedisError of string
    val send_command : string -> (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> string
    val remove_prefix_and_end_crlf : string -> string
    val parse_redis_int : string -> int option
    val parse_simple_string : string -> string
    val parse_redis_bulk_string : string -> string option
    val get_simple_string_response : (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> string -> string
end
