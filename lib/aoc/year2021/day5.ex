defmodule AOC.Year2021.Day5 do
  use AOC, day: 5

  def part1(list \\ input()) do
    parse_input(list)
    |> Enum.filter(&same_xy?/1)
    |> check_intersections([])
    |> calculate_score()
  end

  def part2(list \\ input()) do
    parse_input(list)
    |> check_intersections([])
    |> calculate_score()
  end

  def parse_input(list \\ input()) do
    list
    |> Enum.map(&String.split(&1, " -> ", trim: true))
    |> Enum.map(&to_coords/1)
  end

  defp calculate_score(list) do
    list
    |> Enum.frequencies()
    |> Enum.filter(fn {{_, _}, val} -> val >= 2 end)
    |> length
  end

  defp same_xy?([[x1, _], [x1, _]]), do: true
  defp same_xy?([[_, y1], [_, y1]]), do: true
  defp same_xy?(_), do: false

  defp check_intersections([], intersections), do: intersections

  defp check_intersections([[[x1, y1], [x1, y2]] | tail], intersections) do
    intersections =
      for y <- y1..y2, reduce: intersections do
        acc -> [{x1, y} | acc]
      end

    check_intersections(tail, intersections)
  end

  defp check_intersections([[[x1, y1], [x2, y1]] | tail], intersections) do
    intersections =
      for x <- x1..x2, reduce: intersections do
        acc -> [{x, y1} | acc]
      end

    check_intersections(tail, intersections)
  end

  defp check_intersections([[[x1, y1], [x2, y2]] | tail], intersections) do
    check_intersections(tail, intersections ++ Enum.zip(x1..x2, y1..y2))
  end

  defp to_coords(points) do
    points
    |> Enum.map(&parse_coords/1)
  end

  defp parse_coords(point) do
    point
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
