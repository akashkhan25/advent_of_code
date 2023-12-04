defmodule AOC.Year2023.Day2 do
  use AOC, day: 2

  @regex ~r/(\d+) (\w)/

  def part1(name \\ :input) do
    name
    |> parse_input()
    |> Enum.with_index(1)
    |> Enum.filter(fn {map, _i} ->
      map["r"] <= 12 and map["g"] <= 13 and map["b"] <= 14
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part2(name \\ :input) do
    name
    |> parse_input()
    |> Enum.map(&Map.values/1)
    |> Enum.map(&Enum.product/1)
    |> Enum.sum()
  end

  def parse_input(name \\ :input) do
    name
    |> raw_input()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    @regex
    |> Regex.scan(line, capture: :first)
    |> List.flatten()
    |> Enum.reduce(%{"r" => 0, "g" => 0, "b" => 0}, fn value, acc ->
      [count, color] = String.split(value, " ")
      count = String.to_integer(count)
      Map.update(acc, color, count, fn old -> max(old, count) end)
    end)
  end
end
