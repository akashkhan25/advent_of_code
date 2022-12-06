defmodule AOC.Year2022.Day6 do
  use AOC, day: 6

  def part1(list \\ input()) do
    list
    |> parse_input()
    |> start_marker(4)
  end

  def part2(list \\ input()) do
    list
    |> parse_input()
    |> start_marker(14)
  end

  def start_marker(list, count) do
    count
    |> Stream.iterate(&(&1 + 1))
    |> Enum.reduce_while(list, &do_get_start_marker(&1, &2, count))
  end

  def do_get_start_marker(pos, list, count) do
    check =
      list
      |> Enum.take(count)
      |> MapSet.new()

    if MapSet.size(check) == count do
      {:halt, pos}
    else
      {:cont, tl(list)}
    end
  end

  def parse_input(list \\ input()) do
    list
    |> hd()
    |> String.to_charlist()
  end
end
