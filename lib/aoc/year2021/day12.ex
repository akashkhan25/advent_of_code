defmodule AOC.Year2021.Day12 do
  use AOC, day: 12

  def part1(list \\ input()) do
    list
    |> parse_input()
    |> paths("start", ["start"], MapSet.new(["start"]))
    |> length()
  end

  def part2(list \\ input()) do
    list
    |> parse_input()
    |> paths("start", ["start"], MapSet.new(), MapSet.new())
    |> length()
  end

  # TODO: Clean up this mess
  def paths(graph, x, path, seen) do
    graph[x]
    |> Enum.reject(&MapSet.member?(seen, &1))
    |> Enum.flat_map(fn
      "end" -> [["end" | path]]
      x -> paths(graph, x, [x | path], if(lower?(x), do: MapSet.put(seen, x), else: seen))
    end)
  end

  def paths(graph, x, path, once, twice) do
    graph[x]
    |> Enum.filter(fn x ->
      if MapSet.size(twice) == 0 do
        true
      else
        !MapSet.member?(once, x) && !MapSet.member?(twice, x)
      end
    end)
    |> Enum.flat_map(fn
      "start" ->
        []

      "end" ->
        [["end" | path]]

      x ->
        if lower?(x) do
          if MapSet.member?(once, x) do
            paths(graph, x, [x | path], once, MapSet.new([x]))
          else
            paths(graph, x, [x | path], MapSet.put(once, x), twice)
          end
        else
          paths(graph, x, [x | path], once, twice)
        end
    end)
  end

  def lower?(s), do: s == String.downcase(s, :ascii)

  def parse_input(list \\ input()) do
    list
    |> Enum.map(&String.split(&1, "-", trim: true))
    |> Enum.reduce(%{}, fn [k, v], acc ->
      acc
      |> Map.update(k, [v], fn l -> [v | l] end)
      |> Map.update(v, [k], fn l -> [k | l] end)
    end)
  end
end
