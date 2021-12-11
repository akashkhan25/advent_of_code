defmodule AOC.Year2021.Day11 do
  use AOC, day: 11
  @offsets for x <- -1..1, y <- -1..1, {x, y} != {0, 0}, do: {x, y}
  @grid_size 9

  def part1(list \\ input(), step_count \\ 100) do
    state = parse_input(list)

    Enum.reduce(1..step_count, {0, state}, fn _, {flash_count, state} ->
      {flashes, new_state} = step(state)
      {flash_count + flashes, new_state}
    end)
    |> tap(fn {_, state} -> print_state(state) end)
    |> elem(0)
  end

  def part2(list \\ input()) do
    state = parse_input(list)

    {0, state}
    |> Stream.iterate(fn {_, state} -> step(state) end)
    |> Enum.find_index(fn
      {100, _} -> true
      _ -> false
    end)
  end

  def step(state) do
    state
    |> increase_all_energy()
    |> then(fn state -> {0, state} end)
    |> Stream.iterate(fn {_, state} -> update_state(state) end)
    |> Stream.drop(1)
    |> Enum.reduce_while(0, &calculate_flash_count/2)
  end

  def increase_all_energy(state) do
    state
    |> Map.new(fn {point, {e, f?}} -> {point, {e + 1, f?}} end)
  end

  def update_state(state) do
    flash_coords = Enum.filter(state, &will_flash?/1)

    flash_coords
    |> Enum.reduce(state, &update_flash_state/2)
    |> then(fn state -> {length(flash_coords), state} end)
  end

  def will_flash?({_, {energy, false}}) when energy > 9, do: true
  def will_flash?(_), do: false

  def update_flash_state({{x, y} = point, _}, state) do
    @offsets
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.filter(&Map.has_key?(state, &1))
    |> Enum.reduce(state, fn point, state ->
      Map.update!(state, point, fn {e, f?} -> {e + 1, f?} end)
    end)
    |> Map.update!(point, fn {e, _} -> {e, true} end)
  end

  def calculate_flash_count({0, state}, acc) do
    state =
      state
      |> Enum.map(fn
        {point, {e, _}} when e > 9 -> {point, {0, false}}
        {point, val} -> {point, val}
      end)
      |> Enum.into(%{})

    {:halt, {acc, state}}
  end

  def calculate_flash_count({count, _}, acc), do: {:cont, acc + count}

  def parse_input(list \\ input()) do
    list
    |> Enum.map(&parse_line/1)
    |> build_state_map()
  end

  def parse_line(line) do
    line
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  def build_state_map(list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {list, y}, acc ->
      list
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {val, x}, acc -> Map.put(acc, {x, y}, {val, false}) end)
    end)
  end

  def print_state(state) do
    for y <- 0..@grid_size, x <- 0..@grid_size, reduce: [] do
      str ->
        str = if x == 0, do: ["\n" | str], else: str
        {energy, _} = Map.fetch!(state, {x, y})
        [to_string(energy) | str]
    end
    |> Enum.reverse()
    |> IO.iodata_to_binary()
    |> IO.puts()
  end
end
