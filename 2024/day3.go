package main

import (
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
	"strings"
)

var mulRegex *regexp.Regexp

func init() {
	mulRegex = regexp.MustCompile(`mul\((\d+),(\d+)\)`)
}

func main() {
	file, err := os.ReadFile("day3.txt")
	if err != nil {
		log.Fatal(err)
	}
	input := string(file)

	sumOfProducts := processMuls(input)

	conditionalSumOfProducts := 0
	doParts := strings.Split(input, "do()")
	for _, dos := range doParts {
		underConsideration := strings.Split(dos, "don't()")[0]
		conditionalSumOfProducts += processMuls(underConsideration)
	}

	fmt.Println("Part 1:", sumOfProducts)
	fmt.Println("Part 2:", conditionalSumOfProducts)
}

func processMuls(text string) int {
	sumOfProducts := 0
	muls := mulRegex.FindAllStringSubmatch(text, -1)
	for _, mul := range muls {
		a, err := strconv.Atoi(mul[1])
		if err != nil {
			log.Fatal(err)
		}
		b, err := strconv.Atoi(mul[2])
		if err != nil {
			log.Fatal(err)
		}

		sumOfProducts += a * b
	}
	return sumOfProducts
}
