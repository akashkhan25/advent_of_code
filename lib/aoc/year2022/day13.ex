defmodule AOC.Year2022.Day13 do
  use AOC, day: 13

  def part1(name \\ :input) do
    name
    |> parse_input()
    |> Enum.with_index(1)
    |> Enum.filter(&(get_ordering(&1) == :lt))
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part2(name \\ :input) do
    packets =
      name
      |> parse_input()
      |> Enum.flat_map(& &1)

    [a, b | _] = final = [[[2]], [[6]] | packets]

    final
    |> Enum.sort(fn x, y -> get_ordering({[x, y], nil}) == :lt end)
    |> Enum.with_index(1)
    |> Enum.filter(fn {l, _} -> l in [a, b] end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.product()
  end

  def get_ordering({[a, b], _idx}) when is_integer(a) and is_integer(b) do
    cond do
      a < b -> :lt
      a > b -> :gt
      true -> :eq
    end
  end

  def get_ordering({[[], []], _idx}), do: :eq
  def get_ordering({[[], _b], _idx}), do: :lt
  def get_ordering({[_a, []], _idx}), do: :gt

  def get_ordering({[a, b], _idx}) when is_list(a) and is_list(b) do
    do_get_ordering(a, b)
  end

  # list / int
  def get_ordering({[a, b], idx}) when is_integer(b) do
    get_ordering({[a, [b]], idx})
  end

  # int /list
  def get_ordering({[a, b], idx}) when is_integer(a) do
    get_ordering({[[a], b], idx})
  end

  def do_get_ordering([h1 | t1], [h1 | t2]) do
    get_ordering({[t1, t2], nil})
  end

  def do_get_ordering([h1 | t1], [h2 | t2]) do
    case get_ordering({[h1, h2], nil}) do
      :eq -> get_ordering({[t1, t2], nil})
      val -> val
    end
  end

  def parse_input(name \\ :input) do
    name
    |> raw_input()
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&String.split(&1, "\n", trim: true))
    |> Enum.map(&Code.eval_string/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.chunk_every(2)
  end
end
