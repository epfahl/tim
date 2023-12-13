defmodule Tim.Stats do
  @moduledoc """
  Aggregates stats.
  """

  @doc """
  Return a map of statistical aggregates for a list of numbers.
  """
  @spec collect([number, ...], number) :: %{atom => number}
  def collect(nums, scale) do
    %{
      mean: mean(nums),
      median: median(nums),
      min: min(nums),
      max: max(nums)
    }
    |> apply_scale(scale)
  end

  @doc """
  Compute the mean value of a list of numbers.

  ## Exmaples

      iex> Tim.Stats.mean([1])
      1.0
      iex> Tim.Stats.mean([1, 2, 3, 4])
      2.5
  """
  @spec mean([number, ...]) :: number
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
  @spec median([number, ...]) :: number
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
  @spec min([number, ...]) :: number
  def min(list), do: Enum.min(list)

  @doc """
  Compute the maximum value of a list of numbers. This aliases `Enum.max`.
  """
  @spec max([number, ...]) :: number
  def max(list), do: Enum.max(list)

  @spec apply_scale(%{atom => number}, number) :: %{atom => number}
  defp apply_scale(stats, scale) do
    for {k, v} <- stats, into: %{}, do: {k, v * scale}
  end

  defp handle_empty(), do: raise(Enum.EmptyError)
end
