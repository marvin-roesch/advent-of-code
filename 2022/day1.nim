import std/algorithm
import std/strutils
import std/strformat
import std/sequtils
import std/sugar

let input = readFile("day1.txt")
let parsed = collect:
    for group in input.split("\n\n"):
        collect:
            for line in group.split("\n"):
                if line.len() > 0:
                    parseInt(line)
let sums = parsed.mapIt(it.foldl(a + b))

echo fmt"Part 1: {sums.max()}"
echo fmt"Part 2: {sums.sorted(SortOrder.Descending)[0..2].foldl(a + b)}"
