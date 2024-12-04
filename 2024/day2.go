package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
)

func main() {
	file, err := os.Open("day2.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	splitterRegex := regexp.MustCompile(`\s+`)
	safeReports := 0
	safeReportsAfterModification := 0

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		parts := splitterRegex.Split(scanner.Text(), -1)
		report := make([]int, len(parts))
		for i, p := range parts {
			report[i], err = strconv.Atoi(p)
			if err != nil {
				log.Fatal(err)
			}
		}

		if len(report) <= 1 {
			safeReports += 1
			continue
		}

		safeAll := checkSafety(report)
		safeWithRemoval := false
		for i := range report {
			var modifiedReport []int
			modifiedReport = append(modifiedReport, report[0:i]...)
			modifiedReport = append(modifiedReport, report[i+1:]...)
			if checkSafety(modifiedReport) {
				safeWithRemoval = true
				break
			}
		}

		if safeAll {
			safeReports += 1
		}
		if safeWithRemoval {
			safeReportsAfterModification += 1
		}
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	fmt.Println("Part 1:", safeReports)
	fmt.Println("Part 2:", safeReportsAfterModification)
}

func signum(num int) int {
	switch {
	case num > 0:
		return 1
	case num < 0:
		return -1
	default:
		return 0
	}
}

func checkSafety(report []int) bool {
	unsafe := false
	order := signum(report[1] - report[0])
	for i := 1; i < len(report); i++ {
		diff := report[i] - report[i-1]
		orderMismatch := signum(diff) != order
		diffTooSmall := diff == 0
		diffTooLarge := diff < -3 || diff > 3

		if orderMismatch || diffTooSmall || diffTooLarge {
			unsafe = true
			break
		}
	}

	return !unsafe
}
