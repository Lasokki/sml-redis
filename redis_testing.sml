val connection = Redis.connect_db ("127.0.0.1", 6379)

val _ = print ("           ping: " ^ Redis.ping connection)
val _ = print ("       flushall: " ^ Redis.flushall connection)
val _ = print (" initial dbsize: " ^ Int.toString (Redis.dbsize connection) ^ "\n")
val _ = print ("        get foo: " ^ Redis.get "foo" connection)
val _ = print ("     exists foo: " ^ Bool.toString (Redis.exists "foo" connection) ^ "\n")
val _ = print ("set foo value 1: " ^ Redis.set "foo" "value_1" connection)
val _ = print ("     exists foo: " ^ Bool.toString (Redis.exists "foo" connection) ^ "\n") 
val _ = print ("     new dbsize: " ^ Int.toString (Redis.dbsize connection) ^ "\n")
val _ = print ("        get foo: " ^ Redis.get "foo" connection)
val _ = print ("           ping: " ^ Redis.ping connection)
val _ = Socket.close connection
