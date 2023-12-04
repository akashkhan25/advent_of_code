defmodule AOC.Year2023.Day3 do
  use AOC, day: 3

  def part1(list \\ input()) do
    %{symbols: symbols, numbers: numbers} = parse_input(list)

    symbol_coords = Map.keys(symbols) |> MapSet.new()

    for {y, line_numbers} <- numbers,
        {number, {start, length}} <- line_numbers,
        x_range <- (start - 1)..(start + length),
        y_range <- (y - 1)..(y + 1),
        {x_range, y_range} in symbol_coords,
        reduce: 0 do
      acc -> acc + number
    end
  end

  def part2(list \\ input()) do
    %{symbols: symbols, numbers: numbers} = parse_input(list)

    symbol_coords = Enum.filter(symbols, fn {_, val} -> val == ?* end) |> Enum.map(&elem(&1, 0))

    for {y, line_numbers} <- numbers,
        {number, {start, length}} <- line_numbers,
        x_range <- (start - 1)..(start + length),
        y_range <- (y - 1)..(y + 1),
        {x_range, y_range} in symbol_coords,
        into: [] do
      {number, {x_range, y_range}}
    end
    |> Enum.group_by(&elem(&1, 1))
    |> Enum.filter(&match?({_, [_, _]}, &1))
    |> Enum.map(fn {_, values} -> Enum.map(values, &elem(&1, 0)) |> Enum.product() end)
    |> Enum.sum()
  end

  def parse_input(list \\ input()) do
    symbols =
      for {line, y} <- Enum.with_index(list),
          {val, x} <- Enum.with_index(String.to_charlist(line)),
          val not in ?0..?9 and val != ?.,
          into: %{} do
        {{x, y}, val}
      end

    number_indices =
      for {line, y} <- Enum.with_index(list), into: [] do
        numbers = Regex.scan(~r/\d+/, line) |> List.flatten() |> Enum.map(&String.to_integer/1)
        indices = Regex.scan(~r/\d+/, line, return: :index) |> List.flatten()
        {y, Enum.zip(numbers, indices)}
      end
      |> Enum.reject(&match?({_, []}, &1))

    %{symbols: symbols, numbers: number_indices}
  end
end
