defmodule AOC.Year2023.Day1 do
  use AOC, day: 1

  @regex ~r/(?=(1|2|3|4|5|6|7|8|9|one|two|three|four|five|six|seven|eight|nine))/

  @words %{
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9
  }

  def part1(name \\ :input) do
    name
    |> parse_input()
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&Enum.filter(&1, fn v -> v in ?0..?9 end))
    |> Enum.map(&[Enum.at(&1, 0), Enum.at(&1, -1)])
    |> Enum.map(&List.to_integer/1)
    |> Enum.sum()
  end

  def part2(name \\ :input) do
    name
    |> parse_input()
    |> Enum.map(&Regex.scan(@regex, &1, capture: :all_but_first))
    |> Enum.map(&List.flatten/1)
    |> Enum.map(&detect_numbers/1)
    |> Enum.map(&[Enum.at(&1, 0), Enum.at(&1, -1)])
    |> Enum.map(&Integer.undigits/1)
    |> Enum.sum()
  end

  def parse_input(name) do
    name
    |> raw_input()
    |> String.split("\n", trim: true)
  end

  defp detect_numbers(list) do
    Enum.map(list, fn
      value when is_map_key(@words, value) -> @words[value]
      value -> String.to_integer(value)
    end)
  end
end
