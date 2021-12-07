defmodule AOC.Year2021.Day7 do
  use AOC, day: 7

  def part1(list \\ input()) do
    list
    |> parse_input()
    |> calculate_costs(:simple)
    |> Enum.min()
  end

  def part2(list \\ input()) do
    list
    |> parse_input()
    |> calculate_costs(:crabby)
    |> Enum.min()
  end

  def calculate_costs(list, :simple) do
    {min, max} = Enum.min_max(list)

    for i <- min..max do
      Enum.map(list, &abs(&1 - i)) |> Enum.sum()
    end
  end

  def calculate_costs(list, :crabby) do
    {min, max} = Enum.min_max(list)

    for i <- min..max do
      Enum.map(list, &div(abs(&1 - i) * (abs(&1 - i) + 1), 2)) |> Enum.sum()
    end
  end

  def parse_input([list] \\ input()) do
    list
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
  end
end
