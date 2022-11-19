defmodule Tim do
  @moduledoc """
  `Tim` provides the macro `time` that takes any valid Elixir expression and returns a map
  containing several statistics for the expression's execution time, the result of the
  evaluated expression, and the expression's string representation. To use
  `time`, require or import `Tim` into your environment and pipe in the expression:

  ```elixir
  require Tim

  1..10
  |> Enum.map(& &1 * 2/((1 + 10) * 10))
  |> Enum.sum()
  |> Tim.time()
  ```

  This returns (actual timing numbers will vary)

  ```elixir
  %{
    expr: "1..10 |> Enum.map(&(&1 * 2 / ((1 + 10) * 10))) |> Enum.sum()",
    max: 46,
    mean: 46.0,
    median: 46,a
    min: 46,
    n: 1,
    result: 1.0
  }
  ```
  All times are in microseconds.

  The `time` macro takes a second argument that is the number `n` of times the expression
  is executed to gather timing statistics. When the above expression is piped into
  `Time.time(100)`, the result will look something like

  ```elixir
  %{
    expr: "1..10 |> Enum.map(&(&1 * 2 / ((1 + 10) * 10))) |> Enum.sum()",
    max: 71,
    mean: 13.83,
    median: 12,
    min: 10,
    n: 100,
    result: 1.0
  }
  ```
  """

  alias Tim.Stats

  @doc """
  Takes an Elixir expression and returns a map of timing stats after executing
  the provided expression `n` times.
  """
  defmacro time(expr, n \\ 1) when is_integer(n) do
    expr_string = Macro.to_string(expr)

    quote do
      {times, [result | _]} =
        Enum.map(1..unquote(n), fn _ ->
          :timer.tc(fn -> unquote(expr) end)
        end)
        |> Enum.unzip()

      Map.merge(
        %{expr: unquote(expr_string), n: unquote(n), result: result},
        Stats.collect(times)
      )
    end
  end
end
