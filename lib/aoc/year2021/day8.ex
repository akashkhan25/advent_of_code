defmodule AOC.Year2021.Day8 do
  use AOC, day: 8

  def part1(list \\ input()) do
    checks = [2, 4, 3, 7]

    list
    |> parse_input()
    |> Enum.reduce(0, fn {_patterns, output}, acc ->
      count = output |> Enum.count(&(String.length(&1) in checks))
      acc + count
    end)
  end

  def part2(list \\ input()) do
    list
    |> parse_input()
    |> solve(0)
  end

  def solve([], acc), do: acc

  def solve([head | tail], acc) do
    output = guess_output(head)
    solve(tail, acc + output)
  end

  def guess_output({patterns, output}) do
    guessed_patterns =
      patterns
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&guess/1)

    {knowns, unknowns} = Enum.split_with(guessed_patterns, &is_tuple/1)

    guessed_output =
      output
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&guess/1)

    {zero_two, results} =
      {unknowns, knowns}
      |> guess_three()
      |> guess_five()
      |> guess_six()
      |> guess_nine()

    {[zero], [two]} = Enum.split_with(zero_two, &(MapSet.size(&1) == 6))

    mapping = [{zero, "0"}, {two, "2"} | results] |> Enum.into(%{})

    calculate_output(mapping, guessed_output)
  end

  def guess_three({unknowns, knowns}) do
    {seven, _} = find_val(knowns, "7")

    check_fn = fn x, check_val ->
      MapSet.intersection(x, check_val) == check_val
    end

    three = find_by_length_and_cond(unknowns, 5, seven, check_fn)
    unknowns = remove_val(unknowns, three)
    {unknowns, [{three, "3"} | knowns]}
  end

  def guess_five({unknowns, knowns}) do
    {four, _} = find_val(knowns, "4")

    check_fn = fn x, check_val ->
      check_val
      |> MapSet.intersection(x)
      |> MapSet.size() == 3
    end

    five = find_by_length_and_cond(unknowns, 5, four, check_fn)
    unknowns = remove_val(unknowns, five)
    {unknowns, [{five, "5"} | knowns]}
  end

  def guess_six({unknowns, knowns}) do
    {one, _} = find_val(knowns, "1")

    check_fn = fn x, check_val ->
      x
      |> MapSet.intersection(check_val)
      |> MapSet.size() == 1
    end

    six = find_by_length_and_cond(unknowns, 6, one, check_fn)
    unknowns = remove_val(unknowns, six)
    {unknowns, [{six, "6"} | knowns]}
  end

  def guess_nine({unknowns, knowns}) do
    {four, _} = find_val(knowns, "4")

    check_fn = fn x, check_val ->
      MapSet.intersection(x, check_val) == check_val
    end

    nine = find_by_length_and_cond(unknowns, 6, four, check_fn)
    unknowns = remove_val(unknowns, nine)
    {unknowns, [{nine, "9"} | knowns]}
  end

  def guess(word) when length(word) == 2, do: {set(word), "1"}
  def guess(word) when length(word) == 4, do: {set(word), "4"}
  def guess(word) when length(word) == 3, do: {set(word), "7"}
  def guess(word) when length(word) == 7, do: {set(word), "8"}
  def guess(word), do: set(word)

  def set(word), do: MapSet.new(word)

  def find_val(list, val) do
    Enum.find(list, fn
      {_, ^val} -> true
      _ -> false
    end)
  end

  def remove_val(list, val) do
    list
    |> Enum.reject(&(&1 == val))
  end

  def find_by_length_and_cond(list, len, check_val, check_fn) do
    list
    |> Enum.filter(fn set -> MapSet.size(set) == len end)
    |> Enum.find(&check_fn.(&1, check_val))
  end

  def calculate_output(mapping, outputs) do
    outputs
    |> Enum.map(fn
      {_, val} -> val
      k -> Map.get(mapping, k)
    end)
    |> Enum.join()
    |> String.to_integer()
  end

  def parse_input(list \\ input()) do
    Enum.map(list, &parse_line/1)
  end

  def parse_line(line) do
    line
    |> String.split([" ", " | "])
    |> Enum.split(10)
  end
end
