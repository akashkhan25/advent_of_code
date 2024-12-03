defmodule AOC.Year2024.Day3 do
  use AOC, day: 3
  import NimbleParsec

  valid_mult =
    ignore(string("mul("))
    |> integer(min: 1, max: 3)
    |> ignore(string(","))
    |> integer(min: 1, max: 3)
    |> ignore(string(")"))
    |> tag(:mult)

  enable = ignore(string("do()")) |> tag(:do)
  disable = ignore(string("don't()")) |> tag(:dont)

  parsed =
    valid_mult
    |> eventually()
    |> repeat()

  p2_parsed =
    [enable, disable, valid_mult]
    |> choice()
    |> eventually()
    |> repeat()

  defparsec(:parse, parsed)
  defparsec(:parse_p2, p2_parsed)

  def part1(list \\ :input) do
    list
    |> raw_input()
    |> parse()
    |> elem(1)
    |> Enum.map(fn {:mult, [a, b]} -> a * b end)
    |> Enum.sum()
  end

  def part2(list \\ :input) do
    list
    |> raw_input()
    |> parse_p2()
    |> elem(1)
    |> Enum.reduce({0, true}, &process/2)
    |> elem(0)
  end

  defp process({:mult, [a, b]}, {acc, true}) do
    {acc + a * b, true}
  end

  defp process({:mult, _}, {acc, false}) do
    {acc, false}
  end

  defp process({:do, []}, {acc, _}) do
    {acc, true}
  end

  defp process({:dont, []}, {acc, _}) do
    {acc, false}
  end
end
