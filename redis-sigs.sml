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
