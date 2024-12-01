defmodule AOC.Year2024.Day1 do
  use AOC, day: 1

  def part1(name \\ :input) do
    {l1, l2} = parse_input(name)
    {l1, l2} = {Enum.sort(l1), Enum.sort(l2)}

    l1
    |> Enum.zip_with(l2, &abs(&1 - &2))
    |> Enum.sum()
  end

  def part2(name \\ :input) do
    {l1, l2} = parse_input(name)
    freq = Enum.frequencies(l2)

    Enum.reduce(l1, 0, fn val, acc ->
      sim = Map.get(freq, val, 0)
      acc = acc + val * sim
    end)
  end

  def parse_input(list) do
    list
    |> raw_input()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, " ", trim: true) end)
    |> Enum.reduce({[], []}, fn [v1, v2], {l1, l2} ->
      [v1, v2] = [String.to_integer(v1), String.to_integer(v2)]
      {[v1 | l1], [v2 | l2]}
    end)
  end
end
