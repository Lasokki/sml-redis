structure Redis :> REDIS =
struct

exception RedisError of string

(* Utility functions *)
fun connect_db (host, port) =
    let
	val localhost = valOf(NetHostDB.fromString host)
	val addr = INetSock.toAddr(localhost, port)
	val sock = INetSock.TCP.socket()
	val _ = Socket.connect(sock, addr)
    in
	sock
    end

fun send_command command sock =
    let
	val _ = Socket.sendVec(sock, VectorSlice.full(Byte.stringToBytes (command ^ "\n")))
	val raw_response = Socket.recvVec(sock, 1000)
	val response_string = Byte.bytesToString raw_response
    in
	if String.isPrefix "-" response_string then
	    raise RedisError response_string
	else
	    response_string
    end

(* Redis integer example: ":1451\r\n" *)
fun parse_redis_int s = 
    if String.isPrefix ":" s then
	Int.fromString (substring (s, 1, size s - 2))
    else 
	NONE

(* Redis bulk string example: "$6\r\nfoobar\r\n" *)
fun parse_redis_bulk_string s =
    let
	val ss = Substring.full s
    in
	if String.isPrefix "$" s then
	    SOME (Substring.string (Substring.triml 4 (Substring.trimr 2 ss)))
	else
	    NONE
    end

(* Redis commands *)

fun get sock key = 
    let 
	val response_string = send_command ("GET " ^ key) sock
	val reponse_bulk_as_string = parse_redis_bulk_string response_string
    in
	valOf reponse_bulk_as_string
    end

fun set sock key value = send_command ("SET " ^ key ^ " " ^ value) sock

fun ping sock = send_command "PING" sock

fun flushall sock = send_command "FLUSHALL" sock

fun incr sock key = send_command ("INCR " ^ key) sock

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

