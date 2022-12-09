require 'set'

Move = Struct.new(:direction, :units)
Vec2 = Struct.new(:x, :y) do
  def +(other)
    Vec2.new(x + other.x, y + other.y)
  end

  def -(other)
    Vec2.new(x - other.x, y - other.y)
  end
end

input = File.readlines('day9.txt').map do |line|
  line.match(/([UDLR]) (\d+)/) do |m|
    Move.new(
      case m.captures[0]
      when 'U'
        Vec2.new(0, 1)
      when 'D'
        Vec2.new(0, -1)
      when 'L'
        Vec2.new(-1, 0)
      when 'R'
        Vec2.new(1, 0)
      end,
      m.captures[1].to_i
    )
  end
end

def simulate_rope(knots, moves)
  positions = Array.new(knots) { Vec2.new(0, 0) }
  trackedPositions = Array.new(knots) { Set[] }
  moves.each do |move|
    for _ in 1..move.units do
      positions[0] += move.direction
      trackedPositions[0].add(positions[0])

      for i in 1...positions.length do
        diff = positions[i - 1] - positions[i]

        horizontalLag = diff.x.abs == 2 && diff.y == 0
        verticalLag = diff.x == 0 && diff.y.abs == 2
        diagonalLag = diff.x.abs + diff.y.abs > 2

        positions[i] += Vec2.new(diff.x <=> 0, diff.y <=> 0) if horizontalLag || verticalLag || diagonalLag

        trackedPositions[i].add(positions[i])
      end
    end
  end

  trackedPositions
end

part1Result = simulate_rope(2, input)[-1].size
part2Result = simulate_rope(10, input)[-1].size

puts "Part 1: #{part1Result}"
puts "Part 2: #{part2Result}"
