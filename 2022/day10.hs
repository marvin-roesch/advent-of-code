parse ["noop"] = [0]
parse ["addx", value] = [0, read value :: Integer]

runCycle (pc, acc) value = (pc + 1, acc + value)

checkPixel (cycle, x) = abs (((cycle - 1) `mod` 40) - x) <= 1

main = do
  content <- readFile "day10.txt"
  let instructions = concatMap (parse . words) $ lines content
  let states = scanl runCycle (1, 1) instructions
  let part1Cycles = filter (flip elem [20, 60, 100, 140, 180, 220] . fst) states
  let part1Result = sum $ map (uncurry (*)) part1Cycles
  print part1Result

  let part2Result = map checkPixel states
  let characters = [[if part2Result!!(y * 40 + x) then '#' else '.' | x <- [0 .. 39]] | y <- [0 .. 5]]
  mapM putStrLn characters
