defmodule AOC.Year2021.Day6 do
  use AOC, day: 6

  def part1(list \\ input()) do
    list
    |> parse_input()
    |> simulate(80)
  end

  def part2(list \\ input()) do
    list
    |> parse_input()
    |> simulate(256)
  end

  def simulate(list, 0), do: Enum.reduce(list, 0, fn {_k, v}, acc -> acc + v end)

  def simulate(list, days) do
    next =
      list
      |> Enum.map(&next_counter/1)
      |> List.flatten()
      |> Enum.reduce(%{}, fn {k, v}, acc -> Map.update(acc, k, v, fn val -> val + v end) end)

    simulate(next, days - 1)
  end

  def next_counter({0, v}), do: [{8, v}, {6, v}]
  def next_counter({k, v}), do: {k - 1, v}

  def parse_input([list] \\ input()) do
    list
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end
end
