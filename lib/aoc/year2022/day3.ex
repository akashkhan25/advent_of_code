defmodule AOC.Year2022.Day3 do
  use AOC, day: 3

  def part1(list \\ input()) do
    list
    |> parse_input()
    |> Enum.map(&{&1, length(&1)})
    |> Enum.map(fn {l, size} -> Enum.split(l, div(size, 2)) end)
    |> Enum.map(fn {a, b} -> {MapSet.new(a), MapSet.new(b)} end)
    |> Enum.map(fn {a, b} -> MapSet.intersection(a, b) end)
    |> Enum.map(&MapSet.to_list/1)
    |> Enum.map(&to_score/1)
    |> Enum.sum()
  end

  def part2(list \\ input()) do
    list
    |> parse_input()
    |> Enum.map(&MapSet.new/1)
    |> Enum.chunk_every(3)
    |> Enum.map(fn [a, b, c] -> MapSet.intersection(a, MapSet.intersection(b,c)) end)
    |> Enum.map(&MapSet.to_list/1)
    |> Enum.map(&to_score/1)
    |> Enum.sum()
  end

  def to_score([a]) when a <= ?Z do
    a - ?A + 27
  end

  def to_score([a]) when a >= ?a do
    a - ?a + 1
  end


  def parse_input(list \\ input()) do
    list
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.flat_map(&Enum.map(&1, fn x -> String.to_charlist(x) end))
  end
end
