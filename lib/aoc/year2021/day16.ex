defmodule AOC.Year2021.Day16 do
  use AOC, day: 16

  def part1(list \\ input()) do
    list
    |> parse_input()
    |> packet()
    |> elem(2)
  end

  def part2(list \\ input()) do
    list
    |> parse_input()
    |> packet()
    |> elem(1)
  end

  def literal(<<0::1, x::size(4), r::bitstring>>, acc, v), do: {r, acc * 16 + x, v}

  def literal(<<1::1, x::size(4), r::bitstring>>, acc, v), do: literal(r, acc * 16 + x, v)

  def pkts(<<>>, l, s, c), do: {c, l, s}

  def pkts(<<b::bitstring>>, l, s, c),
    do: packet(b) |> (fn {r, a, v} -> pkts(r, [a | l], s + v, c) end).()

  def pktl(b, l, 0, s), do: {b, l, s}
  def pktl(b, l, n, s), do: packet(b) |> (fn {r, a, v} -> pktl(r, [a | l], n - 1, s + v) end).()

  def eval({r, l, v}, 0), do: {r, Enum.sum(l), v}
  def eval({r, l, v}, 1), do: {r, Enum.product(l), v}
  def eval({r, l, v}, 2), do: {r, Enum.min(l), v}
  def eval({r, l, v}, 3), do: {r, Enum.max(l), v}
  def eval({r, [b, a], v}, 5), do: {r, if(a > b, do: 1, else: 0), v}
  def eval({r, [b, a], v}, 6), do: {r, if(a < b, do: 1, else: 0), v}
  def eval({r, [b, a], v}, 7), do: {r, if(a == b, do: 1, else: 0), v}

  def packet(<<v::size(3), t::size(3), r::bitstring>>) when t == 4, do: literal(r, 0, v)

  def packet(<<v::size(3), t::size(3), 1::1, len::size(11), r::bitstring>>) do
    eval(pktl(r, [], len, v), t)
  end

  def packet(<<v::size(3), t::size(3), 0::1, len::size(15), sp::size(len), rr::bitstring>>) do
    eval(pkts(<<sp::size(len)>>, [], v, rr), t)
  end

  def parse_input([list] \\ input()) do
    list
    |> hex2bin()
  end

  def hex2bin(<<>>), do: <<>>

  def hex2bin(<<a::size(8), b::size(8), rest::binary>>) do
    <<a, b>>
    |> Integer.parse(16)
    |> elem(0)
    |> :binary.encode_unsigned()
    |> Kernel.<>(hex2bin(rest))
  end
end
