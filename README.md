[![Version][hex-pm-version-badge]][hex-pm-versions]

<!-- END HEADER -->

_`Tim` the tiny timer._

Sometimes you want a simple tool to estimate execution time. `Tim` can help!

## Explanation and usage

`Tim` provides the macro `time` that takes any valid Elixir expression and returns a map
containing several statistics for the expression's execution time, the result of the 
evaluated expression, and the expression's string representation. To use 
`time`, require or import `Tim` into your environment and pipe in the expression:

```elixir
iex> require Tim
iex> 1..10 
...> |> Enum.map(& &1 * 2/((1 + 10) * 10)) 
...> |> Enum.sum()
...> |> Tim.time()
%{
  expr: "1..10 |> Enum.map(&(&1 * 2 / ((1 + 10) * 10))) |> Enum.sum()",
  max: 46,
  mean: 46.0,
  median: 46,
  min: 46,
  n: 1,
  result: 1.0,
  unit: :microsecond
}
```
Actual timing statistics will vary. By default, all times are in microseconds.

The `time` macro has two optional keyword arguments: 
* `:n` - number of times 
the expression is executed to gather timing statistics (defaults to 1)
* `:unit` - unit of time in the reported statistics, which can be one of `:microsecond` (default), `:millisecond`, `:second`, `:minute`, or `:hour`

`Tim` also provides an `inspect` macro that applies `IO.inspect` to the timing data returned
by `Tim.time`, but then returns the result of the expression being timed. This allows timing 
data to be captured in the middle of a pipeline. Like `Tim.time`, `inspect` also takes the
optional keyword arguments `:n` and `:unit`. Here's an example of using `inspect`:

```elixir
iex> require Tim
iex> :timer.sleep(1_000) |> Tim.inspect(n: 2, unit: :second)
Timing data: %{
  max: 1.000952,
  min: 1.00057,
  unit: :second,
  expr: ":timer.sleep(1000)",
  n: 2,
  mean: 1.000761,
  median: 1.000952
}
:ok
```

## Under the hood

The body of the `Tim.time` macro wraps around Erlang's [`:timer.tc`](https://www.erlang.org/doc/man/timer.html#tc-1) 
function that returns `{<execution time in microseconds>, <result value>}`. The reason that `time` is a macro is so
that the entire expression remains unevaluated until called inside `:timer.tc`. To generate timing
statistics over independent executions, `:timer.tc` and the expression are evaluated `n` times.

