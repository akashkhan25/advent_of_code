defmodule AOC.Year2022.Day4 do
  use AOC, day: 4

  def part1(list \\ input()) do
    list
    |> parse_input()
    |> Enum.count(&contains?/1)
  end

  def part2(list \\ input()) do
    list
    |> parse_input()
    |> Enum.count(&overlaps?/1)
  end


  def contains?([a, b, c, d]) when a >= c and b <= d, do: true
  def contains?([a, b, c, d]) when c >= a and d <= b, do: true
  def contains?(_), do: false

  def overlaps?([_a, b, c, d]) when b >= c and b <= d, do: true
  def overlaps?([a, b, _c, d]) when d >= a and d <= b, do: true
  def overlaps?(_), do: false

  def parse_input(list \\ input()) do
    list
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> Enum.flat_map(&Enum.flat_map(&1, fn x -> String.split(x, "-", trim: true) end))
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(4)
  end
end
