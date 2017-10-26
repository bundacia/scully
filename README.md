# Scully

In order to better understand Elixir's `Agent` I have tried to reimplement some of it's functionality just using `send` and `receive`.

![Agent Scully](https://raw.githubusercontent.com/bundacia/scully/master/scully.png)


```elixir
iex(1)> {:ok, pid} = Scully.start_link(fn -> 42 end)
{:ok, #PID<0.151.0>}
iex(2)> Scully.get(pid, fn i -> i + 1 end)
43
iex(3)> Scully.update(pid, fn i -> i + 1 end)
:ok
iex(4)> Scully.get(pid, fn i -> i end)
43
iex(5)> Scully.get(pid, fn i -> :timer.sleep(100) end, 20)
** (exit) {:timeout, "time out"}
    (scully) lib/scully.ex:29: Scully.get/3
iex(5)> {:ok, pid} = Agent.start_link(fn -> 42 end)
{:ok, #PID<0.157.0>}
iex(6)> Agent.update(pid, fn i -> i + 1 end)
:ok
iex(7)> Agent.get(pid, fn i -> i end)
43
iex(8)> Agent.get(pid, fn i -> :timer.sleep(100) end, 20)
** (exit) exited in: GenServer.call(#PID<0.157.0>, {:get, #Function<6.99386804/1 in :erl_eval.expr/5>}, 20)
    ** (EXIT) time out
    (elixir) lib/gen_server.ex:774: GenServer.call/3
```

## Features

* `start_link(fun)`
* `get(pid, fun)`
* `get(pid, fun, timeout)`
* `update(pid, fun)`
* `update(pid, fun, timeout)`

## Tests

`mix test` will run the tests against this library as well as Agent (to keep us honest).
