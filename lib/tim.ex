defmodule Tim do
  @readme "README.md"
  @external_resource @readme
  @moduledoc_readme @readme
                    |> File.read!()
                    |> String.split("<!-- END HEADER -->")
                    |> Enum.fetch!(1)
                    |> String.trim()

  @moduledoc """
  #{@moduledoc_readme}
  """

  alias Tim.Stats

  @type unit :: :microsecond | :millisecond | :second | :minute | :hour

  @default_opts %{n: 1, unit: :microsecond}

  @doc """
  Takes an Elixir expression and returns a map of timing stats and the evaluated result.

  `time` has the following optional keyword arguments:
  * `:n` - number of times the expression is evaluated to build statistics; defaults to 1
  * `:unit` - unit of time for the timing statistics; `:microsecond` (default) | `:millisecond` | `:second` | `:minute` | `:hour`
  """
  defmacro time(expr, opts \\ []) do
    %{n: n, unit: unit} = Map.merge(@default_opts, Enum.into(opts, %{}))
    scale = unit_to_scale(unit)
    expr_string = Macro.to_string(expr)

    quote do
      {times, [result | _]} =
        Enum.map(1..unquote(n), fn _ ->
          :timer.tc(fn -> unquote(expr) end)
        end)
        |> Enum.unzip()

      Map.merge(
        %{expr: unquote(expr_string), n: unquote(n), result: result, unit: unquote(unit)},
        Stats.collect(times, unquote(scale))
      )
    end
  end

  @doc """
  Takes an Elixir expression and returns the evaluated result while also
  applying `IO.inspect` to the map of timing stats.

  `inspect` has the following optional keyword arguments:
  * `:n` - number of times the expression is evaluated to build statistics; defaults to 1
  * `:unit` - unit of time for the timing statistics; `:microsecond` (default) | `:millisecond` | `:second` | `:minute` | `:hour`
  """
  defmacro inspect(expr, opts \\ []) do
    quote do
      unquote(expr)
      |> Tim.time(unquote(opts))
      |> then(fn %{result: result} = data ->
        data |> Map.delete(:result) |> IO.inspect(label: "Timing data")
        result
      end)
    end
  end

  defp unit_to_scale(:microsecond), do: 1
  defp unit_to_scale(:millisecond), do: 1.0e-3
  defp unit_to_scale(:second), do: 1.0e-6
  defp unit_to_scale(:minute), do: 1.6667e-8
  defp unit_to_scale(:hour), do: 2.7778e-10
end
