defmodule AOC.Year2021.Day20 do
  use AOC, day: 20
  import Bitwise

  def part1(list \\ :input) do
    {algo, image} = parse_input(list)

    1..2
    |> Enum.reduce(image, &enhance(&1, &2, algo))
    |> Enum.count(fn {_, v} -> v == 1 end)
  end

  def part2(list \\ :input) do
  {algo, image} = parse_input(list)

    0..49
    |> Enum.reduce(image, &enhance(&1, &2, algo))
    |> Enum.count(fn {_, v} -> v == 1 end)

  end

  def enhance(step, image, algo) do
    all_on? = step &&& algo[0]

    {{min_x, min_y}, {max_x, max_y}} = bounding_box(image)

    for x <- (min_x - 1)..(max_x + 1), y <- (min_y - 1)..(max_y + 1), into: %{} do
      neighbors({x, y})
      |> Enum.map(&Map.get(image, &1, all_on?))
      |> Integer.undigits(2)
      |> then(fn val -> {{x, y}, algo[val]} end)
    end
    |> tap(&print_image/1)
  end

  def neighbors({x, y}) do
    for dx <- -1..1, dy <- -1..1, do: {x + dx, y + dy}
  end

  def bounding_box(image) do
    image
    |> Map.keys()
    |> Enum.min_max()
  end

  def parse_input(list \\ :input) do
    [line, text] =
      list
      |> raw_input()
      |> String.split("\n\n", trim: true)

    algo = build_algorithm(line)
    image = build_image(text)
    {algo, image}
  end

  def build_algorithm(line) do
    line
    |> String.replace("\n", "")
    |> build_binary()
    |> Enum.with_index()
    |> Enum.into(%{}, fn {bit, i} -> {i, bit - ?0} end)
  end

  def build_image(text) do
    lines =
      text
      |> String.split("\n", trim: true)
      |> Enum.map(&build_binary/1)

    for {line, y} <- Enum.with_index(lines), {val, x} <- Enum.with_index(line), into: %{} do
      {{x, y}, val - ?0}
    end
  end

  def build_binary(line) do
    line
    |> String.replace("#", "1")
    |> String.replace(".", "0")
    |> String.to_charlist()
  end

  def print_image(image) do
    {{min_x, min_y}, {max_x, max_y}} = bounding_box(image)

    for y <- min_y-3..max_y+3 do
      for x <- min_x-3..max_x + 3 do
        if image[{x, y}] == 1, do: "#", else: "."
      end
      |> IO.puts()
    end
  end
end
