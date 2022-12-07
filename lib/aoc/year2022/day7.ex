defmodule AOC.Year2022.Day7 do
  use AOC, day: 7

  def part1(name \\ :input) do
    name
    |> parse_input()
    |> Enum.filter(fn {_, v} -> v < 100_000 end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part2(name \\ :input) do
    size_map = parse_input(name)
    used = Map.get(size_map, ["/"])

    free = 70_000_000 - used
    required = 30_000_000 - free

    size_map
    |> Enum.filter(fn {_, v} -> v >= required end)
    |> Enum.sort_by(&elem(&1, 1))
    |> hd()
    |> elem(1)
  end

  def parse_input(name \\ :input) do
    files =
      name
      |> raw_input()
      |> String.split(["$ ls", "\n"], trim: true)
      |> Enum.reduce({%{}, []}, &parse_line/2)
      |> elem(0)

    Enum.reduce(files, %{}, &calc_dir_size(&1, &2, files))
  end

  def parse_line("$ cd ..", {tree, [_ | tail]}) do
    {tree, tail}
  end

  def parse_line("$ cd " <> dir_name, {tree, current_path}) do
    {tree, [dir_name | current_path]}
  end

  def parse_line("dir " <> dir_name, {tree, current_path}) do
    tree = Map.update(tree, current_path, [dir_name], fn list -> [dir_name | list] end)

    {tree, current_path}
  end

  def parse_line(filename, {tree, current_path}) do
    {size, name} =
      filename
      |> String.split(" ")
      |> then(fn [a, b] -> {String.to_integer(a), b} end)

    tree = Map.update(tree, current_path, [{size, name}], fn list -> [{size, name} | list] end)

    {tree, current_path}
  end

  def calc_dir_size({path, items}, size_map, files) do
    items
    |> Enum.reduce(size_map, fn
      {size, _}, acc ->
        Map.update(acc, path, size, &(&1 + size))

      dir, acc ->
        dir_size = dir_size([dir | path], files, acc)
        Map.update(acc, path, dir_size, &(&1 + dir_size))
    end)
  end

  def dir_size(dir_path, _, size_map) when is_map_key(size_map, dir_path) do
    Map.get(size_map, dir_path)
  end

  def dir_size(dir_path, files_map, size_map) do
    files_map
    |> Map.get(dir_path)
    |> Enum.reduce(0, fn
      {size, _}, acc -> acc + size
      child_dir, acc -> acc + dir_size([child_dir | dir_path], files_map, size_map)
    end)
  end
end
