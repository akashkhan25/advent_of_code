defmodule AOC.Year2021.Day3 do
  use AOC, day: 3

  def part1(input \\ parse_input(), size \\ 11) do
    input
    |> power_consumption(size)
    |> calc_ans()
  end

  def part2(input \\ parse_input(), size \\ 11) do
    {calc_oxy(input, size, "", 0), calc_co2(input, size, 0)}
    |> calc_ans()
  end

  def power_consumption(input, size) do
    input
    |> find_frequencies(size)
    |> Enum.map(&find_rates/1)
    |> Enum.reduce({"", ""}, fn {a, b}, {gam, eps} -> {gam <> a, eps <> b} end)
  end

  def parse_input(list \\ input()) do
    list
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  def find_frequencies(input, size) do
    for i <- 0..size do
      Enum.frequencies_by(input, &Enum.at(&1, i))
    end
  end

  defp calc_ans(val) do
    val
    |> then(fn {x, y} -> {String.to_integer(x, 2), String.to_integer(y, 2)} end)
    |> then(fn {x, y} -> x * y end)
  end

  defp find_rates(val) do
    {find_larger(val), find_smaller(val)}
  end

  defp find_larger(%{"0" => v1, "1" => v2}) do
    if v1 > v2, do: "0", else: "1"
  end

  defp find_larger(%{"0" => _val}), do: "0"
  defp find_larger(%{"1" => _val}), do: "1"

  defp find_smaller(%{"0" => v1, "1" => v2}) do
    if v1 > v2, do: "1", else: "0"
  end

  defp find_smaller(%{"0" => _val}), do: "0"
  defp find_smaller(%{"1" => _val}), do: "1"

  def split_by_bit(input, index, val) do
    input
    |> Enum.split_with(&(Enum.at(&1, index) == val))
  end

  def calc_oxy([_], _size, val, _index), do: val

  def calc_oxy(input, size, val, index) do
    check_val = input |> find_frequencies(size) |> Enum.at(index) |> find_larger()
    new_input = input |> Enum.filter(&(Enum.at(&1, index) == check_val))
    calc_oxy(new_input, size, val <> check_val, index + 1)
  end

  def calc_co2([val], _size, _index), do: Enum.join(val)

  def calc_co2(input, size, index) do

    check_val =
      input
      |> find_frequencies(size)
      |> Enum.at(index)
      |> find_smaller()

    new_input = input |> Enum.filter(&(Enum.at(&1, index) == check_val))
    calc_co2(new_input, size, index + 1)
  end
end
