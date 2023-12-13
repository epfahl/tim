defmodule StatsTest do
  use ExUnit.Case
  doctest Tim.Stats

  test "collect stats nonempty" do
    c = Tim.Stats.collect([1, 2, 3], 1)

    assert c == %{mean: 2.0, median: 2, min: 1, max: 3}
  end

  test "collect stats empty exception" do
    assert_raise(Enum.EmptyError, fn -> Tim.Stats.collect([], 1) end)
  end
end
