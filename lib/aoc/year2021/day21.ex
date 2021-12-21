defmodule AOC.Year2021.Day21 do
  use AOC, day: 21

  def part1(list \\ input) do
    {p1, p2} = parse_input(list)

    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while({{p1, p2}, {0, 0},  0}, &update_score/2)
  end

  def update_score(_turn, {{_, _}, {s1, s2}, _} = result) when s1 >= 1000 or s2 >= 1000 do
    {:halt, result}
  end

  def update_score(turn, {{p1, p2}, {s1, s2}, count} = state) do
    IO.inspect( state, label: turn)
    turn = Integer.mod(turn, 100)

    {r1, r2} =
      (6 * (turn - 1) + 1)..(6 * turn)
      |> Enum.split(3)
      |> IO.inspect(charlists: false)
      |> then(fn {x, y} -> {Enum.sum(x), Enum.sum(y)} end)
      |> IO.inspect(label: :rolls)

    score1 = Integer.mod(p1 + r1, 10)
    score2 = Integer.mod(p2 + r2, 10)
    p1 = if score1 == 0, do: 10, else: score1
    p2 = if score2 == 0, do: 10, else: score2
    {:cont, {{p1, p2}, {s1 + p1, s2 + p2}, count + 1}}
  end

  def parse_input(list \\ input()) do
    list
    |> Enum.map(fn
      "Player 1 starting position: " <> val -> String.to_integer(val)
      "Player 2 starting position: " <> val -> String.to_integer(val)
    end)
    |> List.to_tuple()
  end
end
