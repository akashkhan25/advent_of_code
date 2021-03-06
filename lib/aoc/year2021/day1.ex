defmodule AOC.Year2021.Day1 do
  use AOC, day: 1

  def part1(list, count \\ 0)

  def part1([a, b | tail] = _list, count) do
    count = if b > a, do: count + 1, else: count
    part1([b | tail], count)
  end

  def part1(_, count), do: count

  def part2(list, count \\ 0)

  def part2([a, b, c, d | tail] = _list, count) do
    count = if a < d, do: count + 1, else: count
    part2([b, c, d | tail], count)
  end

  def part2(_, count), do: count

  def parse_input(list \\ input()) do
    Enum.map(list, &String.to_integer/1)
  end
end
