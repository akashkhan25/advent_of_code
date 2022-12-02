defmodule AOC.Year2022.Day2 do
  use AOC, day: 2

  # A: rock
  # B: paper
  # C: scissor
  @scores %{
    lose: 0,
    draw: 3,
    win: 6
  }

  @expectations %{
    ?X => :lose,
    ?Y => :draw,
    ?Z => :win
  }

  def part1(list \\ input()) do
    list
    |> parse_input()
    |> Enum.map(&check_results/1)
    |> Enum.map(&calculate_score/1)
    |> Enum.sum()
  end

  def part2(list \\ input()) do
    list
    |> parse_input()
    |> Enum.map(&check_expected_results/1)
    |> Enum.map(&calculate_score/1)
    |> Enum.sum()
  end

  def parse_input(list \\ input()) do
    list
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.map(&Enum.map(&1, fn x -> String.to_charlist(x) end))
    |> Enum.map(&Enum.map(&1, fn [x] -> x end))
  end

  def check_results([a, b]) do
    a = a - ?A
    b = b - ?X
    result =
      cond do
        a == b -> :draw
        a == rem(b + 2, 3) -> :win
        a == rem(b + 1, 3) -> :lose
      end

    {result, b + 1}
  end

  def check_expected_results([a, b]) do
    result = Map.get(@expectations, b)
    a = a - ?A

    play_hand =
      case {result, a} do
        {:draw, a} -> a
        {:lose, a} -> rem(a + 2, 3)
        {:win, a} -> rem(a + 1, 3)
      end

    {result, play_hand + 1}
  end

  def calculate_score({result, hand}), do: Map.get(@scores, result) + hand
end
