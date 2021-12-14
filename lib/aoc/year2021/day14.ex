defmodule AOC.Year2021.Day14 do
  use AOC, day: 14

  def part1(list \\ input(), step_size) do
    {protein, instructions} = parse_input(list)

    1..step_size
    |> Enum.reduce({protein, instructions}, &perform_insertion/2)
    |> elem(0)
    |> Enum.frequencies()

    # |> Map.values()
    # |> Enum.min_max()
    # |> then(fn {min, max} -> max - min end)
  end

  def part2(list \\ input(), step_size) do
    {protein, instructions} = parse_input(list)

    freq_map =
      protein
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.frequencies()
      |> IO.inspect(label: :init_freq)

    1..step_size
    |> Enum.reduce({freq_map, instructions}, &update_frequencies/2)
    |> elem(0)
    |> count_letters()

    # |> Enum.flat_map(fn {[v1, v2], count} -> [{v1, count}, {v2, count}] end)
    # |> Enum.reduce(%{}, fn {v, count}, acc -> Map.update(acc, v, count, fn val -> val + count end) end)
  end

  def update_frequencies(step, {freq_map, instructions}) do
    freq_map
    |> Enum.flat_map(fn {[v1, v2] = val, count} ->
      [
        {[v1, instructions[val]] |> List.flatten(), count},
        {[instructions[val], v2] |> List.flatten(), count}
      ]
    end)
    |> Enum.group_by(fn {x, _} -> x end)
    |> Enum.map(&update_sum/1)
    |> then(fn x -> {x, instructions} end)
  end

  def update_sum({k, list}) do
    list
    |> Enum.map(fn {_k, v} -> v end)
    |> Enum.sum()
    |> then(fn v -> {k, v} end)
  end

  def count_letters(map) do
    map
    |> Enum.map(fn {[c | _], count} -> {c, count} end)
  end

  def perform_insertion(step, {protein, instructions}) do
    IO.inspect(protein, label: "On #{step}")

    protein =
      protein
      |> Enum.chunk_every(2, 1)
      |> Enum.map(&insert_pair(&1, instructions))
      |> List.flatten()

    {protein, instructions}
  end

  def insert_pair([v1, _] = val, instructions) do
    if instructions[val], do: [v1, instructions[val]], else: val
  end

  def insert_pair(val, _), do: val

  def parse_input(list \\ input()) do
    list
    |> Enum.reduce(
      {[], %{}},
      fn
        <<a::size(8), b::size(8), _::size(32), c::size(8)>>, {protein, acc} ->
          {protein, Map.put(acc, [a, b], [c])}

        line, {_, acc} ->
          {String.to_charlist(line), acc}
      end
    )
  end
end
