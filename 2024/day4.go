package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
)

func main() {
	file, err := os.Open("day4.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	var grid [][]rune

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		grid = append(grid, []rune(scanner.Text()))
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	xmas := []rune("XMAS")
	xmasBackwards := []rune("SAMX")
	mas := []rune("MAS")
	xmases := 0
	crosses := 0
	for y, row := range grid {
		for x := range row {
			forwardMatches := countStringMatches(grid, x, y, xmas)
			backwardMatches := countStringMatches(grid, x, y, xmasBackwards)
			xmases += forwardMatches + backwardMatches

			if checkCross(grid, x, y, mas) {
				crosses += 1
			}
		}
	}

	fmt.Println("Part 1:", xmases)
	fmt.Println("Part 2:", crosses)
}

func countStringMatches(grid [][]rune, x, y int, string []rune) int {
	if grid[y][x] != string[0] {
		return 0
	}

	result := 0
	if checkHorizontal(grid, x, y, string) {
		result += 1
	}
	if checkVertical(grid, x, y, string) {
		result += 1
	}
	if checkDiagonal(grid, x, y, string) {
		result += 1
	}
	if checkAntiDiagonal(grid, x, y, string) {
		result += 1
	}
	return result
}

func checkHorizontal(grid [][]rune, x, y int, string []rune) bool {
	row := grid[y]
	if x > len(row)-len(string) {
		return false
	}

	for i, letter := range string {
		if row[x+i] != letter {
			return false
		}
	}
	return true
}

func checkVertical(grid [][]rune, x, y int, string []rune) bool {
	if y > len(grid)-len(string) {
		return false
	}

	for i, letter := range string {
		if grid[y+i][x] != letter {
			return false
		}
	}
	return true
}

func checkDiagonal(grid [][]rune, x, y int, string []rune) bool {
	if y > len(grid)-len(string) || x > len(grid[y])-len(string) {
		return false
	}

	for i, letter := range string {
		if grid[y+i][x+i] != letter {
			return false
		}
	}
	return true
}

func checkAntiDiagonal(grid [][]rune, x, y int, string []rune) bool {
	if y > len(grid)-len(string) || x < len(string)-1 {
		return false
	}

	for i, letter := range string {
		if grid[y+i][x-i] != letter {
			return false
		}
	}
	return true
}

func checkCross(grid [][]rune, x, y int, string []rune) bool {
	if y > len(grid)-len(string) || x > len(grid[y])-len(string) {
		return false
	}

	forwardMatchDiagonal := true
	forwardMatchAntiDiagonal := true
	backwardMatchDiagonal := true
	backwardMatchAntiDiagonal := true
	for i := 0; i < len(string); i++ {
		if grid[y+i][x+i] != string[i] {
			forwardMatchDiagonal = false
		}
		if grid[y+i][x+i] != string[len(string)-i-1] {
			backwardMatchDiagonal = false
		}
		if grid[y+i][x+len(string)-i-1] != string[i] {
			forwardMatchAntiDiagonal = false
		}
		if grid[y+i][x+len(string)-i-1] != string[len(string)-i-1] {
			backwardMatchAntiDiagonal = false
		}
	}

	return (forwardMatchDiagonal || backwardMatchDiagonal) && (forwardMatchAntiDiagonal || backwardMatchAntiDiagonal)
}
