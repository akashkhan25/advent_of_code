defmodule AOC.Year2021.Day4 do
  use AOC, day: 4

  def part1(list \\ input()) do
    {draws, boards} = parse_input(list)

    boards
    |> Enum.map(&play_bingo(draws, &1, []))
    |> Enum.reject(&is_nil/1)
    |> Enum.min_by(fn {_board, draws} -> length(draws) end)
    |> calculate_score()
  end

  def part2(list \\ input()) do
    {draws, boards} = parse_input(list)

    boards
    |> Enum.map(&play_bingo(draws, &1, []))
    |> Enum.reject(&is_nil/1)
    |> Enum.max_by(fn {_board, draws} -> length(draws) end)
    |> calculate_score()
  end

  def calculate_score({board, [last_draw | _rest] = draws}) do
    board
    |> List.flatten()
    |> Enum.reject(&(&1 in draws))
    |> Enum.sum()
    |> then(fn sum -> sum * last_draw end)
  end

  def play_bingo([], _board, _current_draws), do: nil

  def play_bingo([draw | all_draws], board, current_draws) do
    current_draws = [draw | current_draws]

    if any_row?(board, current_draws) or any_col?(board, current_draws) do
      {board, current_draws}
    else
      play_bingo(all_draws, board, current_draws)
    end
  end

  def any_row?(board, current_draws) do
    board
    |> Enum.any?(fn row -> Enum.all?(row, &(&1 in current_draws)) end)
  end

  def any_col?(board, current_draws) do
    board
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> any_row?(current_draws)
  end

  def parse_input(list \\ input()) do
    [numbers | boards] = list
    numbers = numbers |> String.split(",") |> Enum.map(&String.to_integer/1)

    boards =
      boards
      |> Enum.map(fn row ->
        String.split(row, " ", trim: true) |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.chunk_every(5)

    {numbers, boards}
  end
end
