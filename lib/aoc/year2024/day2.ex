defmodule AOC.Year2024.Day2 do
  use AOC, day: 2

  def part1(name \\ :input) do
    parse_input(name)
    |> Enum.filter(&safe_p1?/1)
    |> Enum.count()
  end

  def part2(name \\ :input) do
    parse_input(name)
    |> Enum.filter(&safe_p2?/1)
    |> Enum.count()
  end

  def safe_p1?(list) do
    diffs =
      list
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> a - b end)

    inc =
      Enum.all?(diffs, fn diff ->
        diff > 0 and diff >= 1 and diff <= 3
      end)

    dec =
      Enum.all?(diffs, fn diff ->
        diff < 0 and diff <= -1 and diff >= -3
      end)

    inc or dec
  end

  def safe_p2?(list) do
    vars = generate_variations(list)
    Enum.any?([list | vars], &safe_p1?/1)
  end

  def generate_variations([]), do: []
  def generate_variations([_]), do: [[]]

  def generate_variations([h | t]) do
    [t | do_generate(t, [h])]
  end

  def do_generate([], _), do: []

  def do_generate([h | t], acc) do
    [acc ++ t | do_generate(t, acc ++ [h])]
  end

  def parse_input(list) do
    list
    |> raw_input()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(fn line -> Enum.map(line, &String.to_integer/1) end)
  end
end
