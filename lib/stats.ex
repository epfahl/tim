defmodule Tim.Stats do
  @moduledoc """
  Aggregates stats.
  """

  @doc """
  Return a map of statistical aggregates for a list of numbers.
  """
  @spec collect(list(number)) :: map
  def collect(list) do
    %{
      mean: mean(list),
      median: median(list),
      min: min(list),
      max: max(list)
    }
  end

  @doc """
  Compute the mean value of a list of numbers.

  ## Exmaples
    iex> Tim.Stats.mean([1])
    1.0
    iex> Tim.Stats.mean([1, 2, 3, 4])
    2.5
  """
  def mean([_ | _] = list), do: Enum.sum(list) / length(list)
  def mean([]), do: handle_empty()

  @doc """
  Compute the median value of a list of numbers. This function always returns an element
  of the list.

  ## Exmaples
    iex> Tim.Stats.median([1])
    1
    iex> Tim.Stats.median([1, 2, 3])
    2
    iex> Tim.Stats.median([1, 2, 3, 4])
    3
  """
  def median([_ | _] = list) do
    sorted = Enum.sort(list)
    len = length(list)

    if rem(len, 2) == 0 do
      Enum.at(sorted, div(len, 2))
    else
      Enum.at(sorted, div(len - 1, 2))
    end
  end

  def median([]), do: handle_empty()

  @doc """
  Compute the minimum value of a list of numbers. This aliases `Enum.min`.
  """
  def min(list), do: Enum.min(list)

  @doc """
  Compute the maximum value of a list of numbers. This aliases `Enum.max`.
  """
  def max(list), do: Enum.max(list)

  defp handle_empty(), do: raise(Enum.EmptyError)
end
