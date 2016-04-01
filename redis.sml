structure Redis : REDIS =
struct

exception RedisError of string

datatype command = 
	 Get of string |
	 Set of string * string |
	 Ping |
	 Flushall |
	 Incr of string |
	 DBSize |
	 Exists of string

fun connect_db (host, port) =
    let
	val localhost = valOf(NetHostDB.fromString host)
	val addr = INetSock.toAddr(localhost, port)
	val sock = INetSock.TCP.socket()
	val _ = Socket.connect(sock, addr)
    in
	sock
    end

fun expand c = 
    case c of 
	Get (key) => RedisUtils.convert_to_resp_array ["Get", key]
      | Set (key, value) => RedisUtils.convert_to_resp_array ["Set", key, value]
      | Ping => RedisUtils.convert_to_resp_array ["Ping"]
      | _ => "FUU"


fun pipeline conn xs = RedisUtils.send_command (foldr (op ^) "" (map expand xs)) conn

end
