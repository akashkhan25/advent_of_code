defmodule AOC.Year2022.Day20 do
  use AOC, day: 20

  def part1(list \\ input()) do
    list
    |> parse_input()
    |> Enum.with_index()
    |> :queue.from_list()
    |> mix()
    |> :queue.to_list()
    |> grove_sum()
  end

  def part2(list \\ input()) do
    key = 811_589_153

    list
    |> parse_input()
    |> Enum.map(&(&1 * key))
    |> Enum.with_index()
    |> :queue.from_list()
    |> mix(10)
    |> :queue.to_list()
    |> grove_sum()
  end

  def grove_sum(list) do
    size = length(list)
    zero_idx = Enum.find_index(list, fn {val, _} -> val == 0 end)

    [1000, 2000, 3000]
    |> Enum.map(fn x -> Integer.mod(x + zero_idx, size) end)
    |> Enum.map(&Enum.at(list, &1))
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end

  def move(queue, val) do
    idx = queue |> :queue.to_list() |> Enum.find_index(fn i -> i == val end)
    queue = shift(queue, -idx)
    {{:value, {to_shift, _} = value}, queue} = :queue.out(queue)

    queue = shift(queue, -Integer.mod(to_shift, :queue.len(queue)))
    :queue.in_r(value, queue)
  end

  def mix(queue, rounds \\ 1) do
    iter_q = :queue.to_list(queue)

    for r <- 1..rounds, reduce: queue do
      queue ->
        IO.inspect("Round #{r}")

        for val <- iter_q, reduce: queue do
          acc ->
            move(acc, val)
        end
    end
  end

  def shift(queue, n) when n >= 0 do
    {q1, q2} = :queue.split(n, queue)
    :queue.join(q2, q1)
  end

  def shift(queue, n) when n < 0 do
    shift(queue, -n)
  end

  def parse_input(list \\ input()) do
    Enum.map(list, &String.to_integer/1)
  end
end
