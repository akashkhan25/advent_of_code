defmodule AOC.Year2022.Day14 do
  use AOC, day: 14
  @source {500, 0}

  def part1(list \\ input(), stop_turn \\ -1) do
    rocks = parse_input(list)

    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while({rocks, MapSet.new()}, &can_drop(&1, &2, stop_turn))
  end

  def part2(list \\ input(), stop_turn \\ -1, y_max \\ 163) do
    rocks = parse_input(["-1000,#{y_max} -> 1000,#{y_max}" | list])

    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while({rocks, MapSet.new()}, &can_drop(&1, &2, stop_turn))
  end

  # TODO: Clean up this mess
  def can_drop(turn, {rocks, sand}, stop_turn) do
    point =
      rocks
      |> MapSet.union(sand)
      |> destination()

    cond do
      point == [] -> {:halt, turn - 1}
      outside_box?(hd(point), rocks) -> {:halt, turn - 1}
      Enum.any?(choices(hd(point)), &outside_box?(&1, rocks)) -> {:halt, turn - 1}
      turn == stop_turn -> {:halt, {rocks, sand}}
      stop_turn == -1 -> {:cont, {rocks, MapSet.put(sand, hd(point))}}
    end
  end

  def destination({rock, sand}) do
    rock
    |> MapSet.union(sand)
    |> destination()
  end

  def destination(fixed_points) do
    @source
    |> Stream.iterate(&next_coord(&1, fixed_points))
    |> Stream.take_while(fn
      {x, y} ->
        !MapSet.member?(fixed_points, {x, y}) and !outside_box?({x, y}, fixed_points)

      nil ->
        false
    end)
    |> Enum.reverse()
  end

  def next_coord(nil, _), do: nil

  def next_coord({x, y}, fixed_points) do
    {x, y}
    |> choices()
    |> Enum.find(&(outside_box?(&1, fixed_points) or !MapSet.member?(fixed_points, &1)))
  end

  def choices({x, y}) do
    [{x, y + 1}, {x - 1, y + 1}, {x + 1, y + 1}]
  end

  def outside_box?({x, y}, fixed_points) do
    {x_min, _y_min, x_max, y_max} = bounding_box(fixed_points)
    x < x_min or x > x_max or y > y_max
  end

  def bounding_box(coords) do
    {{x_min, _}, {x_max, _}} = Enum.min_max_by(coords, &elem(&1, 0))
    {{_, y_min}, {_, y_max}} = Enum.min_max_by(coords, &elem(&1, 1))
    {x_min, y_min, x_max, y_max}
  end

  def parse_input(list \\ input()) do
    list
    |> Enum.map(&String.split(&1, " -> ", trim: true))
    |> Enum.map(&transform_coords/1)
    |> Enum.reduce(MapSet.new(), &enumerate_coords/2)
  end

  def transform_coords(list) do
    list
    |> Enum.map(fn s -> "{#{s}}" end)
    |> Enum.map(&Code.eval_string/1)
    |> Enum.map(&elem(&1, 0))
  end

  def enumerate_coords([{x1, y1}, {x2, y2}], acc) do
    for x <- x1..x2, y <- y1..y2, reduce: acc do
      acc -> MapSet.put(acc, {x, y})
    end
  end

  def enumerate_coords([{x1, y1}, {x2, y2} | rest], acc) do
    acc =
      for x <- x1..x2, y <- y1..y2, reduce: acc do
        acc -> MapSet.put(acc, {x, y})
      end

    enumerate_coords([{x2, y2} | rest], acc)
  end

  def draw({rocks, sand}) do
    {x_min, y_min, x_max, y_max} =
      rocks
      |> MapSet.put(@source)
      |> bounding_box()

    for y <- y_min..y_max do
      for x <- x_min..x_max do
        cond do
          {x, y} == @source -> "+"
          MapSet.member?(rocks, {x, y}) -> "#"
          MapSet.member?(sand, {x, y}) -> "o"
          true -> "."
        end
      end
      |> IO.puts()
    end
  end
end
