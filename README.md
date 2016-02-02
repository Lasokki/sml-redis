# sml-redis
Redis bindings for Standard ML

## Compilation
I suggest using MLton for compiling.

Easiest way of including the module is by using a ML Basis file like this:

```
$(SML_LIB)/basis/basis.mlb
redis.mlb
your_own_code.sml
```

and compiling with with `mlton whatever.mlb`. Some example files are provided in the repository (`testing.mlb` and `redis-testing.sml`)  