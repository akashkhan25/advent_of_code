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

    {zero, two} = Enum.split_with(zero_two, &(MapSet.size(&1) == 6))

    # TODO: fix this
    mapping =
      [{"0", zero}, {"2", two} | results]
      |> Enum.reduce(%{}, fn {v, k}, acc -> Map.put(acc, k, v) end)

    calculate_output(mapping, guessed_output)
  end

  def guess_three({unknowns, knowns}) do
    {_, seven} = find_val(knowns, "7")

    check_fn = fn x, check_val ->
      MapSet.intersection(x, check_val) == check_val
    end

    three = find_by_length_and_cond(unknowns, 5, seven, check_fn)
    unknowns = remove_val(unknowns, three)
    {unknowns, [{"3", three} | knowns]}
  end

  def guess_five({unknowns, knowns}) do
    {_, four} = find_val(knowns, "4")

    check_fn = fn x, check_val ->
      MapSet.intersection(check_val, x) |> MapSet.size() == 3
    end

    five = find_by_length_and_cond(unknowns, 5, four, check_fn)
    unknowns = remove_val(unknowns, five)
    {unknowns, [{"5", five} | knowns]}
  end

  def guess_six({unknowns, knowns}) do
    {_, one} = find_val(knowns, "1")

    check_fn = fn x, check_val ->
      x
      |> MapSet.intersection(check_val)
      |> MapSet.size() == 1
    end

    six = find_by_length_and_cond(unknowns, 6, one, check_fn)
    unknowns = remove_val(unknowns, six)
    {unknowns, [{"6", six} | knowns]}
  end

  def guess_nine({unknowns, knowns}) do
    {_, four} = find_val(knowns, "4")

    check_fn = fn x, check_val ->
      MapSet.intersection(x, check_val) == check_val
    end

    nine = find_by_length_and_cond(unknowns, 6, four, check_fn)
    unknowns = remove_val(unknowns, nine)
    {unknowns, [{"9", nine} | knowns]}
  end

  def guess(word) when length(word) == 2, do: {"1", set(word)}
  def guess(word) when length(word) == 4, do: {"4", set(word)}
  def guess(word) when length(word) == 3, do: {"7", set(word)}
  def guess(word) when length(word) == 7, do: {"8", set(word)}
  def guess(word), do: set(word)

  def set(word), do: MapSet.new(word)

  def find_val(list, val) do
    Enum.find(list, fn
      {^val, _} -> true
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
      {val, _} -> val
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
