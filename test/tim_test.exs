defmodule TimTest do
  use ExUnit.Case
  doctest Tim

  test "sleep, test result and mean" do
    map =
      :timer.sleep(1)
      |> case do
        :ok -> 1
      end
      |> Tim.time(10)

    assert map.result == 1
    assert map.mean <= 3_000
  end
end
