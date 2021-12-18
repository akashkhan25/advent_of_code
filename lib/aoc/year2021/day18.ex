defmodule AOC.Year2021.Day18 do
  use AOC, day: 18

  def part1(list \\ input()) do
    list
    |> parse_input()
    |> Enum.reduce(&add/2)
    |> magnitude()
  end

  def part2(list \\ input()) do
    input = parse_input(list)

    for list1 <- input, list2 <- input, list1 != list2 do
      list1
      |> add(list2)
      |> magnitude()
    end
    |> Enum.max()
  end

  def add(list, acc) do
    do_add([acc, list])
  end

  def do_add(list) do
    with ^list <- explode_if_needed(list),
         ^list <- split_if_needed(list) do
      list
    else
      result -> do_add(result)
    end
  end

  def explode_if_needed(list) do
    case do_explode(list, 0) do
      {_, result, _} -> result
      _ -> list
    end
  end

  def split_if_needed(val) when is_integer(val) and val >= 10 do
    ans = val / 2
    [floor(ans), ceil(ans)]
  end

  def split_if_needed([head | tail]) do
    case split_if_needed(head) do
      ^head -> [head | split_if_needed(tail)]
      result -> [result | tail]
    end
  end

  def split_if_needed(val), do: val

  def do_explode([v1, v2], 4), do: {v1, 0, v2}

  def do_explode([v1, v2], depth) do
    cond do
      l = do_explode(v1, depth + 1) ->
        {left, val, right} = l
        {left, [val, merge(right, v2)], 0}

      l = do_explode(v2, depth + 1) ->
        {left, val, right} = l
        {0, [merge(v1, left), val], right}

      true ->
        nil
    end
  end

  def do_explode(_, _), do: false

  def merge([v1, v2], val), do: [v1, merge(v2, val)]
  def merge(val, [v1, v2]), do: [merge(val, v1), v2]
  def merge(v1, v2), do: v1 + v2

  def magnitude(v1) when not is_list(v1), do: v1

  def magnitude([v1, v2]) do
    3 * magnitude(v1) + 2 * magnitude(v2)
  end

  def magnitude([head | tail]) do
    magnitude(head) + magnitude(tail)
  end

  def parse_input(list \\ input()) do
    list
    |> Enum.reduce([], fn line, acc -> [elem(Code.eval_string(line), 0) | acc] end)
    |> Enum.reverse()
  end
end
