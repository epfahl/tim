defmodule Tim do
  @moduledoc """
  """

  alias Tim.Stats

  @doc """
  Return a collection of timing stats after executing the provided expression `n` times.
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
