defmodule AOC.Year2021.Day13 do
  use AOC, day: 13

  def part1(list \\ input()) do
    {coords, [instruction | _], max} = parse_input(list)

    instruction
    |> fold_along({coords, max})
    |> elem(0)
    |> Enum.uniq()
    |> length()
  end

  def part2(list \\ input()) do
    {coords, instructions, max} = parse_input(list)

    instructions
    |> Enum.reduce({coords, max}, &fold_along/2)
    |> print()
  end

  def fold_along("x=" <> val, {coords, {_, max_y}}) do
    val = String.to_integer(val)
    {changed, unchanged} = coords |> Enum.split_with(fn {x, _} -> x > val end)
    changed = changed |> Enum.map(fn {x, y} -> {2 * val - x, y} end)

    {changed ++ unchanged, {val - 1, max_y}}
  end

  def fold_along("y=" <> val, {coords, {max_x, _}}) do
    val = String.to_integer(val)
    {changed, unchanged} = coords |> Enum.split_with(fn {_, y} -> y > val end)
    changed = changed |> Enum.map(fn {x, y} -> {x, 2 * val - y} end)
    {changed ++ unchanged, {max_x, val - 1}}
  end

  def print({coords, _, max}), do: print({coords, max})

  def print({coords, {max_x, max_y}}) do
    for y <- 0..max_y do
      for x <- 0..max_x do
        if {x, y} in coords, do: "#", else: "."
      end
      |> IO.puts()
    end
  end

  def parse_input(list \\ input()) do
    list
    |> Enum.reduce({[], [], {0, 0}}, fn
      "fold along " <> line, {coords, instructions, max} ->
        {coords, [line | instructions], max}

      line, {coords, instructions, {max_x, max_y}} ->
        {x, y} =
          point = line |> String.split(",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()

        max_x = if max_x < x, do: x, else: max_x
        max_y = if max_y < y, do: y, else: max_y
        {[point | coords], instructions, {max_x, max_y}}
    end)
    |> then(fn {coords, ins, {x, y}} -> {coords, Enum.reverse(ins), {x, y}} end)
  end
end
