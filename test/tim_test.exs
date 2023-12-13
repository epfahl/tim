defmodule TimTest do
  use ExUnit.Case
  require Tim

  test "time sleep, test result and mean" do
    map =
      :timer.sleep(1)
      |> case do
        :ok -> 1
      end
      |> Tim.time(n: 10)

    assert map.result == 1
    assert map.mean < 3_000
  end

  test "inspect sleep, check result" do
    sleeper = fn ->
      :timer.sleep(1)
      "test"
    end

    result =
      sleeper.()
      |> Tim.inspect()

    assert result == "test"
  end

  test "time sleep with unit" do
    map =
      :timer.sleep(1)
      |> case do
        :ok -> 1
      end
      |> Tim.time(n: 10, unit: :millisecond)

    assert map.result == 1
    assert map.mean < 3
  end
end
