defmodule AOC.Year2022.Day1 do
  use AOC, day: 1

  def part1(name \\ :input) do
    name
    |> parse_input()
    |> Enum.max()
  end

  def part2(name \\ :input) do
    name
    |> parse_input()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  def parse_input(name) do
    name
    |> raw_input()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
    |> Enum.map(&Enum.sum/1)
  end
end
