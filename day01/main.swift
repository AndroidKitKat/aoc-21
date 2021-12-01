//
//  main.swift
//  day01
//
//  Created by Michael Eisemann on 12/1/21.
//

import Foundation

var nums: [Int] = []

while let line = readLine() {
    nums.append(Int(line)!)
}

func countIncreases(numbers: [Int], windowSize: Int) -> Int {
    var increases: Int = 0
    for i in (0..<numbers.count - windowSize){
        if numbers[i + windowSize] > numbers[i] {
            increases = increases + 1
        }
    }
    return increases
}

print("Part one: \(countIncreases(numbers: nums, windowSize: 1))")
print("Part two: \(countIncreases(numbers: nums, windowSize: 3))")

