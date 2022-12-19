defmodule AOC.Year2022.Day19 do
  use AOC, day: 19

  def part1(list \\ input(), limit \\ 24) do
    blueprints = parse_input(list)

    for b <- blueprints, reduce: 0 do
      acc ->
        [num | costs] = b
        (acc + num * simulate_blueprint(costs, limit)) |> IO.inspect()
    end
  end

  def part2(list \\ input(), limit \\ 32) do
    blueprints =
      list
      |> parse_input()
      |> Enum.take(3)

    blueprints
    |> Task.async_stream(fn [_ | costs] -> simulate_blueprint(costs, limit) end,
      timeout: :infinity
    )
    |> Enum.reduce(1, fn {:ok, val}, acc -> val * acc end)
  end

  def simulate_blueprint(costs, limit) do
    mat_q = :queue.new()
    # {t, {o, c, obs, g, r_o, r_c, r_obs, r_g}}
    mat_q = :queue.in({0, {0, 0, 0, 0, 1, 0, 0, 0}}, mat_q)
    max = 0
    seen = MapSet.new()
    do_simulate_blueprint({mat_q, max, seen}, costs, limit)
  end

  def do_simulate_blueprint({mat_q, max, seen}, costs, limit) do
    if :queue.is_empty(mat_q) do
      max
      |> IO.inspect()
    else
      {{:value, {t, {_, _, _, g, _, _, _, _} = counts}}, queue} = :queue.out(mat_q)
      max = max(g, max)

      if t == limit or MapSet.member?(seen, counts) do
        do_simulate_blueprint({queue, max, seen}, costs, limit)
      else
        seen = MapSet.put(seen, counts)
        calculate_queue_counts({mat_q, max, seen}, costs, limit)
      end
    end
  end

  def calculate_queue_counts(
        {mat_q, max, seen},
        [co_o, cc_o, cobs_o, cobs_c, cg_o, cg_obs] = costs,
        limit
      ) do
    {{:value, {t, {o, c, obs, g, r_o, r_c, r_obs, r_g}}}, queue} = :queue.out(mat_q)

    # No way to beat max
    if g + r_g * (limit - t) + div((limit - t) * (limit - t + 1), 2) <= max do
      do_simulate_blueprint({queue, max, seen}, costs, limit)
    else
      # make ore bot
      max_ore = Enum.max([co_o, cc_o, cobs_o, cg_o])

      queue =
        if o >= co_o and r_o < max_ore and o + (limit - t) * r_o < (limit - t) * max_ore do
          :queue.in(
            {t + 1, {o - co_o + r_o, c + r_c, obs + r_obs, g + r_g, r_o + 1, r_c, r_obs, r_g}},
            queue
          )
        else
          queue
        end

      # make clay bot
      queue =
        if o >= cc_o and r_c < cobs_c and c + (limit - t) * r_c < (limit - t) * cobs_c do
          :queue.in(
            {t + 1, {o - cc_o + r_o, c + r_c, obs + r_obs, g + r_g, r_o, r_c + 1, r_obs, r_g}},
            queue
          )
        else
          queue
        end

      # make obs bot
      queue =
        if o >= cobs_o and c >= cobs_c and r_obs < cg_obs and
             obs + (limit - t) * r_obs < (limit - t) * cg_obs do
          :queue.in(
            {t + 1,
             {o - cobs_o + r_o, c - cobs_c + r_c, obs + r_obs, g + r_g, r_o, r_c, r_obs + 1, r_g}},
            queue
          )
        else
          queue
        end

      # make g bot
      queue =
        if o >= cg_o and obs >= cg_obs do
          :queue.in(
            {t + 1,
             {o - cg_o + r_o, c + r_c, obs - cg_obs + r_obs, g + r_g, r_o, r_c, r_obs, r_g + 1}},
            queue
          )
        else
          # do nothing
          :queue.in(
            {t + 1, {o + r_o, c + r_c, obs + r_obs, g + r_g, r_o, r_c, r_obs, r_g}},
            queue
          )
        end

      do_simulate_blueprint({queue, max, seen}, costs, limit)
    end
  end

  def parse_input(list \\ input()) do
    list
    |> Enum.map(&Regex.scan(~r/\d+/, &1))
    |> Enum.map(&Enum.map(&1, fn [l] -> String.to_integer(l) end))
  end
end
