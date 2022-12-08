lines = map(readlines("day8.txt")) do line
    parse.(Int, collect(line))
end
grid = permutedims(hcat(lines...))
rows, cols = axes(grid)

isvisible(row, col) = begin
    maxheight = grid[row, col]
    visiblealong(trees) = all(t -> t < maxheight, trees)

    up = grid[(row-1):-1:begin, col]
    down = grid[(row+1):end, col]
    left = grid[row, (col-1):-1:begin]
    right = grid[row, (col+1):end]
    any(visiblealong.([up, down, left, right]))
end
visibilities = [isvisible(row, col) for row in rows, col in cols]

scenicscore(row, col) = begin
    maxheight = grid[row, col]
    viewingdistance(trees) = begin
        distance, _ = foldl(trees; init=(0, false)) do (dist, ended), t
            if ended
                return dist, true
            end

            if t >= maxheight
                return dist + 1, true
            end

            dist + 1, false
        end

        distance
    end

    up = grid[(row-1):-1:begin, col]
    down = grid[(row+1):end, col]
    left = grid[row, (col-1):-1:begin]
    right = grid[row, (col+1):end]
    prod((*), viewingdistance.([up, down, left, right]))
end
scenicscores = [scenicscore(row, col) for row in rows, col in cols]

println("Part 1: $(sum(visibilities))")
println("Part 1: $(max(scenicscores...))")
