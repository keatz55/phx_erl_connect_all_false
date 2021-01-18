I've created this repo to add further context and validation to the issue:
https://github.com/phoenixframework/phoenix/issues/4157

### Expected behavior

If `--erl "-connect_all false"` is configured on start, distributed erlang node connections should be non-transitive. I.e., If a node A connects to node B, and node B has a connection to node C, then node A should not try to connect to node C.

In order to replicate, I've created 3 freshly generated phoenix apps where the following commands can be run exactly. There is no libcluster or anything, only `Node.connect/1` after an iex session has started.

```shell
# Terminal 1
make compose.up # Starts apps 1-3 with `iex --erl "-connect_all false" --sname app{1-3}@app{1-3} --cookie monster -S mix phx.server`
make app1.iex # attaches to running app1 iex session

# Terminal 2
make app2.iex # attaches to running app2 iex session
iex(app2@app2)1> Node.connect(:app1@app1)
true
iex(app2@app2)2> Node.list()
[:app1@app1]

# Terminal 3
make app3.iex # attaches to running app3 iex session
iex(app3@app3)1> Node.connect(:app2@app2)
true
iex(app3@app3)2> Node.list()
[:app2@app2] # <- HERE - should return non-transitive result
```

### Actual behavior

```shell
# Terminal 1
make compose.up # Starts apps 1-3 with `iex --erl "-connect_all false" --sname app{1-3}@app{1-3} --cookie monster -S mix phx.server`
make app1.iex # attaches to running app1 iex session
iex(app1@app1)1>

# Terminal 2
make app2.iex # attaches to running app2 iex session
iex(app2@app2)1> Node.connect(:app1@app1)
true
iex(app2@app2)2> Node.list()
[:app1@app1]

# Terminal 3
make app3.iex # attaches to running app3 iex session
iex(app3@app3)1> Node.connect(:app2@app2)
true
iex(app3@app3)2> Node.list()
[:app2@app2, :app1@app1] # <- HERE - returns transitive result, expected only [:app2@app2]
```

Also worth noting that distributed erlang node connections work as expected without `-S mix phx.server`:

```shell
# terminal 1
iex --erl "-connect_all false" --sname app1@localhost --cookie monster

# terminal 2
iex --erl "-connect_all false" --sname app2@localhost --cookie monster
iex(app2@localhost)1> Node.connect(:app1@localhost)
true
iex(app2@localhost)2> Node.list()
[:app1@localhost]

# terminal 3
iex --erl "-connect_all false" --sname app3@localhost --cookie monster
iex(app3@localhost)1> Node.connect(:app2@localhost)
true
iex(app3@localhost)2> Node.list()
[:app2@localhost] # <- HERE - returns non-transitive result
```

For reference, here is the official Erlang documentation on `-connect_all false`:
http://erlang.org/doc/reference_manual/distributed.html#node-connections
