defmodule AOC.Year2021.Day22 do
  use AOC, day: 22

  def part1(list \\ input()) do
    list
    |> parse_input()
    |> Enum.reject(fn {_k, v} -> Enum.any?(v, &Range.disjoint?(-50..50, &1)) end)
    |> Enum.reduce(MapSet.new(), &handle_switch/2)
    |> MapSet.size()
  end

  def handle_switch({:on, [r_x, r_y, r_z]}, cubes) do
    for x <- part1_range(r_x), y <- part1_range(r_y), z <- part1_range(r_z), reduce: cubes do
      cubes -> MapSet.put(cubes, {x, y, z})
    end
  end

  def handle_switch({:off, [r_x, r_y, r_z]}, cubes) do
    for x <- part1_range(r_x), y <- part1_range(r_y), z <- part1_range(r_z), reduce: cubes do
      cubes -> MapSet.delete(cubes, {x, y, z})
    end
  end

  def part1_range(v1..v2), do: max(-50, v1)..min(v2, 50)

  def parse_input(list \\ input()) do
    list
    |> Enum.map(&parse_line/1)
  end

  def parse_line("on " <> coords) do
    {:on, parse_coords(coords)}
  end

  def parse_line("off " <> coords) do
    {:off, parse_coords(coords)}
  end

  def parse_coords(coords) do
    coords
    |> String.replace(~r/x=|y=|z=/, "")
    |> String.split(",")
    |> Stream.map(&Code.eval_string/1)
    |> Enum.map(&elem(&1, 0))
  end
end
