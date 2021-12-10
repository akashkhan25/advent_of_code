defmodule AOC.Year2021.Day10 do
  use AOC, day: 10

  @syntax_points %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }

  @complete_points %{
    "(" => 1,
    "[" => 2,
    "{" => 3,
    "<" => 4
  }

  @match %{
    "(" => ")",
    "[" => "]",
    "{" => "}",
    "<" => ">"
  }

  def part1(list \\ input()) do
    list
    |> parse_input()
    |> Stream.map(&find_first_broken/1)
    |> Stream.reject(&is_list/1)
    |> Stream.map(&Map.get(@syntax_points, &1))
    |> Enum.sum()
  end

  def part2(list \\ input()) do
    list
    |> parse_input()
    |> Enum.filter(&is_list(find_first_broken(&1)))
    |> Enum.map(&find_open_brackets/1)
    |> Enum.map(&calculate_line_score/1)
    |> calculate_completion_score()
  end

  def find_first_broken(line) do
    line
    |> Enum.reduce_while([], &check_char/2)
  end

  def check_char("]", ["[" | rest]), do: {:cont, rest}
  def check_char(")", ["(" | rest]), do: {:cont, rest}
  def check_char("}", ["{" | rest]), do: {:cont, rest}
  def check_char(">", ["<" | rest]), do: {:cont, rest}
  def check_char(char, rest) when is_map_key(@match, char), do: {:cont, [char | rest]}
  def check_char(char, _), do: {:halt, char}

  def find_open_brackets(line) do
    line
    |> Enum.reduce([], &find_next_open/2)
    |> Enum.map(&Map.get(@complete_points, &1))
  end

  def find_next_open("]", ["[" | rest]), do: rest
  def find_next_open(")", ["(" | rest]), do: rest
  def find_next_open("}", ["{" | rest]), do: rest
  def find_next_open(">", ["<" | rest]), do: rest
  def find_next_open(char, rest), do: [char | rest]

  def calculate_line_score(line) do
    Enum.reduce(line, 0, &(5 * &2 + &1))
  end

  def calculate_completion_score(scores) do
    scores
    |> Enum.sort()
    |> Enum.at(div(length(scores), 2))
  end

  def parse_input(list \\ input()) do
    list
    |> Enum.map(&String.graphemes/1)
  end
end
