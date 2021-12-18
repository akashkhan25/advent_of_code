defmodule AOC.Year2021.Day15 do
  use AOC, day: 15
  @offsets [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]

  def walk({row, col}, r, q, seen, grid) do
    {q, seen} =
      @offsets
      |> Enum.map(fn {dr, dc} -> {row + dr, col + dc} end)
      |> Enum.map(&{&1, grid[&1]})
      |> Enum.reject(&Map.has_key?(seen, elem(&1, 0)))
      |> Enum.reject(&is_nil(elem(&1, 1)))
      |> Enum.reduce({q, seen}, fn {pos, risk}, {q, seen} ->
        {PriorityQueue.put(q, risk + r, pos), Map.put(seen, pos, risk + r)}
      end)

    {{risk, next}, q} = PriorityQueue.pop(q)
    {next, risk, q, seen}
  end

  def solve1(grid) do
    max = grid |> Map.keys() |> Enum.max()

    Stream.iterate(
      {{0, 0}, 0, PriorityQueue.new(), %{{0, 0} => 0}},
      fn {next, risk, q, seen} ->
        walk(next, risk, q, seen, grid)
      end
    )
    |> Stream.drop_while(fn
      {^max, _, _, _} -> false
      _ -> true
    end)
    |> Enum.take(1)
    |> List.first()
    |> elem(1)
    |> IO.inspect()
  end

  def solve2(grid) do
    offset = grid |> Enum.filter(&match?({{0, _}, _}, &1)) |> length

    grid
    |> Enum.map(fn {{row, col}, v} ->
      0..4
      |> Enum.map(
        &{{row + offset * &1, col},
         if (v = v + &1) > 9 do
           v - 9
         else
           v
         end}
      )
    end)
    |> List.flatten()
    |> Enum.map(fn {{row, col}, v} ->
      0..4
      |> Enum.map(
        &{{row, col + offset * &1},
         if (v = v + &1) > 9 do
           v - 9
         else
           v
         end}
      )
    end)
    |> List.flatten()
    |> Map.new()
    |> solve1()
  end

  def parse_input(list \\ input()) do
    for {line, y} <- Enum.with_index(list),
        {val, x} <- Enum.with_index(String.to_charlist(line)),
        into: %{} do
      {{x, y}, val - ?0}
    end
  end
end
