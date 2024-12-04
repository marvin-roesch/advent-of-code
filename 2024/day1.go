package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
	"sort"
	"strconv"
)

func main() {
	file, err := os.Open("day1.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	var left, right []int
	rightCounts := make(map[int]int)
	re := regexp.MustCompile(`^(\d+)\s+(\d+)$`)

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		matches := re.FindStringSubmatch(scanner.Text())
		leftNum, err := strconv.Atoi(matches[1])
		if err != nil {
			log.Fatal(err)
		}

		rightNum, err := strconv.Atoi(matches[2])
		if err != nil {
			log.Fatal(err)
		}

		left = append(left, leftNum)
		right = append(right, rightNum)

		rightCounts[rightNum] += 1
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	sort.Ints(left)
	sort.Ints(right)

	diffSum := 0
	for i, v := range left {
		diff := v - right[i]
		if diff < 0 {
			diff = -diff
		}
		diffSum += diff
	}
	fmt.Println("Part 1:", diffSum)

	similarity := 0
	for _, v := range left {
		similarity += v * rightCounts[v]
	}
	fmt.Println("Part 2:", similarity)
}
