defmodule Day4 do
  def parse_range(r) do
    String.split(r, "-")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)
  end

  def parse_line(line) do
    String.split(line, ",")
      |> Enum.map(&Day4.parse_range/1)
  end

  def contains_range([start1, end1], [start2, end2]) do
    start1 <= start2 and end1 >= end2
  end

  def intersects_range([start1, end1], [start2, end2]) do
    start1 <= end2 and end1 >= start2
  end
end

input = File.stream!("day4.txt")
  |> Enum.map(&Day4.parse_line/1)

part1 = input
  |> Enum.filter(fn ([a, b]) -> Day4.contains_range(a, b) or Day4.contains_range(b, a) end)
  |> Enum.count

IO.puts("Part 1: #{part1}")

part2 = input
  |> Enum.filter(fn ([a, b]) -> Day4.intersects_range(a, b) or Day4.intersects_range(b, a) end)
  |> Enum.count

IO.puts("Part 2: #{part2}")
