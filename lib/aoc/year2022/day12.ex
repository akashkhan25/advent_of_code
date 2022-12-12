defmodule AOC.Year2022.Day12 do
  use AOC, day: 12

  @directions for x <- -1..1, y <- -1..1, x != y and x + y != 0, do: {x, y}

  def part1(list \\ input()) do
    {grid, graph, {start, finish}} = parse_input(list)

    grid
    |> Enum.reduce(graph, &build_graph_edges(&1, &2, grid))
    |> Graph.get_shortest_path(start, finish)
    |> length()
    |> Kernel.-(1)
  end

  def part2(list \\ input()) do
    {grid, graph, {_, finish}} = parse_input(list)

    edge_graph = Enum.reduce(grid, graph, &build_graph_edges(&1, &2, grid))

    Graph.vertices(edge_graph)
    |> Enum.filter(fn  {x, y} -> grid[{x, y}] == 0 end)
    |> Enum.map(&Graph.get_shortest_path(edge_graph, &1, finish))
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&length/1)
    |> Enum.min
    |> Kernel.-(1)
  end

  def parse_input(list \\ input()) do
    lines = Enum.map(list, &String.to_charlist/1)

    for {line, y} <- Enum.with_index(lines),
        {val, x} <- Enum.with_index(line),
      reduce: {%{}, Graph.new(), {0 , 0}} do
      {grid, graph, {start, finish}} ->
          {graph, node_val, {s, e}} =
          case val do
            ?S -> {Graph.add_vertex(graph, {x, y}, label: :start), 0, {{x, y}, finish}}
            ?E -> {Graph.add_vertex(graph, {x, y}, label: :end), 25, {start, {x, y}}}
            other -> {Graph.add_vertex(graph, {x, y}), other - ?a, {start, finish}}
          end

        {Map.put(grid, {x, y}, node_val), graph, {s, e}}
    end
  end

  def build_graph_edges({{x, y}, val}, graph, grid) do
    for {dx, dy} <- @directions, grid[{x + dx, y + dy}] != nil, reduce: graph do
      g ->
        if grid[{x + dx, y + dy}] - val <= 1 do
          Graph.add_edge(g, {x, y}, {x + dx, y + dy})
        else
          g
        end
    end
  end
end
