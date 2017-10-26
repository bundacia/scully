defmodule SharedTests do
  
  defmacro behaves_like_an_agent(module) do
    quote do
      @module unquote module
      describe "#{@module}" do
        setup do
          {:ok, pid} = @module.start_link(fn -> 0 end)
          %{pid: pid, initial_val: 0}
        end

        test "get applies func to initial value", %{pid: pid, initial_val: initial_val} do
          assert @module.get(pid, &(&1 + 1)) == initial_val + 1
          assert @module.get(pid, &(&1)) == initial_val
        end

        test "get does not change stored value", %{pid: pid, initial_val: initial_val} do
          assert @module.get(pid, &(&1 + 1)) == initial_val + 1
          assert @module.get(pid, &(&1)) == initial_val
        end

        test "get waits timeout ms for a response",  %{pid: pid} do
          reason = catch_exit do
            @module.get(pid, fn _ -> :timer.sleep(20) end, 1)
          end
          assert {:timeout, _} = reason
        end

        test "update waits timeout ms for a response",  %{pid: pid} do
          reason = catch_exit do
            @module.update(pid, fn _ -> :timer.sleep(20) end, 1)
          end
          assert {:timeout, _} = reason
        end

        test "update changes stored value", %{pid: pid, initial_val: initial_val} do
          assert @module.update(pid, &(&1 + 1)) == :ok
          assert @module.get(pid, &(&1)) == initial_val + 1
          assert @module.update(pid, &(&1 + 1)) == :ok
          assert @module.get(pid, &(&1)) == initial_val + 2
        end
      end
    end
  end
end

defmodule ScullyTest do
  use ExUnit.Case
  require SharedTests

  SharedTests.behaves_like_an_agent(Scully)
  SharedTests.behaves_like_an_agent(Agent)

end
