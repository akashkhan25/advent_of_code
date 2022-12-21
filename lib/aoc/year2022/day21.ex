defmodule AOC.Year2022.Day21 do
  use AOC, day: 21

  @operations %{
    "+" => :+,
    "-" => :-,
    "*" => :*,
    "/" => :div
  }

  @key "humn"

  def part1(list \\ input()) do
    list
    |> parse_input()
    |> dfs("root")
    |> eval()
  end

  def part2(list \\ input()) do
    map =
      list
      |> parse_input()
      |> Map.put(@key, Macro.var(:humn, __MODULE__))
      |> Map.update("root", nil, fn {_, [m1, m2]} -> {:=, [m1, m2]} end)

    map
    |> search("root", @key, [])
    |> Enum.reverse()
    |> Enum.map(&map[&1])
    |> Enum.reduce(nil, &try_evaluate(&1, &2, map))
    |> eval()
  end

  def try_evaluate({:=, [arg1, arg2]}, _, map) do
    {_, val} = find_eval_arg(arg1, arg2, map)
    val
  end

  def try_evaluate({:div, [arg1, arg2]}, current_ast, map) do
    case find_eval_arg(arg1, arg2, map) do
      {:first, val} -> {:div, [], [val, current_ast]}
      {:second, val} -> {:*, [], [val, current_ast]}
    end
  end

  def try_evaluate({:*, [arg1, arg2]}, current_ast, map) do
    case find_eval_arg(arg1, arg2, map) do
      {:first, val} -> {:div, [], [current_ast, val]}
      {:second, val} -> {:div, [], [current_ast, val]}
    end
  end

  def try_evaluate({:+, [arg1, arg2]}, current_ast, map) do
    case find_eval_arg(arg1, arg2, map) do
      {:first, val} -> {:-, [], [current_ast, val]}
      {:second, val} -> {:-, [], [current_ast, val]}
    end
  end

  def try_evaluate({:-, [arg1, arg2]}, current_ast, map) do
    case find_eval_arg(arg1, arg2, map) do
      {:first, val} -> {:-, [], [val, current_ast]}
      {:second, val} -> {:+, [], [current_ast, val]}
    end
  end

  def find_eval_arg(arg1, arg2, map) do
    arg2_ast = dfs(map, arg2)
    arg2_expr = Macro.to_string(arg2_ast)

    if String.contains?(arg2_expr, @key) do
      arg1_ast = dfs(map, arg1)
      arg1_val = eval(arg1_ast)
      {:first, arg1_val}
    else
      arg2_val = eval(arg2_ast)
      {:second, arg2_val}
    end
  end

  def eval(ast) do
    ast
    |> Code.eval_quoted()
    |> elem(0)
  end

  def search(_, find, find, path) do
    path
  end

  def search(map, start, find, path) do
    case map[start] do
      {_, [left, right]} ->
        search_path = search(map, left, find, [start | path])

        if search_path == nil do
          search(map, right, find, [start | path])
        else
          search_path
        end

      _ ->
        nil
    end
  end

  def dfs(map, node) do
    case map[node] do
      {_, [_, _]} -> eval_op(map, map[node])
      value -> value
    end
  end

  def eval_op(map, {op, [m1, m2]}) do
    m1_val = dfs(map, m1)
    m2_val = dfs(map, m2)
    {op, [], [m1_val, m2_val]}
  end

  def parse_input(list \\ input()) do
    list
    |> Enum.map(&String.split(&1, ": ", trim: true))
    |> Enum.map(&parse_line/1)
    |> Map.new()
  end

  def parse_line([m1, num_or_op]) do
    case Integer.parse(num_or_op) do
      {num, ""} -> {m1, num}
      :error -> {m1, parse_op(String.split(num_or_op, " ", trim: true))}
    end
  end

  def parse_op([m1, op, m2]) when is_map_key(@operations, op) do
    {@operations[op], [m1, m2]}
  end
end
