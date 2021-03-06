defmodule AOC.Year2021.Day9 do
  use AOC, day: 9
  @offsets [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]

  def part1(list \\ input()) do
    coords = parse_input(list)

    coords
    |> Enum.filter(&low_point?(&1, coords))
    |> Enum.map(fn {_, val} -> val + 1 end)
    |> Enum.sum()
  end

  def part2(list \\ input()) do
    coords = parse_input(list)
    low_points = Enum.filter(coords, &low_point?(&1, coords))

    initial_basins =
      low_points
      |> Enum.map(fn {point, _} -> {point, 0} end)
      |> Enum.into(%{})

    find_basins(coords, low_points, initial_basins)
  end

  def find_basins(coords, low_points, initial_basins) do
    visited = coords |> Enum.map(fn {k, _} -> {k, false} end) |> Enum.into(%{})

    low_points
    |> Enum.reduce({visited, initial_basins}, &visit_next(&1, &2, &1, coords))
    |> elem(1)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def visit_next(
        {{x, y} = point, val},
        {visited, basins},
        {lp_coords, _} = current_lp,
        coords
      ) do
    visited = Map.update(visited, point, nil, fn _ -> true end)
    basins = Map.update(basins, lp_coords, nil, &(&1 + 1))

    for {dx, dy} <- @offsets, reduce: {visited, basins} do
      {visited, basins} ->
        next_point = {x + dx, y + dy}

        if still_in_basin?(val, next_point, visited, coords) do
          visit_next({next_point, coords[next_point]}, {visited, basins}, current_lp, coords)
        else
          {visited, basins}
        end
    end
  end

  def low_point?({{x, y}, val}, coords) do
    Enum.all?(@offsets, fn {dx, dy} -> (coords[{x + dx, y + dy}] || 10) > val end)
  end

  def still_in_basin?(val, next_point, visited, coords) do
    !visited[next_point] && !(coords[next_point] == 9) && (coords[next_point] || -1) >= val
  end

  def parse_input(list \\ input()) do
    list
    |> Enum.map(&parse_line/1)
    |> build_coords_map()
  end

  def parse_line(line) do
    line
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  def build_coords_map(list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {list, y}, acc ->
      list
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {val, x}, acc -> Map.put(acc, {x, y}, val) end)
    end)
  end
end
