structure Redis :> REDIS =
struct

open RedisUtils

fun connect_db (host, port) =
    let
	val localhost = valOf(NetHostDB.fromString host)
	val addr = INetSock.toAddr(localhost, port)
	val sock = INetSock.TCP.socket()
	val _ = Socket.connect(sock, addr)
    in
	sock
    end

(* Redis commands *)

fun get sock key = 
    let 
	val response_string = send_command ("GET " ^ key) sock
	val response_bulk_as_string = parse_redis_bulk_string response_string
    in
	response_bulk_as_string
    end

fun set sock key value = get_simple_string_response sock ("SET " ^ key ^ " " ^ value)

fun ping sock = get_simple_string_response sock "PING"

fun flushall sock = get_simple_string_response sock "FLUSHALL"

fun incr sock key = get_simple_string_response sock ("INCR " ^ key)

fun dbsize sock = 
    let
	val response_string = send_command "DBSIZE" sock
	val response_as_int = parse_redis_int response_string
    in
	if isSome response_as_int then
	    valOf response_as_int
	else
	    (* Maybe an exception should be used here? *)
	    0
    end

fun exists sock key = 
    let
	val response_string = send_command ("EXISTS " ^ key) sock
    in
	if response_string = ":1\r\n" then
	    true
	else
	    false
    end

end

