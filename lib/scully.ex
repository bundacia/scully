defmodule Scully do

  def start_link(fun) do
    pid = spawn_link __MODULE__, :agent, [nil]
    send pid, {:init, fun}
    {:ok, pid}
  end

  def agent(state) do
    receive do
      {:init, fun} -> 
        new_state = fun.()
        agent(new_state)
      {:get, client, fun} ->
        send client, fun.(state)
        agent(state)
      {:update, client, fun} ->
        new_state = fun.(state)
        send client, :ok
        agent(new_state)
    end
  end

  def get(pid, fun, timeout \\ 5000) do
    send pid, {:get, self(), fun}
    receive do
      state -> state
    after 
      timeout -> exit {:timeout, "time out"}
    end
  end

  def update(pid, fun, timeout \\ 5000) do
    send pid, {:update, self(), fun}
    receive do
      :ok -> :ok
    after
      timeout -> exit {:timeout, "time out"}
    end
  end
end
