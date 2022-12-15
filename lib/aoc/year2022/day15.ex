defmodule AOC.Year2022.Day15 do
  use AOC, day: 15

  def part1(list \\ input(), y \\ 2_000_000) do
    coords = parse_input(list)

    beacons_on_line =
      coords
      |> Enum.filter(fn {_, {{_, by}, _}} -> by == y end)
      |> Enum.uniq_by(fn {_, {b, _}} -> b end)
      |> Enum.count()

    coords
    |> locate(y)
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
    |> Kernel.-(beacons_on_line)
  end

  def part2(list \\ input(), limit \\ 4_000_000) do
    scanners =
      list
      |> parse_input()
      |> Enum.map(fn {s, {_, d}} -> {s, d} end)
      |> Map.new()
      |> IO.inspect()

    [x_int, y_int] =
      Enum.reduce(scanners, [MapSet.new(), MapSet.new()], fn {{sx, sy}, d}, [a, b] ->
        a = MapSet.put(a, sy - sx + d + 1)
        a = MapSet.put(a, sy - sx - d - 1)
        b = MapSet.put(b, sx + sy + d + 1)
        b = MapSet.put(b, sx + sy - d - 1)
        [a, b]
      end)

    for x <- x_int,
        y <- y_int,
        div(y - x, 2) > 0 and div(y - x, 2) < limit and div(y + x, 2) > 0 and
          div(y + x, 2) < limit,
        reduce: 0 do
      acc ->
        dx = div(y - x, 2)
        dy = div(y + x, 2)

        if Enum.all?(scanners, fn {{sx, sy}, d} ->
             manhatten_distance([sx, sy], [dx, dy]) > d
           end) do
          4_000_000 * dx + dy
        else
          acc
        end
    end
  end

  def locate(coords, y) do
    coords
    |> Enum.map(&find_beaconless_range(&1, y))
    |> Enum.reject(&is_nil/1)
    |> Enum.reduce([], &union_range/2)
  end

  def union_range(x, current_ranges) do
    {disjoint, common} = Enum.split_with(current_ranges, &Range.disjoint?(&1, x))
    merged = Enum.reduce(common, x, &merge_range/2)
    [merged | disjoint]
  end

  def merge_range(x1..x2, y1..y2) do
    Enum.min([x1, y1])..Enum.max([x2, y2])
  end

  # every point can be beacon
  def find_beaconless_range({{_, sy}, {{_, y}, dist}}, y) when dist > abs(sy - y) do
    nil
  end

  def find_beaconless_range({{sx, sy}, {{bx, by}, dist}}, y) do
    min_x = -abs(dist - abs(y - sy)) + sx
    max_x = abs(dist - abs(y - sy)) + sx

    Range.new(min_x, max_x)
  end

  def manhatten_distance([x1, y1], [x2, y2]) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def bounding_box(coords) do
    {x_min, x_max} =
      coords
      |> Enum.flat_map(fn {{sx, _}, {{bx, _}, _}} -> [sx, bx] end)
      |> Enum.min_max()

    {y_min, y_max} =
      coords
      |> Enum.flat_map(fn {{_, sy}, {{_, by}, _}} -> [sy, by] end)
      |> Enum.min_max()

    {x_min, x_max, y_min, y_max}
  end

  def parse_input(list \\ input()) do
    list
    |> Enum.flat_map(&String.split(&1, ": ", trim: true))
    |> Enum.map(&String.split(&1, "=", trim: true))
    |> Enum.map(&parse_line/1)
    |> Enum.chunk_every(2)
    |> Enum.map(fn [[sx, sy] = s, [bx, by] = b] ->
      {{sx, sy}, {{bx, by}, manhatten_distance(s, b)}}
    end)
  end

  def parse_line(line) do
    line
    |> Enum.map(&Integer.parse/1)
    |> Enum.reject(&(&1 == :error))
    |> Enum.map(&elem(&1, 0))
  end
end
