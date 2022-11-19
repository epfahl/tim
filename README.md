[![Hex.pm Version](https://img.shields.io/hexpm/v/timex.svg?style=flat)](https://hex.pm/packages/tim)

_`Tim` the tiny timer._

Sometimes you want a simple tool to estimate execution time. `Tim` can help!

## Explanation and usage

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

# returns (actual timing numbers will vary)

%{
  expr: "1..10 |> Enum.map(&(&1 * 2 / ((1 + 10) * 10))) |> Enum.sum()",
  max: 46,
  mean: 46.0,
  median: 46,
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

## Under the hood

The body of the `Tim.time` macro wraps around Erlang's [`:timer.tc`](https://www.erlang.org/doc/man/timer.html#tc-1) 
function that returns `{<execution time in microseconds>, <result value>}`. The reason that `time` is a macro is so
that the entire expression remains unevaluated until called inside `:timer.tc`. To generate timing
statistics over independent executions, `:timer.tc` and the expression are evaluated `n` times.

