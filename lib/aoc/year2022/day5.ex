defmodule AOC.Year2022.Day5 do
  use AOC, day: 5

  def part1(name \\ :input) do
    {stack, moves} =
      name
      |> parse_input()

    play_moves(moves, stack, true)
    |> Enum.map(fn {_k, v} -> hd(v) end)
    |> Enum.join()
  end

  def part2(name \\ :input) do
    {stack, moves} =
      name
      |> parse_input()

    play_moves(moves, stack, false)
    |> Enum.map(fn {_k, v} -> hd(v) end)
    |> Enum.join()
  end

  def play_moves(moves, stack, should_reverse?) do
    moves
    |> Enum.reduce(stack, &do_play_move(&1, &2, should_reverse?))
  end

  def do_play_move(%{count: count, from: from, to: to}, current_stack, should_reverse?) do
    from_items = Map.get(current_stack, from)
    to_items = Map.get(current_stack, to)
    transfer = Enum.take(from_items, count)
    transfer = if should_reverse?, do: Enum.reverse(transfer), else:  transfer
    current_stack
    |> Map.update(from, from_items, fn current -> Enum.drop(current, count) end)
    |> Map.update(to, to_items, fn current -> transfer ++ current end)
  end

  def parse_input(name \\ :input) do
    name
    |> raw_input()
    |> String.split("\n\n", trim: true)
    |> then(fn [a, b] -> {parse_stacks(a), parse_moves(b)} end)
  end

  def parse_stacks(stack_lines) do
    [_ | rest] =
      stack_lines
      |> String.split("\n", trim: true)
      |> Enum.reverse()

    rest
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> build_stacks()
  end

  def build_stacks(stacks) do
    for stack <- stacks, reduce: %{} do
      acc ->
        stack
        |> Enum.with_index(1)
        |> Enum.reduce(acc, fn
          {"0", _}, current_acc -> current_acc
          {val, i}, current_acc -> Map.update(current_acc, i, [val], fn list -> [val | list] end)
        end)
    end
  end

  def parse_moves(moves) do
    moves
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.run(~r/move (\d.*) from (\d) to (\d)/, &1))
    |> Enum.map(fn [_, b, c, d] ->
      %{count: String.to_integer(b), from: String.to_integer(c), to: String.to_integer(d)}
    end)
  end
end
