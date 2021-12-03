defmodule AOC.Year2021.Day3 do
  use AOC, day: 3

  def part1(input \\ parse_input()) do
    input
    |> power_consumption()
    |> calc_ans()
  end

  def part2(input \\ parse_input()) do
    {calc_oxy(input, "", 0), calc_co2(input, 0)}
    |> calc_ans()
  end

  def power_consumption(input) do
    input
    |> find_frequencies()
    |> Stream.map(&find_rates/1)
    |> Enum.reduce({"", ""}, fn {a, b}, {gam, eps} -> {gam <> a, eps <> b} end)
  end

  def parse_input(list \\ input()) do
    list
    |> Enum.map(&String.graphemes/1)
  end

  def find_frequencies(input) do
    input
    |> Stream.zip()
    |> Stream.map(&Tuple.to_list/1)
    |> Stream.map(&Enum.frequencies/1)
  end

  defp calc_ans(val) do
    val
    |> then(fn {x, y} -> {String.to_integer(x, 2), String.to_integer(y, 2)} end)
    |> then(fn {x, y} -> x * y end)
  end

  defp find_rates(val) do
    {find_mode(val, :greater), find_mode(val, :lesser)}
  end

  def find_mode(%{"0" => v1, "1" => v2}, :greater) do
    if v1 > v2, do: "0", else: "1"
  end

  def find_mode(%{"0" => v1, "1" => v2}, :lesser) do
    if v1 > v2, do: "1", else: "0"
  end

  def find_mode(%{} = map, _mode) do
    map
    |> Map.keys()
    |> hd
  end

  def calc_oxy([_], val, _index), do: val

  def calc_oxy(input, val, index) do
    check_val =
      input
      |> find_frequencies()
      |> Enum.at(index)
      |> find_mode(:greater)

    new_input = input |> Enum.filter(&(Enum.at(&1, index) == check_val))
    calc_oxy(new_input, val <> check_val, index + 1)
  end

  def calc_co2([val], _index), do: Enum.join(val)

  def calc_co2(input, index) do
    check_val =
      input
      |> find_frequencies()
      |> Enum.at(index)
      |> find_mode(:lesser)

    new_input = input |> Enum.filter(&(Enum.at(&1, index) == check_val))
    calc_co2(new_input, index + 1)
  end
end
