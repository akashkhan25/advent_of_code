defmodule AOC.Year2021.Day19 do
  use AOC, day: 19

  defmodule Scanner do
    defstruct [:num, :beacons]

    def new(), do: %Scanner{beacons: MapSet.new()}

    def put_beacon(%Scanner{beacons: beacons} = scanner, beacon) do
      %{scanner | beacons: MapSet.put(beacons, beacon)}
    end
  end

  def part1(list \\ :input) do
    {_, scanner_map, coords_map} = locate_scanner_coords(parse_input(list))
    scanner_map = Enum.map(scanner_map, &absolute_coords(&1, scanner_map))

    coords_map
    |> Enum.map(fn {scanner_num, relative_coords} ->
      Enum.map(relative_coords, &subtract(&1, scanner_map[scanner_num]))
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2(list \\ :input) do
    {_, scanner_map, _} = locate_scanner_coords(parse_input(list))
    scanner_map = Enum.map(scanner_map, &absolute_coords(&1, scanner_map))

    for {num1, point1} <- scanner_map, {num2, point2} <- scanner_map, num1 != num2 do
      manhattan(point1, point2)
    end
    |> Enum.max()
  end

  def locate_scanner_coords(input) do
    [%{beacons: init_beacons} | _] = input

    for %{num: num1} = scanner1 <- input,
        reduce: {[0], %{0 => {0, [0, 0, 0]}}, %{0 => init_beacons}} do
      {matched, scanners, beacons} ->
        for %{num: num2} = scanner2 <- input,
            scanner2 != scanner1,
            num2 not in matched,
            reduce: {matched, scanners, beacons} do
          {matched, scanners, beacons} ->
            common = common_points(scanner1, scanner2)

            if common == [] do
              {matched, scanners, beacons}
            else
              [{real_points, scanner_coord}] = common

              {[num2 | matched], Map.put(scanners, num2, {num1, scanner_coord}),
               Map.update(beacons, num1, real_points, &MapSet.union(&1, real_points))}
            end
        end
    end
  end

  def absolute_coords({scanner_num, {0, coords}}, _scanner_map) do
    {scanner_num, coords}
  end

  def absolute_coords({scanner_num, {other_num, coords}}, scanner_map) do
    subtract(coords, absolute_coords({scanner_num, scanner_map[other_num]}, scanner_map))
  end

  def manhattan([x1, y1, z1], [x2, y2, z2]) do
    abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)
  end

  def cos(angle) when angle in [90, 270], do: 0
  def cos(0), do: 1
  def cos(180), do: -1

  def sin(angle) when angle in [0, 180], do: 0
  def sin(90), do: 1
  def sin(270), do: -1

  def rotate_z([x, y, z], angle) do
    [
      [cos(angle), -sin(angle), 0],
      [sin(angle), cos(angle), 0],
      [0, 0, 1]
    ]
    |> Nx.tensor()
    |> Nx.dot(Nx.tensor([[x], [y], [z]]))
    |> Nx.to_flat_list()
  end

  def rotate_x([x, y, z], angle) do
    [
      [1, 0, 0],
      [0, cos(angle), -sin(angle)],
      [0, sin(angle), cos(angle)]
    ]
    |> Nx.tensor()
    |> Nx.dot(Nx.tensor([[x], [y], [z]]))
    |> Nx.to_flat_list()
  end

  def rotate_y([x, y, z], angle) do
    [
      [cos(angle), 0, sin(angle)],
      [0, 1, 0],
      [-sin(angle), 0, cos(angle)]
    ]
    |> Nx.tensor()
    |> Nx.dot(Nx.tensor([[x], [y], [z]]))
    |> Nx.to_flat_list()
  end

  def rotate(rx, ry, rz) do
    fn point ->
      point
      |> rotate_x(rx)
      |> rotate_y(ry)
      |> rotate_z(rz)
    end
  end

  def rotations() do
    [
      rotate(0, 0, 0),
      rotate(90, 0, 0),
      rotate(180, 0, 0),
      rotate(270, 0, 0),
      rotate(0, 90, 0),
      rotate(90, 90, 0),
      rotate(180, 90, 0),
      rotate(270, 90, 0),
      rotate(0, 180, 0),
      rotate(90, 180, 0),
      rotate(180, 180, 0),
      rotate(270, 180, 0),
      rotate(0, 270, 0),
      rotate(90, 270, 0),
      rotate(180, 270, 0),
      rotate(270, 270, 0),
      rotate(0, 0, 90),
      rotate(90, 0, 90),
      rotate(180, 0, 90),
      rotate(270, 0, 90),
      rotate(0, 0, 270),
      rotate(90, 0, 270),
      rotate(180, 0, 270),
      rotate(270, 0, 270)
    ]
  end

  def bases() do
    rotations()
    |> Enum.map(fn f -> [f.([1, 0, 0]), f.([0, 1, 0]), f.([0, 0, 1])] end)
  end

  def transform([x, y, z], basis) do
    basis
    |> Nx.tensor()
    |> Nx.dot(Nx.tensor([[x], [y], [z]]))
    |> Nx.to_flat_list()
  end

  def add(point_a, point_b) do
    point_a
    |> Nx.tensor()
    |> Nx.add(Nx.tensor(point_b))
    |> Nx.to_flat_list()
  end

  def subtract(point_a, point_b) do
    point_a
    |> Nx.tensor()
    |> Nx.subtract(Nx.tensor(point_b))
    |> Nx.to_flat_list()
  end

  def common_points(%Scanner{beacons: b1}, %Scanner{beacons: b2}) do
    bases()
    |> Enum.reduce([], fn base, acc ->
      # Transform s2 to standard basis
      new_beacons = Enum.map(b2, &transform(&1, base))

      for p1 <- b1, p2 <- new_beacons, reduce: acc do
        acc ->
          dist = subtract(p1, p2)
          new_dist = Enum.map(new_beacons, &add(&1, dist)) |> MapSet.new()

          if MapSet.size(MapSet.intersection(b1, new_dist)) >= 12,
            do: [{new_dist, dist} | acc],
            else: acc
      end
    end)
    |> Enum.uniq()
  end

  def parse_input(list \\ :input) do
    list
    |> raw_input()
    |> String.split("\n\n")
    |> Enum.reduce([], fn scanner, acc -> [build_scanner(scanner) | acc] end)
    |> Enum.reverse()
  end

  def build_scanner(scanner_input) do
    scanner_input
    |> String.split("\n")
    |> Enum.reduce(
      Scanner.new(),
      fn
        "--- scanner " <> rest, scanner ->
          [num | _] = String.split(rest, " ---")
          %{scanner | num: String.to_integer(num)}

        line, scanner ->
          coords = String.split(line, ",", trim: true) |> Enum.map(&String.to_integer/1)
          Scanner.put_beacon(scanner, coords)
      end
    )
  end
end
