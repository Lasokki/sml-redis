structure Redis :> REDIS =
struct

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
	val server_response = Socket.recvVec(sock, 1000)
    in
	Byte.bytesToString server_response
    end

(* Redis commands *)

fun get key sock = send_command ("GET " ^ key) sock

fun set key value sock= send_command ("SET " ^ key ^ " " ^ value) sock

fun ping sock = send_command "PING" sock

fun incr key sock = send_command ("INCR " ^ key) sock

fun dbsize sock= 
    let
	val response_string = send_command "DBSIZE" sock
	val response_as_int = Int.fromString(response_string)
    in
	if isSome response_as_int then
	    valOf response_as_int
	else
	    (* Maybe an exception should be used here? *)
	    0
    end

fun exists key sock = 
    let
	val response_string = send_command ("EXISTS " ^ key) sock
    in
	if response_string = "0" then
	    true
	else
	    false
    end

end
