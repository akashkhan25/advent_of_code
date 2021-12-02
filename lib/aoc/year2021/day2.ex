defmodule AOC.Year2021.Day2 do
  use AOC, day: 2

  def part1() do
    parse_input()
    |> Enum.reduce({0, 0}, &update_position/2)
  end

  def part2() do
    parse_input()
    |> Enum.reduce({0, 0, 0}, &update_position/2)
  end

  def update_position(["forward", amt], {x, y}) do
    {x + amt, y}
  end

  def update_position(["up", amt], {x, y}) do
    {x, y - amt}
  end

  def update_position(["down", amt], {x, y}) do
    {x, y + amt}
  end

  def update_position(["forward", amt], {x, y, aim}) do
    {x + amt, y + (aim * amt), aim}
  end

  def update_position(["up", amt], {x, y, aim}) do
    {x, y, aim - amt}
  end

  def update_position(["down", amt], {x, y, aim}) do
    {x, y, aim + amt}
  end

  def parse_input() do
    input()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(fn [dir, x] -> [dir, String.to_integer(x)] end)
  end
end
