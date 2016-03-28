structure RedisUtils : REDISUTILS =
struct

exception RedisError of string

fun transfer_through_socket command sock =
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

fun convert_string_to_bulk_string s =
    let
	val string_start = "$"
	val crlf = "\r\n"
	val string_length = Int.toString (String.size s)
	val bulk_string = string_start ^ string_length ^ crlf ^ s ^ crlf
    in
	bulk_string
    end

fun convert_to_resp_array xs =
    let
	val array_start = "*"
	val crlf = "\r\n"

	val list_length = Int.toString (length xs)
	val converted_commands = map convert_string_to_bulk_string xs
	val commands_as_bulk = foldr (op ^) "" converted_commands
					
	val command_array = array_start ^ list_length ^ crlf ^ commands_as_bulk ^ crlf
    in
	command_array
    end
	

fun send_command command sock =
    let
	val command_as_resp_array = convert_to_resp_array command
    in
	transfer_through_socket command_as_resp_array sock
    end

fun remove_prefix_and_end_crlf s = substring (s, 1, size s - 2)

(* Redis integer example: ":1451\r\n" *)
fun parse_redis_int s = 
    if String.isPrefix ":" s then
	Int.fromString (remove_prefix_and_end_crlf s)
    else 
	NONE

fun parse_simple_string s = remove_prefix_and_end_crlf s

(* Redis bulk string example: "$6\r\nfoobar\r\n" *)
fun parse_redis_bulk_string s =
    let
	fun extract_string x = Substring.string (Substring.triml 4 (Substring.trimr 2 (Substring.full x)))
	
	val ss = Substring.full s
	val splitted_by_carriage = Substring.splitl (fn a => if a = #"\015" then false else true) ss
	val trimmed_string = Substring.string(Substring.triml 1 (#1 splitted_by_carriage))
	val bulk_length = valOf (Int.fromString(trimmed_string))
	val is_not_null_bulk_string = if bulk_length >= 0 then true else false

    in
	if String.isPrefix "$" s andalso is_not_null_bulk_string then
	    SOME (extract_string s)
	else
	    NONE
    end

fun get_simple_string_response sock command = 
    let 
	val response_string = send_command command sock
	val simple_string_as_string = parse_simple_string response_string
    in
	simple_string_as_string
    end

end
