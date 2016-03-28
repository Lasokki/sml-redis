structure RedisPipeline : REDISPIPELINE =
struct

datatype command = 
	 Get of string |
	 Set of string * string |
	 Ping |
	 Flushall |
	 Incr of string |
	 DBSize |
	 Exists of string

fun expand c = 
    let
	val crlf = "\r\n"
	val simple_start = "+"
	val bulk_start = "$"
    in
	case c of 
	    Get (key) => RedisUtils.convert_to_resp_array ["Get", key]
	  | Set (key, value) => RedisUtils.convert_to_resp_array ["Set", key, value]
	  | Ping => RedisUtils.convert_to_resp_array ["Ping"]
	  | _ => "FUU"
    end

fun pipeline conn xs = RedisUtils.transfer_through_socket (foldr (op ^) "" (map expand xs)) conn

end
