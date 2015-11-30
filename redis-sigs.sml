signature REDIS =
sig
    val connect_db : string * int -> (INetSock.inet, (Socket.active Socket.stream)) Socket.sock
    val get : string -> (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> string
    val set : string -> string -> (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> string
    val ping : (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> string
    val incr : string -> (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> string
    val dbsize : (INetSock.inet, (Socket.active Socket.stream)) Socket.sock-> int
    val exists : string -> (INetSock.inet, (Socket.active Socket.stream)) Socket.sock -> bool

end
